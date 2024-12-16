import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:growhub/common/widgets/checkmark_button.dart';
import 'package:growhub/config/constants/colors.dart';

class GHDialog extends HookWidget {
  const GHDialog({
    super.key,
    required this.title,
    required this.body,
    this.onCheckmarkPressed,
    this.height,
    this.width,
  });

  final String title;
  final double? height;
  final double? width;
  final Widget body;
  final VoidCallback? onCheckmarkPressed;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: GHColors.background,
      child: Container(
        height: height ?? MediaQuery.of(context).size.height * 0.7,
        width: width ?? MediaQuery.of(context).size.width * 1,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: GHColors.background,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.close_rounded,
                    color: GHColors.black,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 24),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: GHColors.black,
              ),
            ),

            const SizedBox(height: 20),
            Center(child: body),
            const Spacer(),
            // Mark icon at the very bottom
            CheckmarkButton(
              onPressed: () {
                if (onCheckmarkPressed != null) onCheckmarkPressed!();
              },
            ),
          ],
        ),
      ),
    );
  }
}
