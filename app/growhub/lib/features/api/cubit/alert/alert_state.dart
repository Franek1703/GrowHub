part of 'alert_cubit.dart';

sealed class AlertState extends Equatable {
  const AlertState();

  @override
  List<Object> get props => [];
}

final class AlertStateInitial extends AlertState {}

final class AlertStateLoaded extends AlertState {
  final Set<AlertModel> alerts;

  const AlertStateLoaded({required this.alerts});
}

final class AlertStateLoading extends AlertState {
  final Set<AlertModel>? alerts;

  const AlertStateLoading({this.alerts});
}

final class AlertStateError extends AlertState {
  final String error;

  const AlertStateError({required this.error});
  @override
  List<Object> get props => [error];
}
