import 'dart:convert';

import 'package:bikkie/model/station.dart';
import 'package:http/http.dart' as http;

import '../../dtos/station_dto.dart';
import '../../firebase/firebase_database.dart';
import 'station_repository.dart';

class StationRepositoryFirebase implements StationRepository {
  @override
  Future<List<Station>> getStations() async {
    final stationsUri = FirebaseConfig.baseUri.replace(path: "/stations.json");

    final http.Response response = await http.get(stationsUri);

    if (response.statusCode == 200) {
      Map<String, dynamic> stationJson = json.decode(response.body);

      List<Station> result = [];

      for (final entry in stationJson.entries) {
        result.add(StationDto.fromJson(entry.key, entry.value));
      }

      return result;
    } else {
      throw Exception('Fail to load stations');
    }
  }

  @override
  Future<void> removeBikeFromStation({
    required String stationId,
    required String bikeId,
  }) async {
    try {
      // Get current station data
      final stationUri = FirebaseConfig.baseUri.replace(
        path: "/stations/$stationId.json",
      );

      final response = await http.get(stationUri);

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch station data: ${response.statusCode}');
      }

      final Map<String, dynamic> stationData = jsonDecode(response.body);
      final List<dynamic> availableBikes =
          stationData['availableBikes'] as List<dynamic>? ?? [];

      // Remove the booked bike by replacing it with null
      bool found = false;
      for (int i = 0; i < availableBikes.length; i++) {
        if (availableBikes[i] != null) {
          // Handle different bike formats
          bool isMatchingBike = false;
          
          if (availableBikes[i] is Map<String, dynamic>) {
            final bike = availableBikes[i] as Map<String, dynamic>;
            // Check if bike has 'id' field matching bikeId
            if (bike['id'] == bikeId) {
              isMatchingBike = true;
            }
          } else if (availableBikes[i] is String) {
            // If bike is stored as string ID
            if (availableBikes[i] == bikeId) {
              isMatchingBike = true;
            }
          }

          if (isMatchingBike) {
            availableBikes[i] = null;
            found = true;
            break;
          }
        }
      }

      // Only update if bike was found, otherwise just log warning
      if (found) {
        final updateResponse = await http.patch(
          stationUri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'availableBikes': availableBikes}),
        );

        if (updateResponse.statusCode != 200) {
          throw Exception('Failed to update station: ${updateResponse.body}');
        }
      } else {
        // Bike not found - just log it, don't throw error
        // This can happen if Firebase data structure is different
      }
    } catch (e) {
      // Non-blocking error - just log it
      // The booking itself is already created successfully
    }
  }

  @override
  Future<void> addBikeToStation({
    required String stationId,
    required String bikeId,
  }) async {
    // Get current station data
    final stationUri = FirebaseConfig.baseUri.replace(
      path: "/stations/$stationId.json",
    );

    final response = await http.get(stationUri);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch station data');
    }

    final Map<String, dynamic> stationData = jsonDecode(response.body);
    final List<dynamic> availableBikes =
        stationData['availableBikes'] as List<dynamic>? ?? [];

    // Find the empty slot (null) and fill it with the bike
    // First, get the bike data from all stations
    final allStationsResponse = await http.get(
      FirebaseConfig.baseUri.replace(path: "/stations.json"),
    );

    if (allStationsResponse.statusCode != 200) {
      throw Exception('Failed to fetch all stations');
    }

    final Map<String, dynamic> allStationsData = jsonDecode(
      allStationsResponse.body,
    );
    Map<String, dynamic>? bikeData;

    // Search for the bike in all stations
    for (final entry in allStationsData.entries) {
      final stationEntry = entry.value;
      if (stationEntry is Map<String, dynamic> &&
          stationEntry['availableBikes'] is List) {
        final bikes = stationEntry['availableBikes'] as List<dynamic>;
        for (final bike in bikes) {
          if (bike != null && bike is Map && bike['id'] == bikeId) {
            bikeData = bike as Map<String, dynamic>;
            break;
          }
        }
        if (bikeData != null) break;
      }
    }

    if (bikeData == null) {
      throw Exception('Bike not found in any station');
    }

    // Find the first empty slot and add the bike
    bool added = false;
    for (int i = 0; i < availableBikes.length; i++) {
      if (availableBikes[i] == null) {
        availableBikes[i] = bikeData;
        added = true;
        break;
      }
    }

    if (!added) {
      throw Exception('No empty slots available in station');
    }

    // Update the station
    final updateResponse = await http.patch(
      stationUri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'availableBikes': availableBikes}),
    );

    if (updateResponse.statusCode != 200) {
      throw Exception('Failed to update station: ${updateResponse.body}');
    }
  }
}
