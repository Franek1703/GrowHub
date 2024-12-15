import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/calendar/widgets/calendar_grid.dart';
import 'package:growhub/features/calendar/widgets/calendar_header.dart';
import 'package:growhub/config/constants/sizes.dart';
import '../../../features/api/data/models/dosage_history_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/api/cubit/dosage_history/dosage_history_cubit.dart';


/// A page displaying a calendar with month navigation, date selection, and
/// interactive data bubbles.
class CalendarPage extends StatefulWidget {
  const CalendarPage({
    super.key,
    required this.deviceId,
  });

  final int deviceId;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  /// The current month displayed in the calendar.
  DateTime currentMonth = DateTime.now();

  /// The currently selected date.
  DateTime? selectedDate;

  /// Whether the bubble tooltip is visible.
  bool isBubbleVisible = false;

  /// Navigates to the next month.
  void _nextMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
      isBubbleVisible = false;
    });
  }

  /// Navigates to the previous month.
  void _previousMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
      isBubbleVisible = false;
    });
  }

  /// Selects a date and toggles the visibility of the data bubble.
  void _selectDate(DateTime date) {
    setState(() {
      if (selectedDate == date) {
        isBubbleVisible = !isBubbleVisible;
      } else {
        selectedDate = date;
        isBubbleVisible = true;
      }
    });
  }

  /// Closes the data bubble.
  void _closeBubble() {
    setState(() {
      isBubbleVisible = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // Load dosage history for the current device
    context.read<DosageHistoryCubit>().loadDosageHistory(widget.deviceId);
  }

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: GestureDetector(
        onTap: _closeBubble,
        child: Scaffold(
          backgroundColor: GHColors.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
              ).copyWith(
                top: GHSizes.topBarHeight,
                bottom: GHSizes.bottomBarHeight,
              ),
              child: Column(
                children: [
                  /// Header displaying the current month and navigation controls.
                  CalendarHeader(
                    currentMonth: currentMonth,
                    onNextMonth: _nextMonth,
                    onPreviousMonth: _previousMonth,
                  ),
                  const SizedBox(height: 30),

                  /// Grid displaying the days of the current month.
                  BlocBuilder<DosageHistoryCubit, DosageHistoryState>(
                    builder: (context, state) {
                      List<DosageHistoryModel> dosageHistory = [];

                      if (state is DosageHistoryLoaded) {
                        dosageHistory = state.dosageHistory;
                      }


                      return CalendarGrid(
                        currentMonth: currentMonth,
                        selectedDate: selectedDate,
                        isBubbleVisible: isBubbleVisible,
                        onDateSelected: _selectDate, dosageHistory: dosageHistory,
                      );
                    }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
