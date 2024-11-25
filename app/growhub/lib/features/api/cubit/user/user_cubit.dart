import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growhub/features/api/api_repository.dart';
import 'package:growhub/features/api/data/models/user_model.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final ApiRepository apiRepository;

  UserCubit(this.apiRepository) : super(UserStateInitial());

  Future<void> login(String email, String password) async {
    emit(UserStateLoading());
    try {
      final user = await apiRepository.login(email, password);
      emit(UserStateLoaded(user: user));
    } catch (e) {
      emit(UserStateError(error: e.toString()));
    }
  }

  Future<void> autoLogin() async {
    emit(UserStateStartApp());
    try {
      final token = await apiRepository.getToken();
      if (token == null) {
        emit(UserStateInitial());
        return;
      }

      final isLoggedIn = await apiRepository.isUserLoggedIn(token);

      if (!isLoggedIn) {
        emit(UserStateInitial());
        return;
      }

      final user = await apiRepository.getUserData(token);

      emit(UserStateLoaded(user: user));
    } catch (e) {
      emit(UserStateError(error: e.toString()));
    }
  }
}
