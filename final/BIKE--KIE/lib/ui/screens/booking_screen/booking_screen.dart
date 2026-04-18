import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/bookingRepository/booking_repository.dart';
import '../../../data/repositories/stationRepository/station_repository.dart';
import '../../../model/station.dart';
import 'view_model/booking_model.dart';
import 'widgets/booking_content.dart';

class BookingScreen extends StatelessWidget {
  final Station? station;

  const BookingScreen({super.key, this.station});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingViewModel(
        station: station,
        bookingRepository: context.read<BookingRepository>(),
        stationRepository: context.read<StationRepository>(),
      ),
      child: const BookingContent(),
    );
  }
}
