import 'package:flutter/material.dart';

class CheckBoxSignUp extends StatefulWidget {
  final Color activeColor;
  final Color checkColor;
  final ValueChanged<bool> onChanged; // Thay đổi thành bool

  const CheckBoxSignUp({
    Key? key,
    this.activeColor = Colors.black,
    this.checkColor = Colors.white,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CheckBoxSignUpState createState() => _CheckBoxSignUpState();
}

class _CheckBoxSignUpState extends State<CheckBoxSignUp> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: isChecked,
      onChanged: (value) {
        setState(() {
          isChecked = value ?? false;
        });
        widget.onChanged?.call(isChecked); // Gọi callback
      },
      activeColor: widget.activeColor,
      checkColor: widget.checkColor,
    );
  }
}
