import 'package:flutter/material.dart';
import 'package:growhub/common/widgets/loading_screen.dart';
import 'package:growhub/config/routing.dart';
import 'package:growhub/config/themes/theme.dart';
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
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: GHRouter(isLoggedIn: false).router,
        theme: GHTheme.theme(context),
      ),
    );
  }
}
