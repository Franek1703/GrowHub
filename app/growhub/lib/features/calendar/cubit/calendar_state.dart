import 'package:equatable/equatable.dart';

class CalendarState extends Equatable {
  final DateTime currentMonth;
  final DateTime? selectedDate;
  final List<DateTime> highlightedDates;
  final bool isBubbleVisible;

  const CalendarState({
    required this.currentMonth,
    this.selectedDate,
    this.highlightedDates = const [],
    this.isBubbleVisible = false,
  });


  CalendarState copyWith({
    DateTime? currentMonth,
    DateTime? selectedDate,
    List<DateTime>? highlightedDates,
    bool? isBubbleVisible,
  }) {
    return CalendarState(
      currentMonth: currentMonth ?? this.currentMonth,
      selectedDate: selectedDate,
      highlightedDates: highlightedDates ?? this.highlightedDates,
      isBubbleVisible: isBubbleVisible ?? this.isBubbleVisible,
    );
  }

  @override
  List<Object?> get props => [currentMonth, selectedDate, highlightedDates, isBubbleVisible];
}
