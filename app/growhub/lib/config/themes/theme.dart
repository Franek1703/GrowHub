import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GHTheme {
  static ThemeData theme(BuildContext context) => _create();

  static ThemeData _create() {
    return ThemeData(textTheme: GoogleFonts.robotoTextTheme());
  }
}
