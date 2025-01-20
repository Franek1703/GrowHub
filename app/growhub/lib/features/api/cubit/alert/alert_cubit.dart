import 'package:bloc/bloc.dart';
import 'package:growhub/features/api/api_repository.dart';
import 'package:growhub/features/api/data/models/alert_model.dart';

part 'alert_state.dart';

class AlertCubit extends Cubit<AlertState> {
  final ApiRepository apiRepository;
  AlertCubit(this.apiRepository) : super(AlertStateInitial());
  Future<void> loadAlert() async {
    final state = this.state;
    if (state is AlertStateLoaded) {
      emit(AlertStateLoading(alerts: state.alerts));
    } else {
      emit(AlertStateLoading());
    }
    try {
      final token = await apiRepository.getToken();
      if (token == null) {
        emit(AlertStateInitial());
        return;
      }
      final alerts = await apiRepository.getAlerts(token);
      alerts.sort(
        (a, b) => -a.time.compareTo(b.time),
      );
      emit(AlertStateLoaded(alerts: alerts));
    } catch (e) {
      emit(AlertStateError(error: e.toString()));
    }
  }

  Future<void> markAsResolved(AlertModel alert) async {
    final state = this.state;
    if (state is AlertStateLoaded) {
      final token = await apiRepository.getToken();
      if (token == null) {
        return;
      }
      apiRepository.markAlertAsResolved(token, alert.id);
      state.alerts.firstWhere((element) => element == alert).isResolved = true;
      emit(AlertStateLoaded(alerts: [...state.alerts]));
    }
  }

  Future<void> deleteAlert(AlertModel alert) async {
    final state = this.state;
    if (state is AlertStateLoaded) {
      final token = await apiRepository.getToken();
      if (token == null) {
        return;
      }
      await apiRepository.deleteAlert(token, alert.id);
      emit(AlertStateLoaded(
          alerts: state.alerts.where((element) => element != alert).toList()));
    }
  }

  Future<void> refreshAlerts() async {
    final token = await apiRepository.getToken();
    if (token == null) {
      return;
    }
    final alerts = await apiRepository.getAlerts(token);
    emit(AlertStateLoaded(alerts: alerts));
  }
}
