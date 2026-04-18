import 'package:flutter/material.dart';
import '../../../../utils/app_theme.dart';
import 'booking_helpers.dart';

/// Location icon badge component
class LocationIconBadge extends StatelessWidget {
  final double size;
  final double iconSize;

  const LocationIconBadge({super.key, this.size = 44, this.iconSize = 22});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.location_on, color: AppColors.primary, size: iconSize),
    );
  }
}

/// Map placeholder badge showing "MAP VIEW" label
class MapPlaceholderBadge extends StatelessWidget {
  const MapPlaceholderBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        BookingConstants.mapView,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Reusable alert/warning component
class WarningAlert extends StatelessWidget {
  final String title;
  final String message;
  final Color? backgroundColor;
  final Color? borderColor;

  const WarningAlert({
    super.key,
    required this.title,
    required this.message,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primaryVeryLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor ?? AppColors.primary),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: borderColor ?? AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.gray600,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
