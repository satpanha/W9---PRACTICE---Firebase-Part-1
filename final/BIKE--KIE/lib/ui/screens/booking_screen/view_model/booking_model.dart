import 'package:flutter/foundation.dart';
import 'dart:async';
import '../../../../data/repositories/bookingRepository/booking_repository.dart';
import '../../../../data/repositories/stationRepository/station_repository.dart';
import '../../../../model/booking.dart';
import '../../../../model/pass.dart';
import '../../../../model/station.dart';
import '../../../../model/user.dart';

class BookingViewModel extends ChangeNotifier {
  final Station? _station;
  final BookingRepository _bookingRepository;
  final StationRepository _stationRepository;
  User _user = const User(id: 'user_001', activePass: null); // Mock user

  bool _isLoading = false;
  String? _error;

  // Booking tracking
  Booking? _activeBooking;
  Timer? _countdownTimer;

  BookingViewModel({
    Station? station,
    required BookingRepository bookingRepository,
    required StationRepository stationRepository,
  }) : _station = station,
       _bookingRepository = bookingRepository,
       _stationRepository = stationRepository {
    _loadActiveBooking();
  }

  Station? get station => _station;
  User get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Booking properties
  bool get hasActiveBooking =>
      _activeBooking != null &&
      _activeBooking!.isActive &&
      _activeBooking!.expiryTime.isAfter(DateTime.now());

  Booking? get activeBooking => _activeBooking;

  int get timeRemainingSeconds {
    if (_activeBooking == null) return 0;
    final remaining = _activeBooking!.expiryTime.difference(DateTime.now());
    return remaining.inSeconds > 0 ? remaining.inSeconds : 0;
  }

  String get formattedTimeRemaining {
    final seconds = timeRemainingSeconds;
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  /// Check if user has an active pass
  bool get hasActivePass => _user.activePass != null;

  /// Get active pass details
  String? get activePassType => _user.activePass?.type.name.replaceFirst(
    _user.activePass!.type.name[0],
    _user.activePass!.type.name[0].toUpperCase(),
  );

  String? get activePassEndDate =>
      _user.activePass?.endDate.toString().split(' ')[0];

  /// Load active booking from repository
  Future<void> _loadActiveBooking() async {
    try {
      final bookings = await _bookingRepository.getBookings();
      debugPrint('Loaded ${bookings.length} bookings from repository');

      final now = DateTime.now();

      final activeBookings = bookings
          .where((b) => b.isActive && b.expiryTime.isAfter(now))
          .toList();

      debugPrint('Found ${activeBookings.length} active bookings');

      if (activeBookings.isNotEmpty) {
        // Sort by expiry time and get the soonest one
        activeBookings.sort((a, b) => a.expiryTime.compareTo(b.expiryTime));
        _activeBooking = activeBookings.first;
        debugPrint(
          'Active booking set: ${_activeBooking?.bikeId} in station ${_activeBooking?.stationId}',
        );
        _startCountdownTimer();
        notifyListeners();
      } else {
        debugPrint('No active bookings found');
      }
    } catch (e) {
      debugPrint('Failed to load active booking: $e');
    }
  }

  /// Set active booking directly (useful when passed from booking screen)
  void setActiveBooking(Booking booking) {
    if (booking.isActive && booking.expiryTime.isAfter(DateTime.now())) {
      _activeBooking = booking;
      debugPrint(
        'Active booking set directly: ${booking.bikeId} in ${booking.stationId}',
      );
      _startCountdownTimer();
      notifyListeners();
    }
  }

  /// Refresh active booking (useful when returning to map screen)
  Future<void> refreshActiveBooking() async {
    await _loadActiveBooking();
  }

  /// Start countdown timer for active booking
  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_activeBooking == null) {
        _countdownTimer?.cancel();
        return;
      }

      if (!hasActiveBooking) {
        clearActiveBooking();
      } else {
        notifyListeners();
      }
    });
  }

  /// Clear active booking
  void clearActiveBooking() {
    _activeBooking = null;
    _countdownTimer?.cancel();
    notifyListeners();
  }

  /// Confirm booking with current pass
  Future<Booking?> confirmBooking(String bikeId) async {
    if (_station == null) {
      _error = 'Station information is missing';
      notifyListeners();
      return null;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Create booking in Firebase
      final booking = await _bookingRepository.createBooking(
        bikeId: bikeId,
        stationId: _station.id,
      );

      // Update station availability (non-blocking - fire and forget)
      _stationRepository
          .removeBikeFromStation(stationId: _station.id, bikeId: bikeId)
          .ignore(); // Ignore any errors from station update

      // Set as active booking
      _activeBooking = booking;
      _startCountdownTimer();

      _isLoading = false;
      notifyListeners();

      debugPrint(
        'Booking confirmed for station: ${_station.name} with bike: $bikeId',
      );

      return booking;
    } catch (e) {
      _error = 'Booking failed: $e';
      _isLoading = false;
      notifyListeners();
      debugPrint('Booking error: $e');
      return null;
    }
  }

  void buyAndSetPass(Pass passSelected) {
    _user = User(id: _user.id, activePass: passSelected);
    notifyListeners(); // Broadcast to all listening widgets
  }

  /// Simulate buying single ticket
  void buySingleTicket() {
    // Create a temporary single-use pass
    final singlePass = Pass(
      id: 'ticket_${DateTime.now().millisecondsSinceEpoch}',
      type: PassType.day,
      price: 5.0,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 1)),
      isActive: true,
    );
    _user = User(id: _user.id, activePass: singlePass);
    notifyListeners();
  }

  /// Set user with a pass after purchase
  void setUserWithPass(User userWithPass) {
    _user = userWithPass;
    notifyListeners();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
}
