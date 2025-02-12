import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growhub/features/api/api_repository.dart';
import 'package:growhub/features/api/data/models/user_model.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final ApiRepository apiRepository;

  UserCubit(this.apiRepository) : super(UserStateInitial());

  void loadUser(UserModel user) {
    emit(UserStateLoaded(user: user));
  }

  Future<void> login(String email, String password) async {
    emit(UserStateLoading());

    try {
      final token = await apiRepository.login(email, password);

      final user = await apiRepository.getUserData(token);

      await apiRepository.saveToken(token);

      emit(UserStateLoaded(user: user));
    } catch (e) {
      emit(UserStateError(error: e.toString()));
    }
  }

  Future<void> signUp(String username, String email, String password) async {
    emit(UserStateLoading());

    try {
      final token = await apiRepository.signUp(username, email, password);

      final user = await apiRepository.getUserData(token);

      await apiRepository.saveToken(token);

      emit(UserStateSignedUp(user: user));
    } catch (e) {
      emit(UserStateError(error: e.toString()));
    }
  }

  Future<void> autoLogin() async {
    emit(UserStateStartApp());

    try {
      final token = await apiRepository.getToken();
      print("Token: $token");

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

  Future<void> editUser(UserModel user) async {
    // TODO: Add support for that function
    emit(UserStateLoaded(user: user));
  }

  Future<void> singOut() async {
    await apiRepository.deleteToken();
    emit(UserStateInitial());
  }
}
