// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:growhub/features/api/api_repository.dart';
// import 'package:growhub/features/api/data/models/dosage_history_model.dart';

// part 'dosage_history_state.dart';

// class DosageHistoryCubit extends Cubit<DosageHistoryState> {
//   final ApiRepository apiRepository;

//   DosageHistoryCubit(this.apiRepository) : super(DosageHistoryInitial());

//   Future<void> loadDosageHistory(int deviceId) async {
//     final currentState = state;

//     if (currentState is DosageHistoryLoaded) {
//       emit(DosageHistoryLoading(currentState.dosageHistory));
//     } else {
//       emit(DosageHistoryLoading(null));
//     }

//     try {
//       final token = await apiRepository.getToken();

//       if (token == null) {
//         emit(DosageHistoryInitial());
//         return;
//       }

//       final dosageHistory =
//           await apiRepository.getDosageHistory(token, deviceId);

//       emit(DosageHistoryLoaded(dosageHistory));
//     } catch (e) {
//       emit(DosageHistoryError(e.toString()));
//     }
//   }
// }
