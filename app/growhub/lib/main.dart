import 'package:flutter/material.dart';
import 'package:growhub/config/routing.dart';
import 'package:growhub/config/themes/theme.dart';
import 'package:growhub/features/sensors/cubit/sensor_cubit.dart';
import 'package:growhub/features/bottom_app_bar/cubit/path_cubit.dart';
import 'package:growhub/features/device_dashboard/cubit/device_cubit_cubit.dart';
import 'package:growhub/features/calendar/cubit/calendar_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growhub/features/notification/cubit/notification_cubit.dart';

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
        BlocProvider(
          create: (context) => SensorCubit(),
        ),
         BlocProvider(
          create: (context) => PathCubit(),
        ),
        BlocProvider(
          create: (context) => NotificationCubit()..init(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: GHRouter(isLoggedIn: true).router,
        theme: GHTheme.theme(context),
      ),
    );
  }
}
