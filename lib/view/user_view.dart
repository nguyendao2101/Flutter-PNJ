import 'package:flutter/material.dart';

import '../widgets/common_widget/footer/footer_view.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Text('User view'),
            ),
            FooterView(),
          ],
        ),
      ),
    );
  }
}
