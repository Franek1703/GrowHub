
import 'package:go_router/go_router.dart';
import 'package:growhub/views/calendar/calendar_page.dart';
import 'package:growhub/views/dashboard/dashboard_page.dart';
import 'package:growhub/views/main_page.dart';
import 'package:growhub/views/notification/notification_page.dart';
import 'package:growhub/views/profile/profile_page.dart';
import 'package:growhub/views/sensors/sensors_page.dart';
import 'package:growhub/views/settings/settings_page.dart';

class GHRouter{
  final router = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainPage(),
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => DashboardPage(),
          routes: [
            GoRoute(
              path: 'sensor',
              builder: (context, state) => SensorsPage(),
            ),
            GoRoute(
              path: 'calendar',
              builder: (context, state) => CalendarPage(),
            ),
            GoRoute(
              path: 'settings',
              builder: (context, state) => SettingsPage(),
            ),
          ],
        ),
        GoRoute(
          path: '/notification',
          builder: (context, state) => NotificationPage(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => ProfilePage(),
        ),
      ],
    ),
  ],
);
}