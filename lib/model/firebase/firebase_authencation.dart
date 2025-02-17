// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pnj/view/main_nav_view.dart';
import 'package:get/get.dart';
import '../../view/login_view.dart';

class FirAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void signUp(
      String email,
      String passWord,
      String entryPassword,
      String hoTen,
      String addRess,
      String sex,
      String numberPhone,
      String role, // Nhận tham số role
      Function onSuccess,
      Function(String) onRegisterError,
      ) {
    _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: passWord)
        .then((user) {
      if (user.user != null) {
        _createUser(
            user.user!.uid, hoTen, addRess, sex, numberPhone, role, onSuccess);
      }
    }).catchError((err) {
      if (err is FirebaseAuthException) {
        if (err.code == 'weak-password') {
          Get.dialog(AlertDialog(
            title: const Text('Error'),
            content: const Text('Mật khẩu quá đơn giản'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('OK'),
              )
            ],
          ));
        } else if (err.code == 'email-already-in-use') {
          Get.dialog(AlertDialog(
            title: const Text('Error'),
            content: const Text('Email này đã tồn tại'),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('OK'))
            ],
          ));
        } else {
          _onSignUpErr(err.code, onRegisterError);
        }
      }
    });
  }

  static Future<void> signInWithEmailAndPassword(
      String email, String passWord) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: passWord);

      if (credential.user != null) {
        final userSnapshot = await FirebaseDatabase.instance
            .ref('users/${credential.user!.uid}')
            .once();

        final userData = userSnapshot.snapshot.value as Map<dynamic, dynamic>?;
        if (userData == null) {
          print("User signed is null");
        }
        if (userData != null) {
          print("User signed in: ${credential.user!.email}");
          final userRole = userData['role'];
          print('form role1: $userRole');
          if (userRole == 'user') {
            Get.offAll(() => const MainNavView());
            // Get.offAll(() => const HomeScreenAdmin());
          } else {
            print('form role: $userRole');
            Get.snackbar(
              "Info",
              "User account information is incorrect",
              snackPosition: SnackPosition.TOP,
            );
            // Get.offAll(() => const AccessLocation());
            // Get.offAll(() => const MainNavView(initialIndex: 0,));
          }
        } else {
          print('Không tìm thấy dữ liệu người dùng.');
        }
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'user-not-found') {
        Get.dialog(AlertDialog(
          title: const Text('Error'),
          content: const Text('No user found for that email'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('OK'),
            )
          ],
        ));
      } else if (err.code == 'wrong-password') {
        Get.dialog(AlertDialog(
          title: const Text('Error'),
          content: const Text('Wrong password provided for that user'),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('OK'))
          ],
        ));
      } else {
        Get.dialog(AlertDialog(
          title: const Text('Error'),
          content: Text(err.message ?? "Something went wrong..."),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('OK'))
          ],
        ));
      }
    }
  }

  void _createUser(String userId, String hoTen, String addRess, String sex,
      String numberPhone, String? role, Function onSuccess) {
    print("Debug: sex = $sex, numberPhone = $numberPhone"); // Kiểm tra giá trị
    var user = {
      ''
          '': hoTen,
      'AddRess': addRess,
      'Sex': sex,
      'NumberPhone': numberPhone,
      'role': role ?? 'user',
    };
    var ref = FirebaseDatabase.instance.ref().child('users');
    ref.child(userId).set(user).then((_) {
      onSuccess();
    }).catchError((err) {
      print("Error: $err");
    });
  }

  void _onSignUpErr(String code, Function(String) onRegisterError) {
    switch (code) {
      case "ERROR_INVALID_EMAIL":
      case "ERROR_INVALID_CREDENTIAL":
        onRegisterError("Invalid email");
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        onRegisterError("Email has existed");
        break;
      case "ERROR_WEAK_PASSWORD":
        onRegisterError("The password is not strong enough");
        break;
      default:
        onRegisterError("SignUp failed, please try again");
        break;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    Get.to(() => const LoginView());
  }
}
