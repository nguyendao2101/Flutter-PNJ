// ignore_for_file: avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pnj/view/main_nav_view.dart';
import 'package:get/get.dart';
import '../../view/check_human_view.dart';
import '../../view/login_view.dart';

class FirAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Đăng ký tài khoản
  void signUp(
      String email,
      String passWord,
      String entryPassword,
      String hoTen,
      // String addRess,
      String sex,
      String numberPhone,
      String role,
      Function onSuccess,
      Function(String) onRegisterError,
      ) {
    if (passWord != entryPassword) {
      onRegisterError("Mật khẩu nhập lại không khớp.");
      return;
    }

    _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: passWord)
        .then((user) {
      if (user.user != null) {
        _createUser(
          user.user!.uid,
          hoTen,
          // addRess,
          sex,
          numberPhone,
          role,
          onSuccess,
        );
      }
    }).catchError((err) {
      if (err is FirebaseAuthException) {
        switch (err.code) {
          case 'weak-password':
            _showErrorDialog("Mật khẩu quá đơn giản.");
            break;
          case 'email-already-in-use':
            _showErrorDialog("Email này đã tồn tại.");
            break;
          default:
            _onSignUpErr(err.code, onRegisterError);
        }
      } else {
        print("Lỗi không xác định: $err");
      }
    });
  }

  /// Đăng nhập tài khoản
  static Future<void> signInWithEmailAndPassword(
      String email,
      String passWord,
      ) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: passWord);

      if (credential.user != null) {
        final userSnapshot = await FirebaseDatabase.instance
            .ref('users/${credential.user!.uid}')
            .once();

        final userData = userSnapshot.snapshot.value as Map<dynamic, dynamic>?;

        if (userData != null) {
          final userRole = userData['Role'] ?? 'user';
          print('User Role: $userRole');

          if (userRole == 'user') {
            Get.offAll(() => const ConfirmHumanView());
          } else {
            _showErrorDialog("Tài khoản không được cấp quyền truy cập.");
          }
        } else {
          print('Không tìm thấy dữ liệu người dùng.');
        }
      }
    } on FirebaseAuthException catch (err) {
      switch (err.code) {
        case 'user-not-found':
          _showErrorDialog("Không tìm thấy tài khoản.");
          break;
        case 'wrong-password':
          _showErrorDialog("Mật khẩu không đúng.");
          break;
        default:
          _showErrorDialog(err.message ?? "Đã xảy ra lỗi.");
      }
    }
  }

  /// Tạo người dùng trong Firebase Database
  void _createUser(
      String userId,
      String hoTen,
      // String addRess,
      String sex,
      String numberPhone,
      String? role,
      Function onSuccess,
      ) {
    var user = {
      'FullName': hoTen,
      // 'Address': addRess,
      'Sex': sex,
      'NumberPhone': numberPhone,
      'Role': role ?? 'user',
    };

    var ref = FirebaseDatabase.instance.ref().child('users');
    ref.child(userId).set(user).then((_) {
      onSuccess();
    }).catchError((err) {
      print("Error creating user: $err");
    });
  }

  /// Hiển thị thông báo lỗi
  static void _showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: const Text('Lỗi'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Xử lý lỗi đăng ký
  void _onSignUpErr(String code, Function(String) onRegisterError) {
    switch (code) {
      case "invalid-email":
        onRegisterError("Email không hợp lệ.");
        break;
      case "email-already-in-use":
        onRegisterError("Email đã tồn tại.");
        break;
      case "weak-password":
        onRegisterError("Mật khẩu quá yếu.");
        break;
      default:
        onRegisterError("Đăng ký thất bại. Vui lòng thử lại.");
    }
  }

  /// Đăng xuất người dùng
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    Get.offAll(() => const LoginView());
  }
}
