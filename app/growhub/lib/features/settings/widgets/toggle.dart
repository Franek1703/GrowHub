import 'package:flutter/material.dart';
import 'package:growhub/config/constants/colors.dart';

/// A customizable toggle widget for switching between two options.
/// 
/// The `GHToggle` widget is a reusable component that displays a title
/// and two selectable options. It highlights the selected option and
/// executes a callback function when the selection changes.
class GHToggle extends StatefulWidget {
  /// The title displayed above the toggle.
  final String title;

  /// The text displayed on the left side of the toggle.
  final String leftText;

  /// The text displayed on the right side of the toggle.
  final String rightText;

  /// A callback function that is triggered when the selection changes.
  /// Returns `true` if the left option is selected, and `false` otherwise.
  final Function(bool isLeftSelected)? onToggle;

  /// Constructs a `GHToggle` widget.
  const GHToggle({
    Key? key,
    required this.title,
    required this.leftText,
    required this.rightText,
    this.onToggle,
  }) : super(key: key);

  @override
  _GHToggleState createState() => _GHToggleState();
}

class _GHToggleState extends State<GHToggle> {
  /// Tracks the state of the selected option.
  /// Defaults to `true`, indicating that the left option is selected.
  bool isLeftSelected = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // The title of the toggle, displayed above the options.
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8), // Spacer between the title and the toggle.

        // The container for the toggle switch.
        Container(
          width: 200.0, // Fixed width for the toggle widget.
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(color: GHColors.black, width: 1.0),
            color: GHColors.background,
          ),
          child: Row(
            children: [
              // Left option of the toggle.
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isLeftSelected = true;
                      widget.onToggle?.call(true);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(24.0)),
                      color: isLeftSelected ? GHColors.black : GHColors.background,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    alignment: Alignment.center,
                    child: Text(
                      widget.leftText,
                      style: TextStyle(
                        color: isLeftSelected ? GHColors.background : GHColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              // Right option of the toggle.
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isLeftSelected = false;
                      widget.onToggle?.call(false);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(24.0)),
                      color: !isLeftSelected ? GHColors.black : GHColors.background,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    alignment: Alignment.center,
                    child: Text(
                      widget.rightText,
                      style: TextStyle(
                        color: !isLeftSelected ? GHColors.background : GHColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}