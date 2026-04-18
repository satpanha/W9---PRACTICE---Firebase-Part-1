import 'package:flutter/material.dart';
import '../../../../model/pass.dart';

/// Booking screen constants
class BookingConstants {
  // Titles and labels
  static const String screenTitle = 'Stations Details';
  static const String headerTitle = 'Confirm Your Booking';
  static const String headerSubtitle = 'Ready for your ride across Toulouse?';

  // Sections
  static const String activeSubscription = 'ACTIVE SUBSCRIPTION';
  static const String noActivePass = 'No Active Pass';
  static const String bookingFee = 'INCLUDED';
  static const String validUntil = 'Valid Until';

  // Buttons
  static const String confirmBooking = 'CONFIRM BOOKING';
  static const String browsePasses = 'BROWSE PASSES';
  static const String buyTicket = 'BUY TICKET';

  // Messages
  static const String mapView = 'MAP VIEW';
  static const String noStationSelected = 'No station selected';
  static const String bookingSuccess = '✓ Bike booked successfully!';
  static const String ticketPurchaseSuccess =
      '✓ Ticket purchased! You can now book a bike.';
  static const String noPassWarning =
      'You need a pass to book. Choose an option below.';

  // Payment
  static const String confirmPurchase = 'Confirm Purchase';
  static const String duration = 'Duration';
  static const String price = 'Price';
  static const String payOnline = 'Pay online to complete purchase';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
}

/// Utilities for booking screen
class BookingUtils {
  static String formatPassTypeName(PassType type) {
    final name = type.name;
    return name.replaceFirst(name[0], name[0].toUpperCase());
  }

  static String formatDateForDisplay(DateTime date) {
    return date.toString().split(' ')[0];
  }

  static String getLocationText(int availableBikes) {
    return 'Sector 1 • $availableBikes bikes available';
  }

  static String getPassStatusText(bool hasPass) {
    return hasPass ? 'ACTIVE SUBSCRIPTION' : 'No Active Pass';
  }
}

/// Helper class for showing snackbars in booking screen
class BookingSnackbars {
  static void showBookingSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('✓ Bike booked successfully!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  static void showTicketPurchaseSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('✓ Ticket purchased! You can now book a bike.'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
