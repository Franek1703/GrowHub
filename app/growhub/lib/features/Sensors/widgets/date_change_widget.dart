import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SlidingDateRange extends StatelessWidget {
  final Function(DateTime startDate, DateTime endDate) onDateRangeChange;

  SlidingDateRange({required this.onDateRangeChange});

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            selectedDate = selectedDate.subtract(Duration(days: 7));
            onDateRangeChange(selectedDate, selectedDate.add(Duration(days: 7)));
          },
        ),
        Column(
          children: [
            Text('${selectedDate.day}.${selectedDate.month}'),
            Text('${selectedDate.year}'),
          ],
        ),
        IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: () {
            selectedDate = selectedDate.add(Duration(days: 7));
            onDateRangeChange(selectedDate, selectedDate.add(Duration(days: 7)));
          },
        ),
      ],
    );
  }
}
