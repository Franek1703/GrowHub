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
    this.margin,
    this.backgroundColor,
  });

  /// The title text displayed at the top of the dialog.
  ///
  /// Use this to give context or purpose for the dialog.
  final String title;

  /// Optional height of the dialog.
  ///
  /// If not provided, the height defaults to 70% of the screen height.
  final double? height;

  /// Optional width of the dialog.
  ///
  /// If not provided, the width defaults to the full screen width.
  final double? width;

  /// The main content displayed in the body of the dialog.
  ///
  /// This allows you to pass any widget, such as text, forms, or other UI components.
  final Widget body;

  /// Callback function executed when the checkmark button is pressed.
  ///
  /// If not provided, the checkmark button will close the dialog without additional action.
  final VoidCallback? onCheckmarkPressed;

  /// Optional margin around the dialog.
  ///
  /// Use this to control the dialog's padding relative to the screen edges.
  final EdgeInsets? margin;

  /// The background color of the dialog.
  ///
  /// If not provided, the default color is white
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: margin,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: backgroundColor ?? GHColors.background,
      child: Container(
        height: height ?? MediaQuery.of(context).size.height * 0.7,
        width: width ?? MediaQuery.of(context).size.width * 1,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: backgroundColor ?? GHColors.background,
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
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close_rounded,
                    color: GHColors.black,
                    size: 30,
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
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
