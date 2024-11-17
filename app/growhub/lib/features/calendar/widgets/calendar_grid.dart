import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/calendar_cubit.dart';
import '../cubit/calendar_state.dart';
import '../../../config/constants/colors.dart';

class CalendarGrid extends StatelessWidget {
  const CalendarGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        final daysInMonth = DateUtils.getDaysInMonth(
          state.currentMonth.year,
          state.currentMonth.month,
        );

        final firstDayOfMonth = DateTime(state.currentMonth.year, state.currentMonth.month, 1);
        final weekdayOfFirstDay = firstDayOfMonth.weekday;

        return Flexible(
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
            ),
            itemCount: daysInMonth + weekdayOfFirstDay - 1,
            itemBuilder: (context, index) {
              if (index < weekdayOfFirstDay - 1) return const SizedBox.shrink();

              final day = index - weekdayOfFirstDay + 2;
              final date = DateTime(state.currentMonth.year, state.currentMonth.month, day);

              final isSelected = state.selectedDate == date;

              return GestureDetector(
                onTap: () => context.read<CalendarCubit>().selectDate(date),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? GHColors().primary : Colors.transparent,
                    border: Border.all(color: GHColors().black),
                  ),
                  child: Center(
                    child: Text(
                      "$day",
                      style: TextStyle(
                        color: GHColors().black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
