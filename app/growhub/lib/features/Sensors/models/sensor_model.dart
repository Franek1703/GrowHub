class Sensor {
  final String name;
  final String unit;
  final double lastReading;
  final int lastReadingTime;
  final Map<int, double> readings;

  Sensor({
    required this.name,
    required this.unit,
    required this.lastReading,
    required this.lastReadingTime,
    required this.readings,
  });
}
