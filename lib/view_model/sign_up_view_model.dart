// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'dart:math';

import 'package:mailer/smtp_server/gmail.dart';

class SignUpViewModel extends GetxController {
  final FirebaseAuth _firAuth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final formKey = GlobalKey<FormState>();

  late String email;
  late String password;
  late String confirmPassword;
  late String hoTen;
  late String address;
  late String sex;
  late String numberPhone;

  RxBool isEntryPasswordObscured = true.obs;
  RxBool isObscured = true.obs;
  final showPassword = false.obs;
  final isLoading = false.obs;

  //email
  // final gmailSmtp = gmail(dotenv.env["GMAIL_MAIL"]!,dotenv.env["GMAIL_PASSWORD"]!);

  void toggleObscureText() {
    isObscured.value = !isObscured.value;
  }

  void showHidePassword() {
    showPassword.value = !showPassword.value;
  }

  void toggleEntryPasswordObscureText() {
    isEntryPasswordObscured.value = !isEntryPasswordObscured.value;
  }

  void onChangeUsername(String valueEmail) {
    email = valueEmail;
    formKey.currentState?.validate();
  }

  void onChangePassword(String valuePassword) {
    password = valuePassword;
    formKey.currentState?.validate();
  }

  void onChangeConfirmPassword(String valueconfirmPassword) {
    confirmPassword = valueconfirmPassword;
    formKey.currentState?.validate();
  }

  void onChangeCheckName(String valuehoTen) {
    hoTen = valuehoTen;
    formKey.currentState?.validate();
  }

  void onChangeCheckAdress(String valueaddress) {
    address = valueaddress;
    formKey.currentState?.validate();
  }

  void onChangeCheckSex(String valuesex) {
    sex = valuesex;
    formKey.currentState?.validate();
  }

  void onChangeCheckNumberPhone(String valueNumberPhone) {
    numberPhone = valueNumberPhone;
    formKey.currentState?.validate();
  }

  void signUp(
      String email,
      String passWord,
      String entryPassword,
      String hoTen,
      String addRess,
      String sex,
      String numberPhone,
      Function onSuccess,
      Function(String) onError) {
    _firAuth
        .createUserWithEmailAndPassword(email: email, password: passWord)
        .then((UserCredential userCredential) {
      // Đẩy dữ liệu người dùng lên Firebase Realtime Database
      _dbRef.child('users').child(userCredential.user!.uid).set({
        'email': email,
        'fullName': hoTen,
        'address': addRess,
        'sex': sex,
        'numberPhone': numberPhone,
        'role': 'user', // Thêm giá trị mặc định cho role
      }).then((_) {
        onSuccess();
      }).catchError((error) {
        onError('Failed to save user data: $error');
      });
    }).catchError((error) {
      onError('Failed to sign up: $error');
    });
  }

  bool containsSpecialCharacters(String text) {
    final allowedSpecialCharacters = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');
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
    } else if (!containsSpecialCharacters(email!)) {
      return 'Email cần chứa ký tự đặc biệt';
    } else {
      return null;
    }
  }

  Future<void> sendEmail(String email, String code) async {
    String username = 'hungryhubb1@gmail.com'; // Email gửi
    String password = 'nrhc ernj lejs fpyi'; // Mật khẩu email gửi

    final smtpServer = gmail(username, password); // Sử dụng Gmail

    final message = Message()
      ..from = Address(username, 'HungryHub')
      ..recipients.add(email) // Email nhận
      ..subject = 'Mã xác minh tài khoản'
      ..text =
          'Chào bạn!\nCảm ơn bạn đã quan tâm và đăng ký tài khoản HungryHub\nMã xác minh của bạn là: $code\nChúc bạn có những giây phút mua hàng vui vẻ!!\nĐừng quên đánh giá 5 sao cho sản phẩm nhé!!';

    try {
      await send(message, smtpServer);
      print('Email gửi thành công');
    } catch (e) {
      print('Gửi email thất bại: $e');
    }
  }

  String generateVerificationCode() {
    var random = Random();
    return (random.nextInt(900000) + 100000)
        .toString(); // Tạo số từ 100000 đến 999999
  }

  String? validatorPassword(String? value) {
    if ((value ?? '').isEmpty) {
      return 'Password không được để trống';
    } else if ((value ?? '').length < 6) {
      return 'Password không được nhỏ hơn 6 ký tự';
    } else if (value!.contains(' ')) {
      return 'Password không được chứa khoảng trắng';
    } else if (!containsUppercaseLetter(value)) {
      return 'Password cần chứa ít nhất 1 ký tự viết hoa';
    } else if (!containsLowercaseLetter(value)) {
      return 'Password cần chứa ít nhất 1 ký tự viết thường';
    } else if (!containsDigit(value)) {
      return 'Password cần chứa ít nhất 1 chữ số';
    } else if (!containsSpecialCharacters(value)) {
      return 'Password cần chứa ít nhất 1 ký tự đặc biệt';
    } else {
      return null;
    }
  }

  String? validatorConfirmPassword(String? value) {
    if (value != password) {
      return 'Password nhập lại không khớp';
    } else {
      return null;
    }
  }

  String? validatorCheck(String? value) {
    if ((value ?? '').isEmpty) {
      return 'Không được để trống';
    } else {
      return null;
    }
  }

  bool isValidSignupForm() {
    return formKey.currentState!.validate();
  }

  void resetForm() {
    email = '';
    password = '';
    confirmPassword = '';
    hoTen = '';
    address = '';
    sex = '';
    numberPhone = '';
    formKey.currentState?.reset();
  }
}
