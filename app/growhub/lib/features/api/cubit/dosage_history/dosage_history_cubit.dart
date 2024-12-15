import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growhub/features/api/api_repository.dart';
import 'package:growhub/features/api/data/models/dosage_history_model.dart';

part  'dosage_history_state.dart';

class DosageHistoryCubit extends Cubit<DosageHistoryState> {
  final ApiRepository apiRepository;

  DosageHistoryCubit({required this.apiRepository})
      : super(DosageHistoryInitial());

  Future<void> fetchDosageHistory(String token, int deviceId) async {
    emit(DosageHistoryLoading());
    try {
      final dosageHistory =
          await apiRepository.getDosageHistory(token, deviceId);
      emit(DosageHistoryLoaded(dosageHistory));
    } catch (e) {
      emit(DosageHistoryError('Failed to fetch dosage history: $e'));
    }
  }
}
