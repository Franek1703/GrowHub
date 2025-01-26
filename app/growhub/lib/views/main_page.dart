import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:growhub/config/assets.gen.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/bottom_app_bar/bottom_app_bar.dart';
import 'package:growhub/features/bottom_app_bar/cubit/path_cubit.dart';
import 'package:growhub/features/top_app_bar/top_app_bar.dart';

class MainPage extends HookWidget {
  final Widget child;
  final String path;
  const MainPage({super.key, required this.child, required this.path});

  @override
  Widget build(BuildContext context) {
    late Map<String, SvgGenImage> items;
    if (path.contains("/dashboard/")) {
      items = {
        "/dashboard/calendar": Assets.iconsUi.calendar,
        "/dashboard/sensor": Assets.iconsUi.thermometer,
        "/dashboard/settings": Assets.iconsUi.settings,
      };
    } else {
      items = {
        "/profile": Assets.iconsUi.user,
        "/dashboard": Assets.iconsUi.leaf,
        "/notification": Assets.iconsUi.bell
      };
    }

    late String appBarTitle;
    switch (path) {
      case "/dashboard":
        appBarTitle = "Dashboard";
        break;
      case "/profile":
        appBarTitle = "Account";
        break;
      case "/notification":
        appBarTitle = "Notifications";
        break;
      case "/dashboard/calendar":
        appBarTitle = "Calendar";
        break;
      case "/dashboard/sensor":
        appBarTitle = "Sensors";
        break;
      case "/dashboard/settings":
        appBarTitle = "Settings";
        break;
      default:
        appBarTitle = "GoGrow!!!!";
        break;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: GHColors.background,
      appBar: path != "/dashboard"
          ? GHTopAppBar(
              title: appBarTitle,
              onLeadingPressed: () {
                context.read<PathCubit>().onPathChange("/dashboard");
                context.pop();
              },
              showLeading: path.contains("/dashboard/"),
            )
          : null,
      body: Stack(
        children: [
          child,
          Positioned(
            bottom: 15,
            left: 0,
            right: 0,
            child: GHBottomAppBar(
              items: items,
            ),
          ),
        ],
      ),
    );
  }
}
