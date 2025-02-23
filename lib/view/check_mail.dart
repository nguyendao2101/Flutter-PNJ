import 'package:flutter/material.dart';

class CheckMail extends StatelessWidget {
  const CheckMail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Text('check mail'),
            )
          ],
        ),
      ),
    );
  }
}
