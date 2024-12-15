import 'package:flutter/material.dart';
import '../../../config/constants/colors.dart';
import 'calendar_bubble.dart';
import '../../../features/api/data/models/dosage_history_model.dart';

/// A widget that displays an interactive calendar grid with date selection
/// and customizable visual indicators.
///
/// This widget automatically adjusts its layout based on the provided month
/// and highlights the selected date. It supports optional data indicators
/// displayed in customizable bubbles.
class CalendarGrid extends StatelessWidget {
  /// The current month being displayed.
  final DateTime currentMonth;

  /// The currently selected date.
  final DateTime? selectedDate;

  /// Whether to show the data bubble for selected dates.
  final bool isBubbleVisible;

  /// Callback triggered when a date is selected.
  final void Function(DateTime date) onDateSelected;

  /// The dosage history data to display in the grid.
  final List<DosageHistoryModel> dosageHistory;

  /// Visual constants for the grid layout.
  static const double _cellSpacing = 4.0;
  static const double _cellBorderWidth = 2.0;
  static const double _fontSize = 14.0;

  /// Layout constants.
  static const int _daysPerWeek = 7;
  static const EdgeInsets _cellMargin = EdgeInsets.all(4.0);

  /// Text styling for day cells.
  static const TextStyle _dayTextStyle = TextStyle(
    fontSize: _fontSize,
    fontWeight: FontWeight.normal,
  );

  const CalendarGrid({
    super.key,
    required this.currentMonth,
    required this.selectedDate,
    required this.isBubbleVisible,
    required this.onDateSelected,
    required this.dosageHistory,
  });

  @override
  Widget build(BuildContext context) {
    final gridParameters = _calculateGridParameters(currentMonth);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _daysPerWeek,
        mainAxisSpacing: _cellSpacing,
        crossAxisSpacing: _cellSpacing,
      ),
      itemCount: gridParameters.totalCells,
      itemBuilder: (context, index) {
        if (index < gridParameters.startOffset) {
          return const SizedBox.shrink();
        }

        final day = _calculateDayFromIndex(index, gridParameters.startOffset);
        final date = DateTime(currentMonth.year, currentMonth.month, day);

        final cellPosition = _calculateCellPosition(index);

        return GestureDetector(
          onTap: () => onDateSelected(date),
          child: _DayCell(
            day: day,
            isSelected: selectedDate == date,
            hasData: _hasDataForDate(date),
            bubbleContent: CalendarBubble(
              dosageHistory: _getDosageHistoryForDate(date),
              isVisible: isBubbleVisible && selectedDate == date,
              displayOnLeft: cellPosition.isRightmostColumn,
              displayOnRight: cellPosition.isLeftmostColumn,
              child: const SizedBox.shrink(),
            ),
          ),
        );
      },
    );
  }

  // New method to get dosage history for a specific date
  DosageHistoryModel _getDosageHistoryForDate(DateTime date) {
    return dosageHistory.firstWhere(
      (history) => 
        history.dosedAt.year == date.year &&
        history.dosedAt.month == date.month &&
        history.dosedAt.day == date.day,
      orElse: () => DosageHistoryModel(dose: 0.0, dosedAt: date)
    );
  }

  /// Calculates the day number from the grid index.
  int _calculateDayFromIndex(int index, int startOffset) {
    return index - startOffset + 1;
  }

  /// Determines if the date has associated data.
  ///
  /// TODO: Replace with actual data check logic.
  // Modify existing methods
  bool _hasDataForDate(DateTime date) {
    return dosageHistory.any((history) => 
      history.dosedAt.year == date.year &&
      history.dosedAt.month == date.month &&
      history.dosedAt.day == date.day
    );
  }

  /// Gets the dosage value for a specific date.
  ///
  /// TODO: Replace with actual dosage retrieval logic.
  String _getDosageForDate(DateTime date) {
    return "26g";
  }

  /// Formats the date for display in the bubble tooltip.
  String _formatDateTimestamp(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return "$day.$month.$year";
  }

  /// Calculates grid layout parameters based on the current month.
  _GridParameters _calculateGridParameters(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final startOffset = firstDayOfMonth.weekday - 1;

    return _GridParameters(
      daysInMonth: daysInMonth,
      startOffset: startOffset,
      totalCells: daysInMonth + startOffset,
    );
  }

  /// Calculates position-related properties for a grid cell.
  _CellPosition _calculateCellPosition(int index) {
    final column = index % _daysPerWeek;
    return _CellPosition(
      isLeftmostColumn: column == 0,
      isRightmostColumn: column == _daysPerWeek - 1,
    );
  }
}

/// Represents the position-related properties of a cell in the grid.
class _CellPosition {
  /// Whether the cell is in the leftmost column.
  final bool isLeftmostColumn;

  /// Whether the cell is in the rightmost column.
  final bool isRightmostColumn;

  const _CellPosition({
    required this.isLeftmostColumn,
    required this.isRightmostColumn,
  });
}

/// Contains parameters for calculating and laying out the calendar grid.
class _GridParameters {
  /// Total number of days in the current month.
  final int daysInMonth;

  /// Number of empty cells before the first day.
  final int startOffset;

  /// Total number of cells needed in the grid.
  final int totalCells;

  const _GridParameters({
    required this.daysInMonth,
    required this.startOffset,
    required this.totalCells,
  });
}

/// A widget representing a single day cell in the calendar grid.
class _DayCell extends StatelessWidget {
  /// The day number to display.
  final int day;

  /// Whether this cell is currently selected.
  final bool isSelected;

  /// Whether this cell has associated data.
  final bool hasData;

  /// The bubble content for the cell.
  final Widget bubbleContent;

  const _DayCell({
    required this.day,
    required this.isSelected,
    required this.hasData,
    required this.bubbleContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: CalendarGrid._cellMargin,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getCellBackgroundColor(),
        border: Border.all(
          color: GHColors.black,
          width: CalendarGrid._cellBorderWidth,
        ),
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              day.toString(),
              style: _getCellTextStyle(),
            ),
            if (hasData) bubbleContent,
          ],
        ),
      ),
    );
  }

  /// Gets the appropriate background color based on cell state.
  Color _getCellBackgroundColor() {
    return hasData ? GHColors.primary : GHColors.transparent;
  }

  /// Gets the appropriate text style based on cell state.
  TextStyle _getCellTextStyle() {
    return CalendarGrid._dayTextStyle.copyWith(
      color: GHColors.black,
      fontWeight: hasData ? FontWeight.bold : FontWeight.normal,
    );
  }
}
