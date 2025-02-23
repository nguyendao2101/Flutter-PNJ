import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pnj/view/check_mail.dart';
import 'package:flutter_pnj/view_model/sign_up_view_model.dart';
import 'package:flutter_pnj/widgets/common/image_extention.dart';
import 'package:flutter_pnj/widgets/common_widget/check_box/check_box_sign_up.dart';
import 'package:get/get.dart';

import '../widgets/common_widget/button/bassic_button.dart';
import 'login_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool iAgree = false;
  late String codeMail;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpViewModel());
    codeMail = controller.generateVerificationCode().toString();
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 80,),
                    Align(
                        alignment: Alignment.center,
                        child: Image.asset(ImageAsset.loadLogoApp, height: 80,)),
                    const SizedBox(height: 60,),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Create New Account ', style: TextStyle(
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
                        Text('Please enter details', style: TextStyle(
                          fontSize: 16,
                          color: Color(0xffA4A1AA),
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.w400,),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    _buildTextField(
                      label: 'Full Name',
                      hintText: 'Full Name',
                      obscureText: false,
                      onChanged: controller.onChangeCheckName,
                      validator: controller.validatorCheck,
                    ),
                    const SizedBox(height: 20,),
                    _buildTextField(
                      label: 'Address',
                      hintText: 'Address',
                      obscureText: false,
                      onChanged: controller.onChangeCheckAdress,
                      validator: controller.validatorCheck,
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: 'Phone Number',
                            hintText: 'Phone Number',
                            obscureText: false,
                            onChanged: controller.onChangeCheckNumberPhone,
                            validator: controller.validatorCheck,
                          ),
                        ),
                        const SizedBox( width: 12,),
                        Expanded(
                          child: _buildTextField(
                            label: 'Sex',
                            hintText: 'Sex',
                            obscureText: false,
                            onChanged: controller.onChangeCheckSex,
                            validator: controller.validatorCheck,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    _formEmail(controller),
                    const SizedBox(height: 20,),
                    _formPassword(controller),
                    const SizedBox(height: 20,),
                    _formEntryPassword(controller),
                  ],
                ),
              ),
               Padding(
                padding: const EdgeInsets.only(right: 8, left: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CheckBoxSignUp(
                          onChanged: (value) {
                            setState(() {
                              iAgree = value;
                            });
                          },
                        ),
                        RichText(
                          text: const TextSpan(
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff131118),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Jost'),
                              children: [
                                TextSpan(
                                  text: 'I agree to the ',
                                ),
                                TextSpan(
                                  text: 'Terms & Conditions',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: BasicAppButton(onPressed: (){
                  if(iAgree){
                    if (controller.isValidSignupForm()) {
                      controller.sendEmail(
                          controller.email, codeMail.toString());
                      print('test ma code1: $codeMail');
                      Get.to(() => CheckMail(
                        email: controller.email,
                        password: controller.password,
                        fullName: controller.hoTen,
                        address: controller.address,
                        sex: controller.sex,
                        phoneNumber: controller.numberPhone,
                        verificationCode: codeMail.toString(),
                      ));
                    }
                  }
                }, title: 'Sign Up', sizeTitle: 16, colorButton: const Color(0xff131118), radius: 10, height: 56, fontW: FontWeight.w400,),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _formEntryPassword(SignUpViewModel controller) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Entry Password', style: TextStyle(
              fontSize: 12,
              color: Color(0xff131118),
              fontFamily: 'Jost',
              fontWeight: FontWeight.w400,),),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Obx(
              () => TextFormField(
            obscureText: controller.isEntryPasswordObscured.value,
            style: const TextStyle(
                color: Color(0xff939393),
                fontFamily: 'Jost',
                fontWeight: FontWeight.w500,
                fontSize: 16), // Chữ màu đen để dễ nhìn trên nền trắng
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10), // Bo góc đường viền
                borderSide: const BorderSide(
                    color: Colors.black, width: 1), // Viền màu xám
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Colors.blue, width: 1), // Viền màu xanh khi được chọn
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
              hintStyle: const TextStyle(
                  color: Color(0xff939393),
                  fontFamily: 'Jost',
                  fontWeight: FontWeight.w500,
                  fontSize: 16), // Gợi ý màu xám nhạt
              suffixIcon: GestureDetector(
                onTap: () => controller.toggleEntryPasswordObscureText(),
                child: Icon(
                  controller.isEntryPasswordObscured.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.grey.withOpacity(0.8), // Màu biểu tượng mắt
                ),
              ),
            ),
            onChanged: controller.onChangeConfirmPassword,
            validator: controller.validatorConfirmPassword,
          ),
        ),
      ],
    );
  }

  Column _formPassword(SignUpViewModel controller) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Password', style: TextStyle(
              fontSize: 12,
              color: Color(0xff131118),
              fontFamily: 'Jost',
              fontWeight: FontWeight.w400,),),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Obx(
              () => TextFormField(
            obscureText: controller.isObscured.value,

            style: const TextStyle(
                color: Color(0xff939393),
                fontFamily: 'Jost',
                fontWeight: FontWeight.w500,
                fontSize: 16), // Chữ màu đen để dễ nhìn trên nền trắng
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10), // Bo góc đường viền
                borderSide: const BorderSide(
                    color: Colors.black, width: 1), // Viền màu xám
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Colors.blue, width: 1), // Viền màu xanh khi được chọn
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
                    width: 2), // Viền đỏ khi có lỗi và đang được chọn
              ),
              filled: true,
              fillColor: Colors.white, // Màu nền xám nhạt cho trường nhập
              hintText: 'Password',
              hintStyle: const TextStyle(
                  color: Color(0xff939393),
                  fontFamily: 'Jost',
                  fontWeight: FontWeight.w500,
                  fontSize: 16), // Gợi ý màu xám nhạt
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
        ),
      ],
    );
  }

  Column _formEmail(SignUpViewModel controller) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Email Address', style: TextStyle(
              fontSize: 12,
              color: Color(0xff131118),
              fontFamily: 'Jost',
              fontWeight: FontWeight.w400,),),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          obscureText: false,
          style: const TextStyle(
              color: Color(0xff939393),
              fontFamily: 'Jost',
              fontWeight: FontWeight.w500,
              fontSize: 16), // Chữ màu đen để hiển thị rõ trên nền trắng
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), // Bo góc đường viền
              borderSide: const BorderSide(
                  color: Colors.black, width: 1), // Viền màu xám nhạt
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: Colors.blue, width: 1), // Viền màu xanh khi được chọn
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
                  width: 2), // Viền đỏ khi có lỗi và đang được chọn
            ),
            filled: true,
            fillColor: Colors.white, // Màu nền xám nhạt cho trường nhập
            hintText: 'Email',
            hintStyle: const TextStyle(
                color: Color(0xff939393),
                fontFamily: 'Jost',
                fontWeight: FontWeight.w500,
                fontSize: 16), // Gợi ý màu xám nhạt
          ),
          onChanged: controller.onChangeUsername,
          validator: controller.validatorUsername,
        ),
      ],
    );
  }

  Column _buildTextField( {
    required String label,
    required String hintText,
    required bool obscureText,
    required Function(String) onChanged,
    required String? Function(String?) validator,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(
              fontSize: 12,
              color: Color(0xff131118),
              fontFamily: 'Jost',
              fontWeight: FontWeight.w400,),),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          obscureText: obscureText,
          style: const TextStyle(
              color: Color(0xff939393),
              fontFamily: 'Jost',
              fontWeight: FontWeight.w500,
              fontSize: 16),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            hintStyle: const TextStyle(
                color: Color(0xff939393),
                fontFamily: 'Jost',
                fontWeight: FontWeight.w500,
                fontSize: 16),
          ),
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }
}
