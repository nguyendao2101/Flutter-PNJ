import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pnj/view/sign_up_view.dart';
import 'package:flutter_pnj/view_model/login_view_model.dart';
import 'package:flutter_pnj/widgets/common/image_extention.dart';
import 'package:flutter_pnj/widgets/common_widget/button/bassic_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../widgets/common_widget/check_box/check_box_login.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginViewModel());
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                  style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xffA4A1AA),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Jost'),
                  children: [
                    const TextSpan(
                      text: 'If you don’t have an account please ',
                    ),
                    TextSpan(
                      text: ' Sign up here',
                      style:
                      const TextStyle(color: Color(0xff131118)),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Chuyển màn hình sang SignUpScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const SignUpView(),
                            ),
                          );
                        },
                    ),
                  ]),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80,),
                    Align(
                        alignment: Alignment.center,
                        child: Image.asset(ImageAsset.loadLogoApp, height: 80)),
                    const SizedBox(height: 80,),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Welcome ', style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontFamily: 'Jost',
                            fontWeight: FontWeight.w600,),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4,),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Please login here ', style: TextStyle(
                          fontSize: 16,
                          color: Color(0xffA4A1AA),
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.w400,),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    _formEmail(controller),
                    const SizedBox(height: 20,),
                    _formPassword(controller),
                  ],
                ),
              ),
              const Padding(
                padding: const EdgeInsets.only(right: 8, left: 4),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CheckBoxLogin(
                          checkColor: Colors.white,
                          activeColor: Colors.black,
                        ),
                        Text('Remember Me', style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff131118),
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.w400,),)
                      ],
                    ),
                    Text('Forgot Password?', style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff131118),
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w400,),)
                  ],
                ),
              ),
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BasicAppButton(onPressed: (){
                  controller.onlogin();
                }, title: 'Login', sizeTitle: 16, colorButton: Color(0xff131118), radius: 10, height: 56, fontW: FontWeight.w400,),
              )
          
            ],
          ),
        ),
      ),
    );
  }
  Widget _formPassword(LoginViewModel controller) {
    return Obx(
          () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Password', style: TextStyle(
            fontSize: 12,
            color: Color(0xff131118),
            fontFamily: 'Jost',
            fontWeight: FontWeight.w400,),),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: controller.passwordController,
            obscureText: controller.isObscured.value,
            style: const TextStyle(
                color: Colors.black), // Chữ màu đen để dễ nhìn trên nền trắng
            decoration: InputDecoration(
              // labelText: 'Password',
              // labelStyle:
              // const TextStyle(color: Colors.black), // Nhãn màu xám nhạt
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10), // Bo góc đường viền
                borderSide: BorderSide(
                    color: Colors.black, width: 1), // Viền màu xám
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Colors.blue,
                    width: 1), // Viền màu xanh khi được chọn
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Colors.red, width: 1), // Viền màu đỏ khi có lỗi
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Colors.redAccent,
                    width: 1), // Viền đỏ khi có lỗi và đang được chọn
              ),
              filled: true,
              fillColor: Colors.white, // Màu nền xám nhạt cho trường nhập
              hintText: 'Password',
              hintStyle: TextStyle(
                  color: Colors.black.withOpacity(0.6)), // Gợi ý màu xám nhạt
              suffixIcon: GestureDetector(
                onTap: () => controller.toggleObscureText(),
                child: Icon(
                  controller.isObscured.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.grey.withOpacity(0.8), // Màu biểu tượng mắt
                ),
              ),
            ),
            onChanged: controller.onChangePassword,
            validator: controller.validatorPassword,
          ),
        ],
      ),
    );
  }
  Column _formEmail(LoginViewModel controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Email Address', style: TextStyle(
          fontSize: 12,
          color: Color(0xff131118),
          fontFamily: 'Jost',
          fontWeight: FontWeight.w400,),),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: controller.emailController,
          obscureText: false,
          style: const TextStyle(
              color:
              Colors.black), // Chữ màu đen để hiển thị rõ trên nền trắng
          decoration: InputDecoration(
            // labelText: 'Email',
            // labelStyle: const TextStyle(color: Colors.black), // Nhãn màu xám nhạt
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), // Bo góc đường viền
              borderSide: const BorderSide(
                  color: Colors.black, width: 1), // Viền màu xám nhạt
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 1), // Viền màu xanh khi được chọn
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: Colors.red, width: 1), // Viền màu đỏ khi có lỗi
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 1), // Viền đỏ khi có lỗi và đang được chọn
            ),
            filled: true,
            fillColor: Colors.white, // Màu nền xám nhạt cho trường nhập
            hintText: 'Email',
            hintStyle: TextStyle(
                color: Colors.black.withOpacity(0.6)), // Gợi ý màu xám nhạt
          ),
          onChanged: controller.onChangeUsername,
          validator: controller.validatorUsername,
        ),
      ],
    );
  }
}
