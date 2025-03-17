import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordSheet extends StatefulWidget {
  const ChangePasswordSheet({super.key});

  @override
  State<ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<ChangePasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Reauthenticate user with current password
      final cred = EmailAuthProvider.credential(
        email: user!.email!,
        password: _currentPasswordController.text.trim(),
      );

      await user!.reauthenticateWithCredential(cred);

      // Update password
      await user!.updatePassword(_newPasswordController.text.trim());

      Get.back(); // Close bottom sheet
      Get.snackbar(
        'Thành công',
        'Đổi mật khẩu thành công!',
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green,
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'wrong-password') {
        message = 'Mật khẩu hiện tại không đúng!';
      } else if (e.code == 'weak-password') {
        message = 'Mật khẩu mới quá yếu!';
      } else {
        message = 'Đổi mật khẩu thất bại. Vui lòng thử lại.';
      }

      Get.snackbar(
        'Lỗi',
        message,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red,
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Có lỗi xảy ra. Vui lòng thử lại.',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red,
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (_, controller) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          controller: controller,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Icon(Icons.horizontal_rule, size: 40, color: Colors.grey),
              ),
              const Text(
                'Đổi mật khẩu',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff111A2C),
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildPasswordField(
                      label: 'Mật khẩu hiện tại',
                      controller: _currentPasswordController,
                      obscureText: _obscureCurrent,
                      toggleObscure: () {
                        setState(() {
                          _obscureCurrent = !_obscureCurrent;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildPasswordField(
                      label: 'Mật khẩu mới',
                      controller: _newPasswordController,
                      obscureText: _obscureNew,
                      toggleObscure: () {
                        setState(() {
                          _obscureNew = !_obscureNew;
                        });
                      },
                      validator: (value) {
                        if (value!.length < 6) {
                          return 'Mật khẩu ít nhất 6 ký tự';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildPasswordField(
                      label: 'Xác nhận mật khẩu mới',
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirm,
                      toggleObscure: () {
                        setState(() {
                          _obscureConfirm = !_obscureConfirm;
                        });
                      },
                      validator: (value) {
                        if (value != _newPasswordController.text) {
                          return 'Mật khẩu xác nhận không khớp';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _changePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff111A2C),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Xác nhận',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback toggleObscure,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Không được để trống';
            }
            return null;
          },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: toggleObscure,
        ),
      ),
    );
  }
}