import 'dart:math';

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class ConfettiExample extends StatefulWidget {
  @override
  _ConfettiExampleState createState() => _ConfettiExampleState();
}

class _ConfettiExampleState extends State<ConfettiExample> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the confetti controller
    _controller = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is removed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confetti Example')),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // The confetti widget
          ConfettiWidget(
            confettiController: _controller,
            blastDirection: -pi / 2, // Direction: -pi/2 is upward
            emissionFrequency: 0.05, // Frequency of particles
            numberOfParticles: 30, // Number of particles per emission
            gravity: 0.3, // Gravity of the particles
            colors: [
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.orange
            ], // Particle colors
          ),
          // A button to trigger the confetti
          ElevatedButton(
            onPressed: () {
              _controller.play(); // Start the confetti animation
            },
            child: const Text('Celebrate!'),
          ),
        ],
      ),
    );
  }
}
