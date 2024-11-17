import 'package:flutter/material.dart';
import 'package:growhub/config/routing.dart';
import 'package:growhub/features/device_dashboard/cubit/device_cubit_cubit.dart';
import 'package:growhub/features/calendar/cubit/calendar_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
         BlocProvider(
          create: (context) => DeviceCubit()..loadDevices(),
        ),
         BlocProvider(
          create: (context) => CalendarCubit(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: GHRouter().router,
      ),
    );
  }
}
