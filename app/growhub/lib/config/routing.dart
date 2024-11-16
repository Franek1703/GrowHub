import 'package:go_router/go_router.dart';
import 'package:growhub/views/calendar/calendar_page.dart';
import 'package:growhub/views/dashboard/dashboard_page.dart';
import 'package:growhub/views/main_page.dart';
import 'package:growhub/views/notification/notification_page.dart';
import 'package:growhub/views/profile/profile_page.dart';
import 'package:growhub/views/sensors/sensors_page.dart';
import 'package:growhub/views/settings/settings_page.dart';

class GHRouter {
  final router = GoRouter(
    initialLocation: '/dashboard',
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainPage(
          path: state.fullPath!,
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardPage(),
            ),
            routes: [
              GoRoute(
                  path: 'sensor',
                  pageBuilder: (context, state) => const NoTransitionPage(
                        child: SensorsPage(),
                      )),
              GoRoute(
                  path: 'calendar',
                  pageBuilder: (context, state) => const NoTransitionPage(
                        child: CalendarPage(),
                      )),
              GoRoute(
                  path: 'settings',
                  pageBuilder: (context, state) => const NoTransitionPage(
                        child: SettingsPage(),
                      )),
            ],
          ),
          GoRoute(
              path: '/notification',
              pageBuilder: (context, state) => const NoTransitionPage(
                    child: NotificationPage(),
                  )),
          GoRoute(
              path: '/profile',
              pageBuilder: (context, state) => const NoTransitionPage(
                    child: ProfilePage(),
                  )),
        ],
      ),
    ],
  );
}
