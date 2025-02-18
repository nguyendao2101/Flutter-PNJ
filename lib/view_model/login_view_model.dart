import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/firebase/firebase_authencation.dart';

class LoginViewModel extends GetxController {
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();

  RxBool isObscured = true.obs;
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  void toggleObscureText() {
    isObscured.value = !isObscured.value;
  }

  void onChangeUsername(String email) {
    formKey.currentState?.validate();
  }

  void onChangePassword(String password) {
    formKey.currentState?.validate();
  }

  bool containsSpecialCharacters(String text) {
    final allowedSpecialCharacters = RegExp(r'[!#\$%^&*(),?":{}|<>]');
    return allowedSpecialCharacters.hasMatch(text);
  }

  bool containsUppercaseLetter(String text) {
    return RegExp(r'[A-Z]').hasMatch(text);
  }

  bool containsLowercaseLetter(String text) {
    return RegExp(r'[a-z]').hasMatch(text);
  }

  bool containsDigit(String text) {
    return RegExp(r'\d').hasMatch(text);
  }

  String? validatorUsername(String? email) {
    if ((email ?? '').isEmpty) {
      return 'Email không được để trống';
    } else if ((email ?? '').length < 6) {
      return 'Email không được nhỏ hơn 6 ký tự';
    } else if (containsSpecialCharacters(email!)) {
      return 'Email không đúng định dạng';
    } else {
      return null;
    }
  }

  String? validatorPassword(String? password) {
    if ((password ?? '').isEmpty) {
      return 'Password không được để trống';
    } else if ((password ?? '').length < 6) {
      return 'Password không được nhỏ hơn 6 ký tự';
    } else {
      return null;
    }
  }

  onlogin() {
    FirAuth.signInWithEmailAndPassword(
        emailController.text, passwordController.text);
  }

  void onLogout() {
    FirAuth firAuth = FirAuth(); // Tạo một thể hiện của FirAuth
    firAuth.signOut(); // Gọi phương thức signOut từ thể hiện
  }
}
