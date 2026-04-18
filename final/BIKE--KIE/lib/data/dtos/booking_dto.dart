import '../../model/booking.dart';

class BookingDto {
  static const String idKey = "id";
  static const String bikeIdKey = "bikeId";
  static const String stationIdKey = "stationId";
  static const String bookingTimeKey = "bookingTime";
  static const String expiryTimeKey = "expiryTime";
  static const String isActiveKey = "isActive";

  /// Convert Booking model to JSON for Firebase
  static Map<String, dynamic> toJson(Booking booking) {
    return {
      idKey: booking.id,
      bikeIdKey: booking.bikeId,
      stationIdKey: booking.stationId,
      bookingTimeKey: booking.bookingTime.toIso8601String(),
      expiryTimeKey: booking.expiryTime.toIso8601String(),
      isActiveKey: booking.isActive,
    };
  }

  /// Convert JSON from Firebase to Booking model
  static Booking fromJson(Map<String, dynamic> json) {
    try {
      final bookingTime = _parseDateTime(json[bookingTimeKey]);
      final expiryTime = _parseDateTime(json[expiryTimeKey]);

      return Booking(
        id: json[idKey] as String? ?? 'unknown',
        bikeId: json[bikeIdKey] as String? ?? 'unknown',
        stationId: json[stationIdKey] as String? ?? 'unknown',
        bookingTime: bookingTime,
        expiryTime: expiryTime,
        isActive: json[isActiveKey] as bool? ?? false,
      );
    } catch (e) {
      print('Error parsing booking JSON: $e');
      rethrow;
    }
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String && value.isEmpty) return DateTime.now();
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        print('Failed to parse datetime string: $value - $e');
        return DateTime.now();
      }
    }
    if (value is DateTime) return value;
    return DateTime.now();
  }
}
