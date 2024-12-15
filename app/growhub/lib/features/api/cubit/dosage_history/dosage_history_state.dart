part of 'dosage_history_cubit.dart';

abstract class DosageHistoryState {}

class DosageHistoryInitial extends DosageHistoryState {}

class DosageHistoryLoading extends DosageHistoryState {}

class DosageHistoryLoaded extends DosageHistoryState {
  final List<DosageHistoryModel> dosageHistory;

  DosageHistoryLoaded(this.dosageHistory);
}

class DosageHistoryError extends DosageHistoryState {
  final String message;

  DosageHistoryError(this.message);
}
