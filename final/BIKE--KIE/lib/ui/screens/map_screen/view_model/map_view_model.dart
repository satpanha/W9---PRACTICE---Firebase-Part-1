import 'package:flutter/foundation.dart';

import '../../../../../data/repositories/stationRepository/station_repository.dart';
import '../../../../../data/repositories/bookingRepository/booking_repository.dart';
import '../../../../model/station.dart';
import '../../../../model/booking.dart';
import '../../../../utils/async_value.dart';

class MapViewModel extends ChangeNotifier {
  final StationRepository _stationRepo;
  final BookingRepository? _bookingRepo;

  MapViewModel(this._stationRepo, {BookingRepository? bookingRepo})
      : _bookingRepo = bookingRepo {
    loadStations();
    loadActiveBooking();
  }

  AsyncValue<List<Station>> _state = AsyncValue<List<Station>>.loading();
  AsyncValue<List<Station>> get data => _state;
  
  Booking? _activeBooking;
  Booking? get activeBooking => _activeBooking;

  Future<void> loadStations() async {
    _state = AsyncValue.loading();
    notifyListeners();

    try {
      print('object');
      final stations = await _stationRepo.getStations();

      _state = AsyncValue<List<Station>>.success(stations);
    } catch (e) {
      print(e);
      _state = AsyncValue.error('Failed to load stations.');
    }
    notifyListeners();
  }

  Future<void> loadActiveBooking() async {
    try {
      if (_bookingRepo == null) return;
      
      final bookings = await _bookingRepo.getBookings();
      
      // Find the most recent active booking
      final now = DateTime.now();
      final activeBookings = bookings.where((b) => 
        b.isActive && b.expiryTime.isAfter(now)
      ).toList();
      
      if (activeBookings.isNotEmpty) {
        // Sort by expiry time to get the soonest one
        activeBookings.sort((a, b) => a.expiryTime.compareTo(b.expiryTime));
        _activeBooking = activeBookings.first;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to load active booking: $e');
    }
  }

  void clearActiveBooking() {
    _activeBooking = null;
    notifyListeners();
  }
}
