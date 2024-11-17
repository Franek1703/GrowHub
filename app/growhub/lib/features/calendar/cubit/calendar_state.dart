import 'package:equatable/equatable.dart';

class CalendarState extends Equatable {
  final DateTime currentMonth;
  final DateTime? selectedDate;
  final List<DateTime> highlightedDates;

  const CalendarState({
    required this.currentMonth,
    this.selectedDate,
    this.highlightedDates = const [],
  });


  CalendarState copyWith({
    DateTime? currentMonth,
    DateTime? selectedDate,
    List<DateTime>? highlightedDates,
  }) {
    return CalendarState(
      currentMonth: currentMonth ?? this.currentMonth,
      selectedDate: selectedDate,
      highlightedDates: highlightedDates ?? this.highlightedDates,
    );
  }

  @override
  List<Object?> get props => [currentMonth, selectedDate, highlightedDates];
}
