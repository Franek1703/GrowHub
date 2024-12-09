import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growhub/config/constants/colors.dart';
import '../../features/calendar/cubit/calendar_cubit.dart';
import 'package:growhub/features/calendar/widgets/calendar_grid.dart';
import 'package:growhub/features/calendar/widgets/calendar_header.dart';
import 'package:growhub/config/constants/sizes.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: GestureDetector(
        onTapDown: (details) {
          // Close only bubble when clicking outside
          context.read<CalendarCubit>().closeBubble();
        },
        child: Scaffold(
          backgroundColor: GHColors.background,
          body: const SafeArea(
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
                    SizedBox(height: 30),
                    CalendarGrid(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
