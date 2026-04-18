import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../model/booking.dart';
import '../../../../ui/screens/booking_screen/view_model/booking_model.dart';
import '../../../../utils/app_theme.dart';
import '../../../../utils/animations_util.dart';

class SuccessContent extends StatefulWidget {
  final Booking? booking;

  const SuccessContent({super.key, this.booking});

  @override
  State<SuccessContent> createState() => _SuccessContentState();
}

class _SuccessContentState extends State<SuccessContent>
    with SingleTickerProviderStateMixin {
  // Local animation state - does NOT drill down (avoiding state drilling)
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();

    // Set the active booking on the BookingViewModel
    if (widget.booking != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          final bookingVM = context.read<BookingViewModel>();
          bookingVM.setActiveBooking(widget.booking!);
          debugPrint(
            'Booking set on success screen: ${widget.booking!.bikeId}',
          );
        } catch (e) {
          debugPrint('Error setting booking on success screen: $e');
        }
      });
    }
  }

  void _setupAnimation() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = AnimationUtils.createScaleAnimation(
      _controller,
      curve: Curves.elasticOut,
    );
    _fadeAnimation = AnimationUtils.createFadeAnimation(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    // Proper resource cleanup (Listenable pattern - like ChangeNotifier disposal)
    _controller.dispose();
    super.dispose();
  }

  void _backToMap() {
    // Pop with booking data so map screen can use it
    Navigator.pop(context, widget.booking);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Success Icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Success Title
                  const Text(
                    'Bike Booked!',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Success Message
                  Text(
                    'Your bike is now reserved.\nHead to the station to pick it up!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.gray600,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Back to Map Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: _backToMap,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Back to Map',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
