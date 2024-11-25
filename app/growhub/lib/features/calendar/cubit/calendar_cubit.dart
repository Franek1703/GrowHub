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
      isBubbleVisible: false,
    ));
  }

  void previousMonth() {
    emit(state.copyWith(
      currentMonth: DateTime(state.currentMonth.year, state.currentMonth.month - 1),
      isBubbleVisible: false,
    ));
  }

  void selectDate(DateTime date) {
    if(state.selectedDate == date){
      emit(state.copyWith(isBubbleVisible: !state.isBubbleVisible));
    }
    else{
      emit(state.copyWith(
        selectedDate: date,
        isBubbleVisible: true,
        ));
    }
  }

  void closeBubble() {
    emit(state.copyWith(isBubbleVisible: false));
  }

  
}
