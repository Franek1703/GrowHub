import 'package:flutter/material.dart';
import 'package:growhub/config/assets.gen.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/notification/model/notification_model.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel tile;
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
        color: tile.isResolved
            ? GHColors.white
            : GHColors.transparent,
        boxShadow: [
          CustomBoxShadow(
                  color: GHColors.grey.withOpacity(0.1),
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
                            text: tile.message,
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    // "${duration.inHours.toString()} godzin temu",
                    _getNotificationTimeMessage(duration.inHours),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: GHColors.primary.withOpacity(0.7)),
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
                    icon: Icon(Icons.more_horiz, color: GHColors.primary,)
                    // Assets.icons.navigation.moreHorizontal.svg(
                    //     width: 20.sp,
                    //     height: 20.sp,
                    //     colorFilter: ColorFilter.mode(
                    //         context.colors.primary, BlendMode.srcIn))
                            ),
              ))
        ],
      ),
    );
  }
}
String _getNotificationTimeMessage(int hours) {
  if (hours == 0) {
    return 'less than an hour ago';
  } else if (hours == 1) {
    return 'an hour ago';
  } else if (hours == 2) {
    return 'two hours ago';
  } else if (hours == 3) {
    return 'three hours ago';
  } else if (hours == 4) {
    return 'four hours ago';
  } else {
    return '$hours hours ago';
  }
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
      if (debugDisableShadows)
        result.maskFilter = null;
      return true;
    }());
    return result;
  }
}