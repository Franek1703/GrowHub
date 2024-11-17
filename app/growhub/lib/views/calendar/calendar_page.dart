import 'package:flutter/material.dart';
import 'package:growhub/features/calendar/widgets/calendar_grid.dart';
import 'package:growhub/features/calendar/widgets/calendar_header.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar', style: TextStyle(fontWeight: FontWeight.bold,),),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            //TODO: add retun to dashboard here
          },
        ),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: kToolbarHeight,
            bottom: kBottomNavigationBarHeight,
          ), 
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CalendarHeader(),
                SizedBox(height: 16),
                CalendarGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}