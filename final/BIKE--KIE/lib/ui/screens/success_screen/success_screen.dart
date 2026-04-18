import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/booking.dart';
import '../../../../data/repositories/bookingRepository/booking_repository.dart';
import '../../../../data/repositories/stationRepository/station_repository.dart';
import 'view_model/success_model.dart';
import '../../../../ui/screens/booking_screen/view_model/booking_model.dart';
import 'widgets/success_content.dart';

class SuccessScreen extends StatelessWidget {
  final Booking? booking;

  const SuccessScreen({super.key, this.booking});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SuccessModel()),
        ChangeNotifierProvider(
          create: (_) => BookingViewModel(
            bookingRepository: context.read<BookingRepository>(),
            stationRepository: context.read<StationRepository>(),
          ),
        ),
      ],
      child: SuccessContent(booking: booking),
    );
  }
}
