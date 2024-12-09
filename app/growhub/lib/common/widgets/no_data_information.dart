import 'package:flutter/material.dart';
import 'package:growhub/config/constants/colors.dart';

enum NoDataInformationText { noDevices, noSensors }

extension AppTextExtension on NoDataInformationText {
  String get text {
    switch (this) {
      case NoDataInformationText.noDevices:
        return "It seems like you don't have any devices yet 😕 \n Try swiping up!";
      case NoDataInformationText.noSensors:
        return "It seems like you don't have any sensors yet 😭 \n Try swiping up!";
    }
  }
}

class NoDataInformation extends StatelessWidget {
  const NoDataInformation({
    super.key,
    required this.title,
  });

  final NoDataInformationText title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        textAlign: TextAlign.center,
        title.text,
        style: TextStyle(
          fontSize: 22,
          color: GHColors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
