part of 'alert_cubit.dart';

abstract class AlertState {}

final class AlertStateInitial extends AlertState {}

final class AlertStateLoaded extends AlertState {
  final List<AlertModel> alerts;

  AlertStateLoaded({required this.alerts});
}

final class AlertStateLoading extends AlertState {
  final List<AlertModel>? alerts;

  AlertStateLoading({this.alerts});
}

final class AlertStateError extends AlertState {
  final String error;

  AlertStateError({required this.error});
}
