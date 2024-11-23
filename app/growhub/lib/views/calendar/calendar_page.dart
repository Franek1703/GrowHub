import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:growhub/features/calendar/widgets/calendar_grid.dart';
import 'package:growhub/features/calendar/widgets/calendar_header.dart';
import 'package:growhub/features/top_app_bar/top_app_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:growhub/config/constants/sizes.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: GHTopAppBar(
        title: 'Calendar',
        // onLeadingPressed: () => context.go('/dashboard'),
        showLeading: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: GHSizes.topBarHeight,
            bottom: GHSizes.bottomBarHeight,
          ), 
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CalendarHeader(),
                SizedBox(height: 16),
                Portal(child: CalendarGrid()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}