import '../../../model/bike.dart';
import '../../../model/station.dart';
import '../../mock/mockData.dart';
import 'station_repository.dart';

class StationRepositoryMock implements StationRepository {
  // Keep track of stations in memory
  late final Map<String, Station> _stations;

  StationRepositoryMock() {
    _initializeStations();
  }

  void _initializeStations() {
    _stations = {};
    for (final station in MockData.stationRepositoryStations) {
      _stations[station.id] = station;
    }
  }

  Future<void> _simulateNetwork() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<List<Station>> getStations() async {
    await _simulateNetwork();
    return _stations.values.toList();
  }

  @override
  Future<void> removeBikeFromStation({
    required String stationId,
    required String bikeId,
  }) async {
    await _simulateNetwork();

    final station = _stations[stationId];
    if (station == null) {
      throw Exception('Station not found: $stationId');
    }

    // Find and remove the bike
    bool found = false;
    final updatedBikes = station.availableBikes.map<Bike?>((bike) {
      if (bike != null && bike.id == bikeId && !found) {
        found = true;
        return null; // Mark as empty slot
      }
      return bike;
    }).toList();

    if (!found) {
      throw Exception('Bike not found in station');
    }

    // Update station with modified bikes list
    _stations[stationId] = Station(
      id: station.id,
      name: station.name,
      totalSlots: station.totalSlots,
      latitude: station.latitude,
      longitude: station.longitude,
      availableBikes: updatedBikes,
    );
  }

  @override
  Future<void> addBikeToStation({
    required String stationId,
    required String bikeId,
  }) async {
    await _simulateNetwork();

    final station = _stations[stationId];
    if (station == null) {
      throw Exception('Station not found: $stationId');
    }

    // Find empty slot and add bike back
    bool added = false;
    final updatedBikes = station.availableBikes.map<Bike?>((bike) {
      if (bike == null && !added) {
        // This would require the original bike object, which we don't have
        // For now, just return null to keep empty slot
        added = true;
        return null;
      }
      return bike;
    }).toList();

    if (!added) {
      throw Exception('No empty slots available');
    }

    // Update station
    _stations[stationId] = Station(
      id: station.id,
      name: station.name,
      totalSlots: station.totalSlots,
      latitude: station.latitude,
      longitude: station.longitude,
      availableBikes: updatedBikes,
    );
  }
}
