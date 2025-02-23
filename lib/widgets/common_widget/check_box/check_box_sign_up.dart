import 'package:flutter/material.dart';

class CheckBoxSignUp extends StatefulWidget {
  final Color activeColor;
  final Color checkColor;
  final ValueChanged<bool?>? onChanged;

  const CheckBoxSignUp({
    Key? key,
    this.activeColor = Colors.blue,
    this.checkColor = Colors.white,
    this.onChanged,
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
          isChecked = value!;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(isChecked);
        }
      },
      activeColor: widget.activeColor,
      checkColor: widget.checkColor,
    );
  }
}
