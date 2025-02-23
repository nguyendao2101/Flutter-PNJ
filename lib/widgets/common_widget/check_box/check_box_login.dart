import 'package:flutter/material.dart';

class CheckBoxLogin extends StatefulWidget {
  final Color activeColor;
  final Color checkColor;
  final ValueChanged<bool>? onChanged; // Thay đổi thành bool

  const CheckBoxLogin({
    Key? key,
    this.activeColor = Colors.black,
    this.checkColor = Colors.white,
    this.onChanged,
  }) : super(key: key);

  @override
  _CheckBoxLoginState createState() => _CheckBoxLoginState();
}

class _CheckBoxLoginState extends State<CheckBoxLogin> {
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
