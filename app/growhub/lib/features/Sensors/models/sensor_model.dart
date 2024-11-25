class Sensor {
  final String name;
  final String unit;
  final double lastReading;
  final String lastReadingTime;
  Map<String, double> readings;

  Sensor({
    required this.name,
    required this.unit,
    required this.lastReading,
    required this.lastReadingTime,
    required this.readings,
  });

  void updateReadings(Map<String, double> newReadings) {
    readings = newReadings;
  }
}
