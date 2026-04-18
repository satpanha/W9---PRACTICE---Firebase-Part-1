import 'package:flutter/material.dart';
import '../../../../utils/app_theme.dart';

import 'ui_badges.dart';

/// Map preview section for booking
class MapPreviewSection extends StatelessWidget {
  const MapPreviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.map, size: 48, color: AppColors.gray400),
          const Positioned(bottom: 12, left: 12, child: MapPlaceholderBadge()),
        ],
      ),
    );
  }
}
