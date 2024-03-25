import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final FontWeight weight;
  final double size;
  final Color color;

  const CustomText({
    Key? key,
    required this.size,
    required this.weight,
    required this.color,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inknutAntiqua(
        fontSize: size,
        fontWeight: weight,
        color: color,
      ),
    );
  }
}
