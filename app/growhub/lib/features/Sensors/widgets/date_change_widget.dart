import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SlidingDateRange extends HookWidget {
  const SlidingDateRange({
    super.key,
    required this.onDateRangeChange,
    this.visible = true,
  });

  final Function(DateTime startDate, DateTime endDate) onDateRangeChange;

  final bool visible;

  @override
  Widget build(BuildContext context) {
    final selectedDate = useState<DateTime>(DateTime.now());
    DateTime getStartDate(DateTime date) {
      return date.subtract(const Duration(days: 6));
    }

    String getDateRange(DateTime date) {
      DateTime startDate = getStartDate(date);
      DateTime endDate = date;

      return "${startDate.day}.${startDate.month} - ${endDate.day}.${endDate.month}";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Opacity(
        opacity: visible ? 1 : 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                selectedDate.value =
                    selectedDate.value.subtract(const Duration(days: 7));
                onDateRangeChange(
                  getStartDate(selectedDate.value),
                  selectedDate.value,
                );
              },
            ),
            Column(
              children: [
                Text(
                  getDateRange(selectedDate.value),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                // Text('${selectedDate.value.year}'),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                final today = DateTime.now();
                final nextWeekStartDate =
                    selectedDate.value.add(Duration(days: 7));

                // Blocking from seeing the future empty data
                if (nextWeekStartDate.isBefore(today) ||
                    nextWeekStartDate.isAtSameMomentAs(today)) {
                  selectedDate.value = nextWeekStartDate;
                }

                onDateRangeChange(
                  getStartDate(selectedDate.value),
                  selectedDate.value,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
