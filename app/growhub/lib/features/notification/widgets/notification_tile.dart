import 'package:flutter/material.dart';
import 'package:growhub/config/assets.gen.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/api/data/models/alert_model.dart';

class NotificationTile extends StatelessWidget {
  final AlertModel tile;
  final void Function() onTileMenuOpen;
  const NotificationTile(
      {super.key, required this.tile, required this.onTileMenuOpen});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final duration = now.difference(tile.time);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: tile.isResolved ? GHColors.white : GHColors.transparent,
        boxShadow: [
          CustomBoxShadow(
              color: GHColors.grey.withOpacity(0.5),
              blurRadius: 6,
              offset: const Offset(2, 2),
              blurStyle: BlurStyle.outer)
        ],
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                      width: 16,
                      height: 16,
                      child: Assets.iconsUi.bell.svg(
                          colorFilter: const ColorFilter.mode(
                              Colors.red, BlendMode.srcIn))))),
          Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text: "Attention! ",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600)),
                        TextSpan(
                            text:
                                "Device:${tile.deviceName}, Sensor:${tile.sensorName}, Message:${tile.message}, Value:${tile.value}",
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    _getNotificationTimeMessage(duration.inHours),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: GHColors.black),
                  ),
                  Builder(
                    builder: (context) {
                      if (tile.isResolved && tile.resolvedTime != null) {
                        final resolvedDuration =
                            now.difference(tile.resolvedTime!);
                        return Text(
                          "Resolved: ${_getNotificationTimeMessage(resolvedDuration.inHours)}",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: GHColors.grey),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  )
                ],
              )),
          Expanded(
              flex: 1,
              child: SizedBox(
                width: 22,
                height: 22,
                child: IconButton(
                    padding: const EdgeInsets.all(0.0),
                    onPressed: () {
                      onTileMenuOpen();
                    },
                    icon: Icon(
                      Icons.more_horiz,
                      color: GHColors.black,
                    )),
              ))
        ],
      ),
    );
  }
}

String _getNotificationTimeMessage(int hours) {
  int time = hours;

  if (hours == 1) {
    return '$time hour ago';
  }

  if (hours >= 24 && hours < 48) {
    time = 1;
    return '$time day ago';
  }
  if (hours >= 48) {
    time = hours ~/ 24;
    return '$time days ago';
  }

  return '$time hours ago';
}

class CustomBoxShadow extends BoxShadow {
  final BlurStyle blurStyle;

  const CustomBoxShadow({
    Color color = const Color(0xFF000000),
    Offset offset = Offset.zero,
    double blurRadius = 0.0,
    this.blurStyle = BlurStyle.normal,
  }) : super(color: color, offset: offset, blurRadius: blurRadius);

  @override
  Paint toPaint() {
    final Paint result = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(this.blurStyle, blurSigma);
    assert(() {
      if (debugDisableShadows) result.maskFilter = null;
      return true;
    }());
    return result;
  }
}
