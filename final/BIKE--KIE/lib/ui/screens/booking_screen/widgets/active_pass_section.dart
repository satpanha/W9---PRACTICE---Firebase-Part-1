import 'package:flutter/material.dart';
import '../../../../utils/app_theme.dart';
import 'booking_helpers.dart';
import 'pass_widgets.dart';

/// Shows active pass details (MVVM: View displays ViewModel state)
/// Data passed as params (not from watch - local props only)
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
