import 'package:flutter/material.dart';
import 'package:growhub/config/constants/colors.dart';
import '../models/month_enum.dart';

/// A widget that displays the header of a calendar, including month/year
/// navigation controls and a centered current date display.
class CalendarHeader extends StatelessWidget {
  /// The current month being displayed.
  final DateTime currentMonth;

  /// Callback triggered when navigating to the next month.
  final VoidCallback onNextMonth;

  /// Callback triggered when navigating to the previous month.
  final VoidCallback onPreviousMonth;

  /// The default text style for the month name.
  static const _monthTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  /// The default text style for the year.
  static const _yearTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
  );

  /// The spacing between month and year text.
  static const _monthYearSpacing = 8.0;

  /// The width allocated for each navigation button.
  static const _navigationButtonWidth = 48.0;

  const CalendarHeader({
    super.key,
    required this.currentMonth,
    required this.onNextMonth,
    required this.onPreviousMonth,
  });

  @override
  Widget build(BuildContext context) {
    final isCurrentMonth = _isCurrentMonth(currentMonth);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: _navigationButtonWidth,
          child: _buildNavigationButton(
            icon: Icons.chevron_left,
            color: GHColors.black,
            onPressed: onPreviousMonth,
          ),
        ),
        Expanded(
          child: _buildMonthYearDisplay(),
        ),
        SizedBox(
          width: _navigationButtonWidth,
          child: isCurrentMonth
              ? _buildNavigationButton(
                  icon: Icons.chevron_right,
                  color: GHColors.grey,
                  onPressed: () {}, // Disabled for current month
                )
              : _buildNavigationButton(
                  icon: Icons.chevron_right,
                  color: GHColors.black,
                  onPressed: onNextMonth,
                ),
        ),
      ],
    );
  }

  /// Builds the centered month and year display section.
  Widget _buildMonthYearDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _getMonthName(currentMonth.month),
          style: _monthTextStyle,
        ),
        const SizedBox(width: _monthYearSpacing),
        Text(
          currentMonth.year.toString(),
          style: _yearTextStyle,
        ),
      ],
    );
  }

  /// Builds a navigation button with the specified icon and action.
  Widget _buildNavigationButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon),
      color: color,
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      visualDensity: VisualDensity.compact,
    );
  }

  /// Gets the name of the month for the given month index.
  String _getMonthName(int month) {
    return MonthExtension.fromIndex(month - 1).name;
  }


  /// Checks if the given date represents the current month.
  bool _isCurrentMonth(DateTime date) {
    final currentDate = DateTime.now();
    return date.year == currentDate.year && date.month == currentDate.month;
  }
}
