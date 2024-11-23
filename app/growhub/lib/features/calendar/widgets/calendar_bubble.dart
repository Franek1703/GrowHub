import 'package:flutter/material.dart';
import '../../../config/constants/colors.dart';

// A widget that displays dosage information in bubble.
class CalendarBubble extends StatelessWidget {
  // The dosage information to display
  final String dosage;

  // The timestamp to display
  final String timestamp;

  // The background color of the bubble
  final Color backgroundColor;

  // The border color of the bubble
  final Color borderColor;

  // The color of the dosage text
  final Color dosageTextColor;

  // The color of the timestamp text
  final Color timestampTextColor;

  // The width of the bubble's border
  final double borderWidth;

  // The radius of the bubble's corners
  final double cornerRadius;

  // The height of the bubble's pointer
  final double pointerHeight;

  // The width of the bubble's pointer
  final double pointerWidth;

  // Default padding values for the bubble content
  static const _defaultContentPadding = EdgeInsets.only(
    left: 30.0,
    right: 30.0,
    top: 20.0,
    bottom: 40.0,
  );

  // Default text style for the dosage
  static const _defaultDosageStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  // Default text style for the timestamp
  static const _defaultTimestampStyle = TextStyle(
    fontSize: 12,
  );

  // Default spacing between dosage and timestamp
  static const _defaultSpacing = 4.0;

  CalendarBubble({
    super.key,
    required this.dosage,
    required this.timestamp,
    Color? backgroundColor,
    Color? borderColor,
    Color? dosageTextColor,
    Color? timestampTextColor,
    this.borderWidth = 2.0,
    this.cornerRadius = 16.0,
    this.pointerHeight = 20.0,
    this.pointerWidth = 30.0,
  }) : backgroundColor = backgroundColor ?? GHColors.white,
        borderColor = borderColor ?? GHColors.black,
        dosageTextColor = dosageTextColor ?? GHColors.black,
        timestampTextColor = timestampTextColor ?? GHColors.grey;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BubblePainter(
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        borderWidth: borderWidth,
        cornerRadius: cornerRadius,
        pointerHeight: pointerHeight,
        pointerWidth: pointerWidth,
      ),
      child: Padding(
        padding: _defaultContentPadding,
        child: _buildContent(),
      ),
    );
  }

  // Builds the content of the bubble
  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDosageText(),
        const SizedBox(height: _defaultSpacing),
        _buildTimestampText(),
      ],
    );
  }

  // Builds the dosage text widget
  Widget _buildDosageText() {
    return Text(
      'Dosage: $dosage',
      style: _defaultDosageStyle.copyWith(
        color: dosageTextColor,
      ),
    );
  }

  // Builds the timestamp text widget
  Widget _buildTimestampText() {
    return Text(
      timestamp,
      style: _defaultTimestampStyle.copyWith(
        color: timestampTextColor,
      ),
    );
  }
}

// A custom painter that draws the bubble shape with a pointer
class _BubblePainter extends CustomPainter {
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final double cornerRadius;
  final double pointerHeight;
  final double pointerWidth;

  const _BubblePainter({
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.cornerRadius,
    required this.pointerHeight,
    required this.pointerWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawBubble(canvas, size);
  }

  // Draws the bubble shape with background and border
  void _drawBubble(Canvas canvas, Size size) {
    final paint = Paint()..color = backgroundColor;
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final path = _createBubblePath(size);

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  // Creates the bubble path with rounded corners and pointer
  Path _createBubblePath(Size size) {
    final path = Path();
    final bubbleHeight = size.height - pointerHeight;

    // Top left corner
    path.moveTo(cornerRadius, 0);

    // Top edge and top right corner
    path.lineTo(size.width - cornerRadius, 0);
    path.arcToPoint(
      Offset(size.width, cornerRadius),
      radius: Radius.circular(cornerRadius),
    );

    // Right edge and bottom right corner
    path.lineTo(size.width, bubbleHeight - cornerRadius);
    path.arcToPoint(
      Offset(size.width - cornerRadius, bubbleHeight),
      radius: Radius.circular(cornerRadius),
    );

    // Bottom edge with pointer
    path.lineTo(size.width / 2 + pointerWidth / 2, bubbleHeight);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width / 2 - pointerWidth / 2, bubbleHeight);

    // Bottom left corner
    path.lineTo(cornerRadius, bubbleHeight);
    path.arcToPoint(
      Offset(0, bubbleHeight - cornerRadius),
      radius: Radius.circular(cornerRadius),
    );

    // Left edge and close the path
    path.lineTo(0, cornerRadius);
    path.arcToPoint(
      Offset(cornerRadius, 0),
      radius: Radius.circular(cornerRadius),
    );
    path.close();

    return path;
  }

  @override
  bool shouldRepaint(covariant _BubblePainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.cornerRadius != cornerRadius ||
        oldDelegate.pointerHeight != pointerHeight ||
        oldDelegate.pointerWidth != pointerWidth;
  }
}