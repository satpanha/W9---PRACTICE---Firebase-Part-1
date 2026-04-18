import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/stationRepository/station_repository.dart';
import '../../../data/repositories/bookingRepository/booking_repository.dart';
import 'view_model/map_view_model.dart';
import '../booking_screen/view_model/booking_model.dart';
import 'widgets/map_content.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stationRepository = context.read<StationRepository>();
    final bookingRepository = context.read<BookingRepository>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MapViewModel(
            stationRepository,
            bookingRepo: bookingRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => BookingViewModel(
            bookingRepository: bookingRepository,
            stationRepository: stationRepository,
          ),
        ),
      ],
      child: const MapContent(),
    );
  }
}
