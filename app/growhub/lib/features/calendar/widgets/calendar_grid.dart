import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';
import '../cubit/calendar_cubit.dart';
import '../cubit/calendar_state.dart';
import '../../../config/constants/colors.dart';
import 'calendar_bubble.dart';

class CalendarGrid extends StatelessWidget {
  static const _cellMargin = EdgeInsets.all(4.0);
  static const _daysPerWeek = 7;
  static const _dayTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  const CalendarGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) => _buildCalendarGrid(state),
    );
  }

  Widget _buildCalendarGrid(CalendarState state) {
    final gridParameters = _calculateGridParameters(state.currentMonth);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _daysPerWeek,
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

  Widget _buildGridCell(
    BuildContext context,
    int index,
    CalendarState state,
    _GridParameters params,
  ) {
    if (index < params.startOffset) return const SizedBox.shrink();

    final day = index - params.startOffset + 1;
    final date = DateTime(
      state.currentMonth.year,
      state.currentMonth.month,
      day,
    );

    // Mock data for testing purposes (replace with real data from state)
    final hasData = date.day % 2 == 0; // Example: Highlight every other day
    final dosage = "26g"; // Example dosage

    return PortalTarget(
      visible: hasData && state.selectedDate == date,
      anchor: const Aligned(
        follower: Alignment.bottomCenter,
        target: Alignment.center,
        offset: Offset(0, -8),
      ),
      portalFollower: hasData
          ? CalendarBubble(
              dosage: dosage,
              timestamp: "${date.day}.${date.month}.${date.year},${date.hour}:${date.minute}",
            )
          : const SizedBox.shrink(),
      child: GestureDetector(
        onTap: () => _onDateSelected(context, date),
        child: _DayCell(
          day: day,
          isSelected: state.selectedDate == date,
          hasData: hasData,
        ),
      ),
    );
  }

  void _onDateSelected(BuildContext context, DateTime date) {
    context.read<CalendarCubit>().selectDate(date);
  }

  _GridParameters _calculateGridParameters(DateTime month) {
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final weekdayOfFirstDay = firstDayOfMonth.weekday;

    return _GridParameters(
      daysInMonth: daysInMonth,
      startOffset: weekdayOfFirstDay - 1,
      totalCells: daysInMonth + weekdayOfFirstDay - 1,
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final bool isSelected;
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
        color: hasData ? GHColors.primary : GHColors.transparent,
        border: Border.all(
          color: GHColors.black,
          width: 2.0,
        ),
      ),
      child: Center(
        child: Text(
          day.toString(),
          style: CalendarGrid._dayTextStyle.copyWith(
            color: GHColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _GridParameters {
  final int daysInMonth;
  final int startOffset;
  final int totalCells;

  const _GridParameters({
    required this.daysInMonth,
    required this.startOffset,
    required this.totalCells,
  });
}
