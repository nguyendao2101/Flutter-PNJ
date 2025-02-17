// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class BasicAppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final FontWeight? fontW;
  final Color? colorButton;
  final double? height;
  final double? radius;
  final double sizeTitle;
  const BasicAppButton(
      {super.key,
        required this.onPressed,
        required this.title,
        this.colorButton,
        this.radius,
        this.fontW,
        this.height,
        required this.sizeTitle});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorButton ?? const Color(0xffE53935),
          foregroundColor: const Color(0xFFFFFFFF),
          minimumSize: Size.fromHeight(height ?? 80),
        ).copyWith(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius ?? 100), // Bo góc
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
              fontSize: sizeTitle,
              fontWeight: fontW ?? FontWeight.bold,
              fontFamily: 'Jost'),
        ));
  }
}
