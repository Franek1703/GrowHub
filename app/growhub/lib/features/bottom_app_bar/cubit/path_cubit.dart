import 'package:flutter_bloc/flutter_bloc.dart';

class PathCubit extends Cubit<String> {
  PathCubit() : super("/dashboard");

  void onPathChange(String newPath) {
    emit(newPath);
  }
}
