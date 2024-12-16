import 'package:intl/intl.dart';

class DosageHistoryModel {
  final double dose;
  final DateTime dosedAt;

  DosageHistoryModel({
    required this.dose,
    required this.dosedAt,
  });

  factory DosageHistoryModel.fromJson(Map<String, dynamic> json) {
    try {
      final dose = json['dose']?.toDouble() ?? 0.0;
      final dateFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");
      final dosedAt = dateFormat.parse(json['dosed_at']);
      return DosageHistoryModel(dose: dose, dosedAt: dosedAt);
    } catch (e) {
      throw FormatException('Invalid dosage data: $json');
    }
  }
}
