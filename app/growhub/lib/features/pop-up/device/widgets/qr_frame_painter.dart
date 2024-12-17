import 'package:flutter/material.dart';

/// This widget is used to render those pretty lines around the square (QR Code)
class QRFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    const double cornerLength = 30;

    canvas.drawLine(const Offset(0, 0), const Offset(cornerLength, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(0, cornerLength), paint);

    canvas.drawLine(
        Offset(size.width, 0), Offset(size.width - cornerLength, 0), paint);
    canvas.drawLine(
        Offset(size.width, 0), Offset(size.width, cornerLength), paint);

    canvas.drawLine(
        Offset(0, size.height), Offset(0, size.height - cornerLength), paint);
    canvas.drawLine(
        Offset(0, size.height), Offset(cornerLength, size.height), paint);

    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width - cornerLength, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width, size.height - cornerLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
