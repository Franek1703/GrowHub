part of 'user_cubit.dart';

abstract class UserState {}

final class UserStateInitial extends UserState {}

final class UserStateStartApp extends UserState {}

final class UserStateLoading extends UserState {}

final class UserStateError extends UserState {
  final String error;

  UserStateError({required this.error});
}

final class UserStateLoaded extends UserState {
  final UserModel user;

  UserStateLoaded({required this.user});
}

final class UserStateSignedUp extends UserState {
  final UserModel user;

  UserStateSignedUp({required this.user});
}
