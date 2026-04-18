import 'package:flutter/material.dart';
import 'booking_helpers.dart';
import 'ui_badges.dart';

class NoPassSection extends StatelessWidget {
  const NoPassSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: WarningAlert(
        title: BookingConstants.noActivePass,
        message: BookingConstants.noPassWarning,
        backgroundColor: const Color(0xFFFFF3E0),
        borderColor: const Color(0xFFFFD54F),
      ),
    );
  }
}
