import '../../../model/station.dart';

abstract class StationRepository {
  Future<List<Station>> getStations();

  /// Remove a bike from a station's available bikes (mark as booked)
  Future<void> removeBikeFromStation({
    required String stationId,
    required String bikeId,
  });

  /// Add a bike back to a station's available bikes (booking expired)
  Future<void> addBikeToStation({
    required String stationId,
    required String bikeId,
  });
}
