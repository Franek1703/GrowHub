import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:growhub/features/device_dashboard/entities/device_icon.dart';
import 'package:growhub/features/pop-up/dialog.dart';
import 'package:growhub/features/pop-up/icon-choice/widgets/icon_circle.dart';

void showIconPopupDialog(BuildContext context, Widget popup) {
  showDialog(
    barrierColor: Colors.black.withOpacity(0.6),
    context: context,
    builder: (BuildContext context) {
      return popup;
    },
  );
}

class IconPopUp extends HookWidget {
  const IconPopUp({
    super.key,
    required this.startIcon,
    required this.onIconSelected,
  });

  final DeviceIcon startIcon;
  final Function(DeviceIcon icon) onIconSelected;

  @override
  Widget build(BuildContext context) {
    final currentIcon = useState(startIcon);
    return GHDialog(
      title: "Choose icon.",
      body: Wrap(
        children: [
          ...DeviceIcon.values.map(
            (icon) => IconCircle(
              icon: icon,
              active: currentIcon.value == icon,
              onPressed: () {
                currentIcon.value = icon;
              },
            ),
          )
        ],
      ),
      onCheckmarkPressed: () {
        onIconSelected(currentIcon.value);
      },
    );
  }
}
