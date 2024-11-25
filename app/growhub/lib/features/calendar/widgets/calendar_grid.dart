import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/calendar_cubit.dart';
import '../cubit/calendar_state.dart';
import '../../../config/constants/colors.dart';
import 'calendar_bubble.dart';

/// A widget that displays an interactive calendar grid with date selection
/// and data indicators.
///
/// The grid automatically adjusts its layout based on the current month and
/// handles date selections with visual feedback. It supports showing additional
/// data indicators and tooltips for dates with associated information.
class CalendarGrid extends StatelessWidget {
  /// Visual constants for grid layout and styling
  static const double _cellBorderWidth = 2.0;
  static const double _fontSize = 14.0;
  static const double _gridSpacing = 2.0;
  
  /// Layout constants
  static const EdgeInsets _cellMargin = EdgeInsets.all(4.0);
  static const int _daysPerWeek = 7;
  
  /// Text styling
  static const TextStyle _dayTextStyle = TextStyle(
    fontSize: _fontSize,
    fontWeight: FontWeight.normal,
  );

  const CalendarGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) => _buildCalendarGrid(state),
    );
  }

  /// Builds the main calendar grid structure using the current state
  Widget _buildCalendarGrid(CalendarState state) {
    final gridParameters = _calculateGridParameters(state.currentMonth);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _daysPerWeek,
        mainAxisSpacing: _gridSpacing,
        crossAxisSpacing: _gridSpacing,
      ),
      itemCount: gridParameters.totalCells,
      itemBuilder: (context, index) => _buildGridCell(
        context,
        index,
        state,
        gridParameters,
      ),
    );
  }

  /// Builds an individual cell in the calendar grid
  ///
  /// Handles empty cells at the start of the month and creates interactive
  /// day cells with appropriate styling and data indicators.
  Widget _buildGridCell(
    BuildContext context,
    int index,
    CalendarState state,
    _GridParameters params,
  ) {
    // Return empty cell for offset days
    if (index < params.startOffset) {
      return const SizedBox.shrink();
    }

    final day = _calculateDayFromIndex(index, params.startOffset);
    final date = _createDateFromDay(state.currentMonth, day);
    final cellPosition = _calculateCellPosition(index);
    final hasData = _hasDataForDate(date);

    return CalendarBubble(
      dosage: _getDosageForDate(date),
      timestamp: _formatDateTimestamp(date),
      displayOnLeft: cellPosition.isRightmostColumn,
      displayOnRight: cellPosition.isLeftmostColumn,
      isVisible: hasData && state.selectedDate == date,
      child: _buildInteractiveCell(
        context,
        date,
        state,
        day,
        hasData,
      ),
    );
  }

  /// Creates an interactive cell with gesture detection
  Widget _buildInteractiveCell(
    BuildContext context,
    DateTime date,
    CalendarState state,
    int day,
    bool hasData,
  ) {
    return GestureDetector(
      onTap: () => _onDateSelected(context, date),
      child: _DayCell(
        day: day,
        isSelected: state.selectedDate == date,
        hasData: hasData,
      ),
    );
  }

  /// Calculates the day number from the grid index
  int _calculateDayFromIndex(int index, int startOffset) {
    return index - startOffset + 1;
  }

  /// Creates a DateTime object for the given day in the current month
  DateTime _createDateFromDay(DateTime currentMonth, int day) {
    return DateTime(
      currentMonth.year,
      currentMonth.month,
      day,
    );
  }

  /// Determines if the date has associated data
  ///
  /// TODO: Replace with actual data check logic
  bool _hasDataForDate(DateTime date) {
    return date.day % 2 == 0;
  }

  /// Gets the dosage value for a specific date
  ///
  /// TODO: Replace with actual dosage retrieval logic
  String _getDosageForDate(DateTime date) {
    return "26g";
  }

  /// Formats the date for display in the bubble tooltip
  String _formatDateTimestamp(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  final year = date.year.toString();
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  
  return "$day.$month.$year, $hour:$minute";
}

  /// Handles date selection interaction
  void _onDateSelected(BuildContext context, DateTime date) {
    context.read<CalendarCubit>().selectDate(date);
  }

  /// Calculates position-related properties for a grid cell
  _CellPosition _calculateCellPosition(int index) {
    final column = index % _daysPerWeek;
    return _CellPosition(
      isLeftmostColumn: column == 0,
      isRightmostColumn: column == _daysPerWeek - 1,
    );
  }

  /// Calculates grid layout parameters based on the current month
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
}

/// A widget representing a single day cell in the calendar grid.
class _DayCell extends StatelessWidget {
  /// The day number to display
  final int day;
  
  /// Whether this cell is currently selected
  final bool isSelected;
  
  /// Whether this cell has associated data
  final bool hasData;

  const _DayCell({
    required this.day,
    required this.isSelected,
    required this.hasData,
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
        child: Text(
          day.toString(),
          style: _getCellTextStyle(),
        ),
      ),
    );
  }

  /// Gets the appropriate background color based on cell state
  Color _getCellBackgroundColor() {
    return hasData ? GHColors.primary : GHColors.transparent;
  }

  /// Gets the appropriate text style based on cell state
  TextStyle _getCellTextStyle() {
    return CalendarGrid._dayTextStyle.copyWith(
      color: GHColors.black,
      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
    );
  }
}

/// Contains parameters for calculating and laying out the calendar grid.
class _GridParameters {
  /// Total number of days in the current month
  final int daysInMonth;
  
  /// Number of empty cells before the first day
  final int startOffset;
  
  /// Total number of cells needed in the grid
  final int totalCells;

  const _GridParameters({
    required this.daysInMonth,
    required this.startOffset,
    required this.totalCells,
  });
}

/// Represents the position-related properties of a cell in the grid
class _CellPosition {
  /// Whether the cell is in the leftmost column
  final bool isLeftmostColumn;
  
  /// Whether the cell is in the rightmost column
  final bool isRightmostColumn;

  const _CellPosition({
    required this.isLeftmostColumn,
    required this.isRightmostColumn,
  });
}