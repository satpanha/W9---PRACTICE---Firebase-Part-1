import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../model/pass.dart';
import '../view_model/pass_model.dart';
import 'pass_content.dart';

/// Wrapper for PassContent when called from booking screen
/// Automatically returns to booking screen after successful pass purchase
class PassScreenForBooking extends StatefulWidget {
  const PassScreenForBooking({super.key});

  @override
  State<PassScreenForBooking> createState() => _PassScreenForBookingState();
}

class _PassScreenForBookingState extends State<PassScreenForBooking> {
  late PassViewModel _viewModel;
  Pass? _previousActivePass;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<PassViewModel>();
    // Store the current active pass to detect when it changes
    _previousActivePass = _viewModel.passes.cast<Pass?>().firstWhere(
      (p) => p != null && p.isActive,
      orElse: () => null,
    );

    // Listen for changes to detect successful purchase
    _viewModel.addListener(_checkForPurchase);
  }

  void _checkForPurchase() {
    final currentActivePass = _viewModel.passes.cast<Pass?>().firstWhere(
      (p) => p != null && p.isActive,
      orElse: () => null,
    );

    // Check if a new pass became active (purchase was successful)
    if (_previousActivePass == null && currentActivePass != null) {
      // Pass was purchased! Return to booking with true
      Navigator.of(context).pop(true);
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_checkForPurchase);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false when user tries to return
        Navigator.of(context).pop(false);
        return false;
      },
      child: const PassContent(),
    );
  }
}
