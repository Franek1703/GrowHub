class FertilizingDeviceModel {
  final int id;
  final int activationTime;
  final int deviceId;

  FertilizingDeviceModel({
    required this.id,
    required this.activationTime,
    required this.deviceId,
  });

  factory FertilizingDeviceModel.fromJson(Map<String, dynamic> json) {
    return FertilizingDeviceModel(
      id: json['fertilizing_device_id'],
      activationTime: json['activation_time'],
      deviceId: json['device_id'],
    );
  }

  FertilizingDeviceModel copyWith({
    int? id,
    int? activationTime,
    int? deviceId,
  }) {
    return FertilizingDeviceModel(
      id: id ?? this.id,
      activationTime: activationTime ?? this.activationTime,
      deviceId: deviceId ?? this.deviceId,
    );
  }
}
