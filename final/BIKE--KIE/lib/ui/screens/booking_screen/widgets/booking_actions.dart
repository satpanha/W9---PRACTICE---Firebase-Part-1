import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/booking_model.dart';
import 'booking_helpers.dart';
import 'payment_dialog.dart';
import '../../success_screen/success_screen.dart';
import '../../pass_screen/view_model/pass_model.dart';
import '../../pass_screen/widgets/pass_screen_for_booking.dart';

class BookingActions {
  static void handleConfirmBooking(
    BuildContext context,
    BookingViewModel viewModel,
    VoidCallback onSuccess,
  ) async {
    final station = viewModel.station;
    if (station == null) {
      BookingSnackbars.showError(context, 'Station information is missing');
      return;
    }

    // Get first available bike
    final availableBike = station.availableBikes.firstWhere(
      (bike) => bike != null,
      orElse: () => null,
    );

    if (availableBike == null) {
      BookingSnackbars.showError(context, 'No bikes available at this station');
      return;
    }

    // Confirm booking (fast - no loading dialog needed)
    final booking = await viewModel.confirmBooking(availableBike.id);

    if (booking != null) {
      if (context.mounted) {
        // Navigate directly to success screen, passing the booking
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessScreen(booking: booking),
          ),
        );
      }
      onSuccess();
    } else {
      if (context.mounted) {
        BookingSnackbars.showError(
          context,
          viewModel.error ?? 'Booking failed. Please try again.',
        );
      }
    }
  }

  static void handleBrowsePasses(BuildContext context, VoidCallback onReturn) {
    final viewModel = context.read<BookingViewModel>();

    // Check if user already has a pass
    if (viewModel.hasActivePass) {
      // User has a pass, proceed directly to confirm booking
      handleConfirmBooking(context, viewModel, onReturn);
    } else {
      // User doesn't have a pass, navigate to pass screen
      // Use Navigator.push to allow returning back to booking screen after purchase
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => PassViewModel()..loadPasses(),
            child: const PassScreenForBooking(),
          ),
          fullscreenDialog: true,
        ),
      ).then((passWasPurchased) {
        // After returning from pass screen, check if pass was purchased
        if (passWasPurchased == true && viewModel.hasActivePass) {
          // Pass was purchased, proceed to confirm booking
          if (context.mounted) {
            handleConfirmBooking(context, viewModel, onReturn);
          }
        }
      });
    }
  }

  static void handleBuyTicket(BuildContext context) {
    final viewModel = context.read<BookingViewModel>();
    showDialog(
      context: context,
      builder: (dialogContext) => PaymentDialog(
        onConfirm: () {
          // Update state → notifyListeners() → UI rebuilds (W4)
          viewModel.buySingleTicket();
          // Close the payment dialog
          Navigator.pop(dialogContext);
          // Automatically proceed to confirm booking
          handleConfirmBooking(context, viewModel, () {});
        },
        onCancel: () {},
      ),
    );
  }
}
