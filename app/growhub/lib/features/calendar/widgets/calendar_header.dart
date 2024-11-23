import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/calendar_cubit.dart';
import '../cubit/calendar_state.dart';
import '../models/month_enum.dart';

/* 
  A widget that displays the header of a calendar, including month/year
  navigation controls and current date display with centered text 
*/
class CalendarHeader extends StatelessWidget {
  // The default text style for the month name
  static const _monthTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  // The default text style for the year
  static const _yearTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
  );

  // The spacing between month and year text
  static const _monthYearSpacing = 8.0;

  // The width allocated for each navigation button
  static const _navigationButtonWidth = 48.0;

  const CalendarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) => _buildHeader(context, state),
    );
  }

  // Builds the main header widget with navigation controls and centered date display
  Widget _buildHeader(BuildContext context, CalendarState state) {
    final isCurrentMonth = _isCurrentMonth(state.currentMonth);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Left navigation area with fixed width
        SizedBox(
          width: _navigationButtonWidth,
          child: _buildNavigationButton(
            icon: Icons.chevron_left,
            onPressed: () => _onPreviousMonth(context),
          ),
        ),
        // Expanded center area to ensure month/year stays centered
        Expanded(
          child: _buildMonthYearDisplay(state),
        ),
        // Right navigation area with fixed width
        SizedBox(
          width: _navigationButtonWidth,
          child: isCurrentMonth
              ? const SizedBox.shrink() // Empty space to maintain layout
              : _buildNavigationButton(
                  icon: Icons.chevron_right,
                  onPressed: () => _onNextMonth(context),
                ),
        ),
      ],
    );
  }

  // Builds the centered month and year display section
  Widget _buildMonthYearDisplay(CalendarState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _getMonthName(state.currentMonth),
          style: _monthTextStyle,
        ),
        const SizedBox(width: _monthYearSpacing),
        Text(
          state.currentMonth.year.toString(),
          style: _yearTextStyle,
        ),
      ],
    );
  }

  // Builds a navigation button with the specified icon and action
  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      visualDensity: VisualDensity.compact, 
    );
  }

  // Handles the previous month navigation action
  void _onPreviousMonth(BuildContext context) {
    context.read<CalendarCubit>().previousMonth();
  }

  // Handles the next month navigation action
  void _onNextMonth(BuildContext context) {
    context.read<CalendarCubit>().nextMonth();
  }

  // Extracts the month name from the Month enum
  String _getMonthName(DateTime date) {
    return Month.values[date.month - 1].toString().split('.').last;
  }

  // Checks if the given date represents the current month
  bool _isCurrentMonth(DateTime date) {
    final currentDate = DateTime.now();
    return date.year == currentDate.year && date.month == currentDate.month;
  }
}