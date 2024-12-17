import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({
    super.key,
    required this.onCodeDetected, // Callback for detected QR code
  });

  final void Function(String code) onCodeDetected;

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  Barcode? _barcode;

  // Builds the UI for displaying the detected value
  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        'Scan something!',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    return Text(
      value.displayValue ?? 'No display value.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  // Handles QR code detection
  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
        final String? detectedValue = _barcode?.displayValue;

        // Check if the value matches the "&code&code" pattern
        if (detectedValue != null && detectedValue.contains('&code&code')) {
          widget.onCodeDetected(detectedValue); // Pass the value to the parent
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: 220,
      child: Stack(
        children: [
          MobileScanner(
            onDetect: _handleBarcode,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 40,
              color: Colors.black.withOpacity(0.4),
              child: Center(child: _buildBarcode(_barcode)),
            ),
          ),
        ],
      ),
    );
  }
}
