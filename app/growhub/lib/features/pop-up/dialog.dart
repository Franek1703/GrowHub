import 'package:flutter/material.dart';
import 'package:growhub/common/widgets/checkmark_button.dart';
import 'package:growhub/config/constants/colors.dart';

class GHDialog extends StatelessWidget {
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
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      child: Container(
        height: height ?? MediaQuery.of(context).size.height * 0.8,
        width: width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
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
                  child: Icon(Icons.close, color: GHColors.black),
                ),
                const SizedBox(width: 30),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: GHColors.black,
              ),
            ),
            body,
            const Spacer(),
            // Mark icon at the very bottom
            CheckmarkButton(
              onPressed: () => onCheckmarkPressed,
            ),
          ],
        ),
      ),
    );
  }
}
