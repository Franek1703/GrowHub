class Sensor {
  final String name;
  final String unit;
  final double lastReading;
  final DateTime lastReadingTime;
  Map<DateTime, double> readings;

  Sensor({
    required this.name,
    required this.unit,
    required this.lastReading,
    required this.lastReadingTime,
    required this.readings,
  });

  void updateReadings(Map<DateTime, double> newReadings) {
    readings = newReadings;
  }
}
