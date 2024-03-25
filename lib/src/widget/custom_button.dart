import 'package:flutter/material.dart';
import 'package:talenthub/src/widget/custom_text.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double textSize;
  final FontWeight textWeight;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = Colors.blue,
    this.textColor = Colors.white,
    this.textSize = 16.0,
    this.textWeight = FontWeight.bold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: CustomText(
        text: text,
        color: textColor,
        size: textSize,
        weight: textWeight,
      ),
    );
  }
}

class CustomButton1 extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Function()? onPressed;

  const CustomButton1({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
      ),
      child: CustomText(
        text: text,
        size: 16,
        color: textColor,
        weight: FontWeight.normal,
      ),
    );
  }
}

class AcceptReject extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const AcceptReject({
    required this.text,
    required this.onPressed,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
      ),
    );
  }
}
