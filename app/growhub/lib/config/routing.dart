
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:growhub/views/calendar/calendar_page.dart';
import 'package:growhub/views/dashboard/dashboard_page.dart';
import 'package:growhub/views/login/login_page.dart';
import 'package:growhub/views/login/signup_page.dart';
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
  profile("/profile"),
  login("/login"),
  signup("/signup");

  const GHRoutePath(this.path);
  final String path;
}

class GHRouter {
  final bool isLoggedIn;

  GHRouter({required this.isLoggedIn});
  late final router = GoRouter(
    initialLocation:
        isLoggedIn ? GHRoutePath.dashboard.path : GHRoutePath.login.path,
    routes: [
      GoRoute(
        path: GHRoutePath.login.path,
        pageBuilder: (context, state) => const MaterialPage(
          child: LoginPage(),
        ),
      ),
      GoRoute(
        path: GHRoutePath.signup.path,
        pageBuilder: (context, state) => const MaterialPage(
          child: SignupPage(),
        ),
      ),
      ShellRoute(
        builder: (context, state, child) => MainPage(
          path: state.fullPath!,
          child: child,
        ),
        routes: [
          GoRoute(
            path: GHRoutePath.dashboard.path,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardPage(),
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
    redirect: (context, state) {
      final isGoingToLogin = state.matchedLocation == GHRoutePath.login.path ||
          state.matchedLocation == GHRoutePath.signup.path;

      if (!isLoggedIn && !isGoingToLogin) {
        return GHRoutePath.login.path;
      }

      if (isLoggedIn && isGoingToLogin) {
        return GHRoutePath.dashboard.path;
      }

      return null;
    },
  );
}
