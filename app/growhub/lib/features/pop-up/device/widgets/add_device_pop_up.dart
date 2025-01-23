import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/pop-up/device/widgets/qr_frame_painter.dart';
import 'package:growhub/features/pop-up/device/widgets/qr_scanner.dart';
import 'package:growhub/features/pop-up/dialog.dart';

void showAddDevicePopupDialog(BuildContext context, Widget popup) {
  showDialog(
    barrierColor: Colors.black.withOpacity(0.6),
    context: context,
    builder: (BuildContext context) {
      return popup;
    },
  );
}

class AddDevicePopUp extends HookWidget {
  const AddDevicePopUp({
    super.key,
    required this.onSubmit,
  });

  final Function(String code) onSubmit;

  @override
  Widget build(BuildContext context) {
    final ssidCode = useState("");

    return GHDialog(
      onCheckmarkPressed: () {
        onSubmit(ssidCode.value);
      },
      title: 'Scan your device.',
      height: MediaQuery.of(context).size.height * 0.8,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
      backgroundColor: GHColors.primary,
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: QRScanner(
                onCodeDetected: (code) {
                  ssidCode.value = code;
                },
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: QRFramePainter(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
