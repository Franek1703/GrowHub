import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:growhub/common/widgets/progress_indicator_small.dart';
import 'package:growhub/common/widgets/refresh_indicator.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/calendar/widgets/calendar_grid.dart';
import 'package:growhub/features/calendar/widgets/calendar_header.dart';
import 'package:growhub/config/constants/sizes.dart';
import '../../../features/api/data/models/dosage_history_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/api/cubit/dosage_history/dosage_history_cubit.dart';
import 'package:flutter_hooks/flutter_hooks.dart';


/// A page displaying a calendar with month navigation, date selection, and
/// interactive data bubbles.
class CalendarPage extends HookWidget {
  const CalendarPage({
    super.key,
    required this.deviceId,
  });

  /// The device ID used to fetch dosage history data.
  final int deviceId;

  @override
  Widget build(BuildContext context) {
    
    /// The current month displayed in the calendar.
  final currentMonth = useState(DateTime.now());

  /// The currently selected date.
  final selectedDate = useState<DateTime?>(null);

  /// Whether the bubble tooltip is visible.
  final isBubbleVisible = useState(false);

  /// Whether the page has been loaded for the first time.
  final isFirstLoaded = useState(false);

  /// Navigates to the next month.
  void _nextMonth() {
    currentMonth.value = DateTime(currentMonth.value.year, currentMonth.value.month + 1);
    isBubbleVisible.value = false;
  }

  /// Navigates to the previous month.
  void _previousMonth() {
    currentMonth.value = DateTime(currentMonth.value.year, currentMonth.value.month - 1);
    isBubbleVisible.value = false;
  }

  /// Selects a date and toggles the visibility of the data bubble.
  void _selectDate(DateTime date) {
    if (selectedDate.value == date) {
      isBubbleVisible.value = !isBubbleVisible.value;
    } else {
      selectedDate.value = date;
      isBubbleVisible.value = true;
    }
  }

  /// Closes the data bubble.
  void _closeBubble() {
    isBubbleVisible.value = false;
  }

  /// Load dosage history data when the widget is first built.
  useEffect(() {
  final dosageHistoryCubit = context.read<DosageHistoryCubit>();
  Future.microtask(() async {
    await dosageHistoryCubit.loadDosageHistory(deviceId);
    if (context.mounted) {
      isFirstLoaded.value = true;
    }
  });
  return null;
}, [deviceId]);

  /// Display a progress indicator until the page is loaded.
  return isFirstLoaded.value == false
    ? const GHProgressIndicatorSmall()
    : GHRefreshIndicator(
        onRefresh: () async {
          // Reload dosage history when the user performs a pull-to-refresh action.
          context.read<DosageHistoryCubit>().loadDosageHistory(deviceId);
        },
        child: Portal(
          child: GestureDetector(
            onTap: _closeBubble, // Close the bubble when tapping outside it.
            child: Scaffold(
              backgroundColor: GHColors.background,
              body: SafeArea(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                    ).copyWith(
                      top: GHSizes.topBarHeight,
                      bottom: GHSizes.bottomBarHeight,
                    ),
                    child: Column(
                      children: [
                        /// Header section displaying the current month and navigation controls.
                        CalendarHeader(
                          currentMonth: currentMonth.value,
                          onNextMonth: _nextMonth,
                          onPreviousMonth: _previousMonth,
                        ),
                        const SizedBox(height: 30),
                  
                        /// Main calendar grid displaying the days of the current month.
                        /// The grid is dynamically updated based on the state of the 
                        /// `DosageHistoryCubit`.
                        BlocBuilder<DosageHistoryCubit, DosageHistoryState>(
                          builder: (context, state) {
                            List<DosageHistoryModel> dosageHistory = [];
                  
                            // If the dosage history is loaded, extract the data.
                            if (state is DosageHistoryLoaded) {
                              dosageHistory = state.dosageHistory;
                             }
                  
                            return CalendarGrid(
                              currentMonth: currentMonth.value,
                              selectedDate: selectedDate.value,
                              isBubbleVisible: isBubbleVisible.value,
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
          ),
        )
      );
  }
}
