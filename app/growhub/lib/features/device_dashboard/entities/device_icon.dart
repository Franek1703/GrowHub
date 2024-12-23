import 'package:growhub/config/assets.gen.dart';

// Watch out! Since there is something fucked up on the backend side
// DevicIcon indexes start from 1, not from 0.
enum DeviceIcon {
  cactus,
  daisy,
  flower1,
  flower2,
  flower3,
  plant,
  sprout;

  String get path {
    switch (this) {
      case DeviceIcon.cactus:
        return Assets.kwiatki.cactusSvgrepoCom.path;
      case DeviceIcon.daisy:
        return Assets.kwiatki.daisySvgrepoCom.path;
      case DeviceIcon.flower1:
        return Assets.kwiatki.flowerRoseSvgrepoCom.path;
      case DeviceIcon.flower2:
        return Assets.kwiatki.flowerSvgrepoCom1.path;
      case DeviceIcon.flower3:
        return Assets.kwiatki.flowerSvgrepoCom2.path;
      case DeviceIcon.plant:
        return Assets.kwiatki.plantSvgrepoCom.path;
      case DeviceIcon.sprout:
        return Assets.kwiatki.sproutPlantSvgrepoCom.path;
    }
  }

  static DeviceIcon fromIndex(int index) {
    // Adjust for 1-based indexing
    final adjustedIndex = index - 1;

    if (adjustedIndex >= 0 && adjustedIndex < DeviceIcon.values.length) {
      return DeviceIcon.values[adjustedIndex];
    } else {
      return DeviceIcon.cactus;
    }
  }

  int get adjustedIndex {
    return index + 1;
  }
}
