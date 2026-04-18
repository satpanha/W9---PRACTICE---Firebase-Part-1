import '../../model/bike.dart';

class BikeDto {
  static Bike fromJson(dynamic json) {
    try {
      // Handle different JSON formats
      if (json is Map<String, dynamic>) {
        // If it's already a bike object with id and batteryLevel
        if (json.containsKey('id')) {
          return Bike(
            id: json['id'] as String,
            batteryLevel: json['batteryLevel'] == 'n/a'
                ? null
                : json['batteryLevel'],
          );
        }
        // Otherwise, assume first entry is the bike ID
        final entry = json.entries.first;
        return Bike(
          id: entry.key,
          batteryLevel: entry.value == 'n/a' ? null : entry.value,
        );
      }

      // Fallback
      throw Exception('Invalid bike JSON format');
    } catch (e) {
      throw Exception('Failed to parse bike: $e');
    }
  }
}
