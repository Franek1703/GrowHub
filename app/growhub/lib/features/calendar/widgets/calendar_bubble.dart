import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import '../../../config/constants/colors.dart';
import '../../../features/api/data/models/dosage_history_model.dart';

/// A widget that displays a customizable bubble tooltip with dosage information
/// in a calendar context.
///
/// The bubble includes a pointer (arrow) that can be positioned to point to
/// different locations relative to the target widget. The bubble's appearance
/// and positioning can be customized through various parameters.
class CalendarBubble extends StatelessWidget {
  /// The dosage history model to display in the bubble
  final DosageHistoryModel dosageHistory;

  /// Controls the visibility of the bubble.
  final bool isVisible;

  /// The widget that triggers the bubble's display.
  final Widget child;

  /// If true, displays the bubble's pointer towards the left side.
  final bool displayOnLeft;

  /// If true, displays the bubble's pointer towards the right side.
  final bool displayOnRight;

  /// Constants for bubble styling
  static const double _padding = 30.0;
  static const double _topPadding = 20.0;
  static const double _bottomPadding = 40.0;
  static const double _borderWidth = 2.0;
  static const double _cornerRadius = 16.0;
  static const double _pointerHeight = 20.0;
  static const double _pointerWidth = 30.0;
  static const double _verticalOffset = -8.0;
  static const double _horizontalOffset = 30.0;

  const CalendarBubble({
    super.key,
    required this.dosageHistory,
    required this.isVisible,
    required this.child,
    this.displayOnLeft = false,
    this.displayOnRight = false,
  }) : assert(
          !(displayOnLeft && displayOnRight),
          'Cannot display on both left and right simultaneously',
        );

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: isVisible,
      anchor: Aligned(
        follower: Alignment.bottomCenter,
        target: _determineTargetAlignment(),
        offset: _determineOffset(),
      ),
      portalFollower: _buildBubbleContent(),
      child: child,
    );
  }

  /// Determines the target alignment based on display preferences
  Alignment _determineTargetAlignment() {
    if (displayOnLeft) return Alignment.topLeft;
    if (displayOnRight) return Alignment.topRight;
    return Alignment.topCenter;
  }

  /// Calculates the offset based on display preferences
  Offset _determineOffset() {
    if (displayOnLeft) return const Offset(-_horizontalOffset, _verticalOffset);
    if (displayOnRight) return const Offset(_horizontalOffset, _verticalOffset);
    return const Offset(0, _verticalOffset);
  }

  /// Builds the content of the bubble
  Widget _buildBubbleContent() {
    // Format the timestamp
    final formattedTimestamp = _formatTimestamp(dosageHistory.dosedAt);
    return CustomPaint(
      painter: _BubblePainter(
        backgroundColor: GHColors.white,
        borderColor: GHColors.black,
        borderWidth: _borderWidth,
        cornerRadius: _cornerRadius,
        pointerHeight: _pointerHeight,
        pointerWidth: _pointerWidth,
        displayOnLeft: displayOnLeft,
        displayOnRight: displayOnRight,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: _padding,
          right: _padding,
          top: _topPadding,
          bottom: _bottomPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Dosage: ${dosageHistory.dose.toStringAsFixed(1)}g',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
               formattedTimestamp,
              style: TextStyle(
                fontSize: 12,
                color: GHColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Formats the timestamp for display
String _formatTimestamp(DateTime dateTime) {
  return "${dateTime.day.toString().padLeft(2, '0')}"
         ".${dateTime.month.toString().padLeft(2, '0')}"
         ".${dateTime.year} "
         "${dateTime.hour.toString().padLeft(2, '0')}:"
         "${dateTime.minute.toString().padLeft(2, '0')}";
}


/// A custom painter that draws a bubble shape with a customizable pointer.
///
/// The bubble includes rounded corners and a triangular pointer that can be
/// positioned at different locations along the bottom edge.
class _BubblePainter extends CustomPainter {
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final double cornerRadius;
  final double pointerHeight;
  final double pointerWidth;
  final bool displayOnLeft;
  final bool displayOnRight;

  /// The factor used to calculate pointer position offset
  static const double _pointerOffsetFactor = 4.63;

  const _BubblePainter({
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.cornerRadius,
    required this.pointerHeight,
    required this.pointerWidth,
    this.displayOnLeft = false,
    this.displayOnRight = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = backgroundColor;
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final path = _createBubblePath(size);

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  /// Creates the bubble path with rounded corners and a pointer
  Path _createBubblePath(Size size) {
    final path = Path();
    final bubbleHeight = size.height - pointerHeight;

    _addTopEdge(path, size, bubbleHeight);
    _addPointer(path, size, bubbleHeight);
    _addBottomEdge(path, bubbleHeight);

    path.close();
    return path;
  }

  /// Adds the top edge of the bubble including corners
  void _addTopEdge(Path path, Size size, double bubbleHeight) {
    path.moveTo(cornerRadius, 0);
    path.lineTo(size.width - cornerRadius, 0);
    path.arcToPoint(
      Offset(size.width, cornerRadius),
      radius: Radius.circular(cornerRadius),
    );
    path.lineTo(size.width, bubbleHeight - cornerRadius);
    path.arcToPoint(
      Offset(size.width - cornerRadius, bubbleHeight),
      radius: Radius.circular(cornerRadius),
    );
  }

  /// Adds the pointer to the bubble path
  void _addPointer(Path path, Size size, double bubbleHeight) {
    final centerX = _calculatePointerCenterX(size);
    const overlap = 1.0; // Slight overlap for smooth rendering

    path.lineTo(centerX + pointerWidth / 2 - overlap, bubbleHeight);
    path.lineTo(centerX, size.height);
    path.lineTo(centerX - pointerWidth / 2 + overlap, bubbleHeight);
  }

  /// Calculates the x-coordinate for the pointer's center
  double _calculatePointerCenterX(Size size) {
    if (displayOnRight) {
      return size.width / 2 - size.width / _pointerOffsetFactor;
    }
    if (displayOnLeft) {
      return size.width / 2 + size.width / _pointerOffsetFactor;
    }
    return size.width / 2;
  }

  /// Adds the bottom edge of the bubble including corners
  void _addBottomEdge(Path path, double bubbleHeight) {
    path.lineTo(cornerRadius, bubbleHeight);
    path.arcToPoint(
      Offset(0, bubbleHeight - cornerRadius),
      radius: Radius.circular(cornerRadius),
    );
    path.lineTo(0, cornerRadius);
    path.arcToPoint(
      Offset(cornerRadius, 0),
      radius: Radius.circular(cornerRadius),
    );
  }

  @override
  bool shouldRepaint(covariant _BubblePainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.cornerRadius != cornerRadius ||
        oldDelegate.pointerHeight != pointerHeight ||
        oldDelegate.pointerWidth != pointerWidth ||
        oldDelegate.displayOnLeft != displayOnLeft ||
        oldDelegate.displayOnRight != displayOnRight;
  }
}