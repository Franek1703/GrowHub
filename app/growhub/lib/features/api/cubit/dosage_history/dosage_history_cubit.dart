import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growhub/features/api/api_repository.dart';
import 'package:growhub/features/api/data/models/dosage_history_model.dart';

part 'dosage_history_state.dart';

/// A Cubit class that manages the state of dosage history for a specific device.
/// It communicates with the `ApiRepository` to fetch data and updates the UI state accordingly.
class DosageHistoryCubit extends Cubit<DosageHistoryState> {
  final ApiRepository apiRepository;

  /// Constructor for initializing the Cubit with the required `ApiRepository`.
  /// The initial state is set to `DosageHistoryInitial`.
  DosageHistoryCubit(this.apiRepository) : super(DosageHistoryInitial());

  /// Fetches the dosage history for a specific device using the provided `deviceId`.
  /// It handles state transitions and API responses gracefully.
  Future<void> loadDosageHistory(int deviceId) async {
    final currentState = state;

    // Emit a loading state, retaining the previous dosage history if available.
    emit(currentState is DosageHistoryLoaded
        ? DosageHistoryLoading(currentState.dosageHistory)
        : DosageHistoryLoading(null));

    try {
      // Retrieve the authentication token from the repository.
      final token = await apiRepository.getToken();

      // If the token is null, reset the state to initial and exit.
      if (token == null) {
        emit(DosageHistoryInitial());
        return;
      }

      // Fetch dosage history data from the API using the token and deviceId.
      final response = await apiRepository.getDosageHistory(token, deviceId);

      // Process the response and convert it into a list of `DosageHistoryModel` objects.
      final dosageHistory = (response as List<dynamic>).map((item) {
        if (item is DosageHistoryModel) {
          // If the item is already a model, retain it.
          return item;
        } else if (item is Map<String, dynamic>) {
          // If the item is a map, convert it into a `DosageHistoryModel`.
          return DosageHistoryModel.fromJson(item);
        } else {
          // Throw an error if the item type is unexpected.
          throw FormatException('Invalid item type: $item');
        }
      }).toList();

      // Emit the loaded state with the parsed dosage history data.
      emit(DosageHistoryLoaded(dosageHistory));
    } catch (e) {
      // Log the error for debugging and emit an error state.
      print('Error: $e');
      emit(DosageHistoryError(e.toString()));
    }
  }
}
