import 'package:bloc/bloc.dart';
import 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit()
      : super(
          CalendarState(
            currentMonth: DateTime.now(),
          ),
        );

  void nextMonth() {
    emit(state.copyWith(
      currentMonth: DateTime(state.currentMonth.year, state.currentMonth.month + 1),
    ));
  }

  void previousMonth() {
    emit(state.copyWith(
      currentMonth: DateTime(state.currentMonth.year, state.currentMonth.month - 1),
    ));
  }

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }
}
