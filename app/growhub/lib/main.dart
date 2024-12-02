import 'package:flutter/material.dart';
import 'package:growhub/common/widgets/loading_screen.dart';
import 'package:growhub/config/routing.dart';
import 'package:growhub/config/themes/theme.dart';
import 'package:growhub/features/api/api_repository.dart';
import 'package:growhub/features/api/core/api_client.dart';
import 'package:growhub/features/api/core/auth_client.dart';
import 'package:growhub/features/api/cubit/user/user_cubit.dart';
import 'package:growhub/features/api/services/api_service.dart';
import 'package:growhub/features/api/services/auth_service.dart';
import 'package:growhub/features/api/services/secure_storage_service.dart';
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
    // Clients
    final authClient = AuthClient();
    final apiClient = ApiClient();

    // Services
    final authService = AuthService(authClient);
    final apiService = ApiService(apiClient);
    final secureStorageService = SecureStorageService();

    // Repository
    final apiRepository = ApiRepository(
      authService: authService,
      apiService: apiService,
      secureStorageService: secureStorageService,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DeviceCubit()..loadDevices(),
        ),
        BlocProvider(
          create: (context) => CalendarCubit(),
        ),
        BlocProvider(
            create: (context) => UserCubit(apiRepository)..autoLogin()),
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
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserStateStartApp) {
            return const MaterialApp(
              home: LoadingScreen(),
            );
          }

          final isLoggedIn = state is UserStateLoaded;
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: GHRouter(isLoggedIn: isLoggedIn).router,
            theme: GHTheme.theme(context),
          );
        },
      ),
    );
  }
}
