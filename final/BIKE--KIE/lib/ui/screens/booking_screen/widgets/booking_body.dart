import 'package:flutter/material.dart';
import '../../../../model/station.dart';
import '../view_model/booking_model.dart';
import 'booking_layout.dart';
import 'station_card_widget.dart';
import 'pass_widgets.dart';
import 'no_pass_widgets.dart';
import 'booking_buttons.dart';
import 'booking_helpers.dart';


class BookingBody extends StatelessWidget {
  final Station station;
  final BookingViewModel viewModel;
  final VoidCallback onBrowsePasses;
  final VoidCallback onBuyTicket;
  final VoidCallback onConfirmBooking;

  const BookingBody({
    super.key,
    required this.station,
    required this.viewModel,
    required this.onBrowsePasses,
    required this.onBuyTicket,
    required this.onConfirmBooking,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildSections(),
      ),
    );
  }

  List<Widget> _buildSections() => [
    Padding(
      padding: const EdgeInsets.all(16),
      child: BookingHeader(
        title: BookingConstants.headerTitle,
        subtitle: BookingConstants.headerSubtitle,
      ),
    ),
    const SizedBox(height: 8),
    StationCardWidget(station: station),
    const SizedBox(height: 20),
    _buildPassSection(),
    const SizedBox(height: 24),
    _buildActionSection(),
    const SizedBox(height: 20),
  ];

  Widget _buildPassSection() {
    /// 🎯 Conditional Rendering (W4 Observer Pattern)
    /// UI adapts based on ViewModel state: viewModel.hasActivePass
    ///
    /// When state changes (user buys pass):
    /// 1. ViewModel.buyAndSetPass() updates _user
    /// 2. Calls notifyListeners()
    /// 3. BookingContent rebuilds (context.watch)
    /// 4. _buildPassSection() re-runs
    /// 5. Shows ActivePassSection instead of NoPassSection
    ///
    /// This is pure View logic - no business logic here!
    if (!viewModel.hasActivePass) {
      return const NoPassSection();
    }

    return ActivePassSection(
      passTypeName: viewModel.activePassType ?? 'Unknown Pass',
      validUntil: viewModel.activePassEndDate ?? 'N/A',
    );
  }

  Widget _buildActionSection() {
    /// 🎬 Dynamic UI based on User State (W4, W5)
    ///
    /// If HAS active pass → Show ConfirmButton
    ///   → User taps → calls onConfirmBooking callback
    ///   → bookingActions.handleConfirmBooking()
    ///   → ViewModel.confirmBooking() (business logic)
    ///   → repository.createBooking() (data access)
    ///   → Updates state + notifyListeners()
    ///   → Navigation to SuccessScreen
    ///
    /// If NO active pass → Show PassSelectionButtons
    ///   → Browse Passes or Buy Ticket
    ///   → Each action calls ViewModel methods
    ///   → State updated, UI re-renders
    ///
    /// This demonstrates MVVM: View adapts to ViewModel state!
    return viewModel.hasActivePass
        ? ConfirmButton(onPressed: onConfirmBooking)
        : PassSelectionButtons(
            viewModel: viewModel,
            onBrowsePasses: onBrowsePasses,
            onBuyTicket: onBuyTicket,
          );
  }
}
