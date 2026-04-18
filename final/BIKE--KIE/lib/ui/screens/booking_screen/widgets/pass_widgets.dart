import 'package:flutter/material.dart';
import '../../../../utils/app_theme.dart';
import 'booking_helpers.dart';
import 'detail_rows.dart';

/// Shows active pass details section
class ActivePassSection extends StatelessWidget {
  final String passTypeName;
  final String validUntil;

  const ActivePassSection({
    super.key,
    required this.passTypeName,
    required this.validUntil,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            BookingConstants.activeSubscription,
            style: const TextStyle(
              color: AppColors.gray600,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          PassInfoCard(passTypeName: passTypeName, validUntil: validUntil),
        ],
      ),
    );
  }
}

/// Card displaying active pass information
class PassInfoCard extends StatelessWidget {
  final String passTypeName;
  final String validUntil;

  const PassInfoCard({
    super.key,
    required this.passTypeName,
    required this.validUntil,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            passTypeName,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PassDetailItem(label: 'Valid Until', value: validUntil),
              PassDetailItem(label: 'Booking Fee', value: 'INCLUDED'),
            ],
          ),
        ],
      ),
    );
  }
}
