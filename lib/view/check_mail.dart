// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../view/login_view.dart';
import '../../../view_model/sign_up_view_model.dart';
import '../widgets/common_widget/button/bassic_button.dart';

class CheckMail extends StatefulWidget {
  final String email;
  final String password;
  final String fullName;
  // final String address;
  final String sex;
  final String phoneNumber;
  final String verificationCode; // Mã xác minh từ controller

  const CheckMail({
    super.key,
    required this.email,
    required this.password,
    required this.fullName,
    // required this.address,
    required this.sex,
    required this.phoneNumber,
    required this.verificationCode, // Thêm mã xác minh
  });

  @override
  State<CheckMail> createState() => _CheckMailState();
}

class _CheckMailState extends State<CheckMail> {
  final controller = Get.put(SignUpViewModel());
  late String codeMail;
  late String verificationCode;

  late Timer _timer;
  int _remainingSeconds = 90; // Thời gian đếm ngược (90s)
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());

  @override
  void initState() {
    super.initState();
    verificationCode = widget.verificationCode;
    print('ma dc nhan: $verificationCode');
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel(); // Dừng timer khi không dùng nữa
    for (var controller in _controllers) {
      controller.dispose(); // Hủy controllers
    }
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel(); // Dừng timer khi về 0
      }
    });
  }

  void _resendCode() {
    // Hủy timer hiện tại nếu đang chạy
    _timer.cancel();

    // Tạo mã xác minh mới
    String newVerificationCode =
    controller.generateVerificationCode().toString();

    setState(() {
      _remainingSeconds = 90; // Reset thời gian đếm ngược
      verificationCode = newVerificationCode; // Đặt lại giá trị mã xác minh
      print('ma nhan dc moi la: $verificationCode');
    });

    startTimer(); // Bắt đầu lại timer

    // Gửi lại email với mã mới
    controller.sendEmail(widget.email, newVerificationCode);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('A new verification code has been sent!'),
      backgroundColor: Colors.blue,
    ));
  }

  void _verifyCode() {
    String inputCode = _controllers.map((controller) => controller.text).join();
    if (_remainingSeconds <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Time is up, please retrieve the 6-digit code again'),
        backgroundColor: Colors.red,
      ));
    } else if (inputCode == verificationCode) {
      controller.isLoading.value = true;
      controller.signUp(
        controller.email,
        controller.password,
        controller.confirmPassword,
        controller.hoTen,
        // controller.address,
        controller.sex,
        controller.numberPhone,
            () {
          controller.isLoading.value = false;
          controller.resetForm();
          Get.offAll(() => const LoginView());
        },
            (error) {
          controller.isLoading.value = false;
          Get.snackbar(
            'Error',
            error,
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Verification successful!'),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('The verification code is incorrect'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    codeMail = controller.generateVerificationCode().toString();
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Text(
                'Verify \nyour email',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Jost',
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Enter the 6-Digit code sent to \nyou\non ${widget.email}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Jost',
                  color: Color(0xff32343E),
                ),
              ),
              const SizedBox(height: 30),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w600,
                    color: Color(0xff0D0D0D),
                  ),
                  children: [
                    const TextSpan(text: 'Didn’t receive ?'),
                    TextSpan(
                      text: ' Send again',
                      style: const TextStyle(color: Color(0xffFF0000)),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _resendCode(); // Gọi lại mã xác minh
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    width: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: TextField(
                      controller: _controllers[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length == 1 && index < 5) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Resend in ${formatTime(_remainingSeconds)}',
                    style: const TextStyle(
                      color: Color(0xff0D0D0D),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: 'Jost',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              BasicAppButton(
                onPressed: _verifyCode,
                title: 'SIGN UP',
                sizeTitle: 16,
                fontW: FontWeight.bold,
                colorButton: Colors.black,
                radius: 12,
                height: 53,
              ),
              const SizedBox(height: 50),
              Align(
                alignment: Alignment.center,
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w400,
                      color: Color(0xff868686),
                    ),
                    children: [
                      TextSpan(text: 'By signing up, you have agreed to our\n'),
                      TextSpan(
                        text: 'Terms and conditions',
                        style: TextStyle(color: Color(0xff3567E7)),
                      ),
                      TextSpan(text: '&'),
                      TextSpan(
                        text: ' Privacy policy',
                        style: TextStyle(color: Color(0xff3567E7)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm định dạng thời gian (phút:giây)
  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
