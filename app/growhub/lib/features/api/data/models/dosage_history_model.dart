class DosageHistoryModel{
  final double dose;
  final DateTime dosedAt;

  DosageHistoryModel({
    required this.dose,
    required this.dosedAt,
  });


  factory DosageHistoryModel.fromJson(Map<String, dynamic> json) {
    return DosageHistoryModel(
      dose: json['dose']?.toDouble() ?? 0.0,
      dosedAt: DateTime.parse(json['dosed_at']),
    );
  }
}