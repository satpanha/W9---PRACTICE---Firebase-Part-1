import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../dtos/booking_dto.dart';
import '../../firebase/firebase_database.dart';
import '../../../model/booking.dart';
import 'booking_repository.dart';

class BookingRepositoryFirebase implements BookingRepository {
  @override
  Future<Booking> createBooking({
    required String bikeId,
    required String stationId,
  }) async {
    final now = DateTime.now();
    final booking = Booking(
      id: 'booking_${now.millisecondsSinceEpoch}',
      bikeId: bikeId,
      stationId: stationId,
      bookingTime: now,
      expiryTime: now.add(const Duration(minutes: 15)),
      isActive: true,
    );

    final bookingsUri = FirebaseConfig.baseUri.replace(
      path: '/bookings/${booking.id}.json',
    );

    try {
      final response = await http
          .put(
            bookingsUri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(BookingDto.toJson(booking)),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Firebase request timeout'),
          );

      // Accept 200 (update) or 200 with different responses as success
      if (response.statusCode == 200 || response.statusCode == 201) {
        return booking;
      } else {
        throw Exception(
          'Failed to create booking: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  @override
  Future<List<Booking>> getBookings() async {
    final bookingsUri = FirebaseConfig.baseUri.replace(path: '/bookings.json');

    final response = await http.get(bookingsUri);

    if (response.statusCode == 200) {
      final body = response.body;
      if (body == 'null' || body.isEmpty) {
        return [];
      }

      try {
        final Map<String, dynamic> bookingsJson = jsonDecode(body);
        final List<Booking> bookings = [];

        for (final entry in bookingsJson.entries) {
          try {
            if (entry.value is Map<String, dynamic>) {
              bookings.add(
                BookingDto.fromJson(entry.value as Map<String, dynamic>),
              );
            }
          } catch (e) {
            print('Error parsing booking ${entry.key}: $e');
            // Skip malformed bookings
            continue;
          }
        }

        return bookings;
      } catch (e) {
        print('Error decoding bookings: $e');
        return [];
      }
    } else {
      throw Exception('Failed to load bookings: ${response.statusCode}');
    }
  }
}
