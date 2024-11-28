import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';


class PathCubit extends Cubit<String> {
  PathCubit() : super("/dashboard");

  void onPathChange(String newPath) {
    emit(newPath);
  }
}
