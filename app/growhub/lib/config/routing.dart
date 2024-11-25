import 'package:go_router/go_router.dart';
import 'package:growhub/views/calendar/calendar_page.dart';
import 'package:growhub/views/dashboard/dashboard_page.dart';
import 'package:growhub/views/main_page.dart';
import 'package:growhub/views/notification/notification_page.dart';
import 'package:growhub/views/profile/profile_page.dart';
import 'package:growhub/views/sensors/sensors_page.dart';
import 'package:growhub/views/settings/settings_page.dart';

enum GHRoutePath {
  root("/"),
  dashboard("/dashboard"),
  sensor("/sensor"),
  calendar("/calendar"),
  settings("settings"),
  notification("/notification"),
  profile("/profile");

  const GHRoutePath(this.path);
  final String path;
}

class GHRouter {
  final router = GoRouter(
    initialLocation: GHRoutePath.dashboard.path,
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainPage(
          path: state.fullPath!,
          child: child,
        ),
        routes: [
          GoRoute(
            path: GHRoutePath.dashboard.path,
            pageBuilder: (context, state) => NoTransitionPage(
              child: CalendarPage(),
            ),
            routes: [
              GoRoute(
                  path: GHRoutePath.sensor.path,
                  pageBuilder: (context, state) => const NoTransitionPage(
                        child: SensorsPage(),
                      )),
              GoRoute(
                  path: GHRoutePath.calendar.path,
                  pageBuilder: (context, state) => const NoTransitionPage(
                        child: CalendarPage(),
                      )),
              GoRoute(
                  path: GHRoutePath.settings.path,
                  pageBuilder: (context, state) => const NoTransitionPage(
                        child: SettingsPage(),
                      )),
            ],
          ),
          GoRoute(
              path: GHRoutePath.notification.path,
              pageBuilder: (context, state) => const NoTransitionPage(
                    child: NotificationPage(),
                  )),
          GoRoute(
              path: GHRoutePath.profile.path,
              pageBuilder: (context, state) => const NoTransitionPage(
                    child: ProfilePage(),
                  )),
        ],
      ),
    ],
  );
}
