
class SensorMinMax{
  double getSensorMin(String sensor){
    switch(sensor.toLowerCase()){
      case "temp":
        return -55.0;
      case "tds":
        return 0.0;
      case "ph":
        return 0.0;
      case "humidity":
        return 0.0;
      default:
        return 0.0;
    }
  }
  double getSensorMax(String sensor){
    switch(sensor.toLowerCase()){
      case "temp":
        return 125.0;
      case "tds":
        return 1500.0;
      case "ph":
        return 14.0;
      case "humidity":
        return 100.0;
      default:
        return 100.0;
    }
  }
}