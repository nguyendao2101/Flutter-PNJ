import 'package:flutter/material.dart';
import 'package:flutter_pnj/view/change_passs.dart';
import 'package:get/get.dart';

import '../../../view_model/profile_view_model.dart';
import '../../app_bar/personal_apbar.dart';
import '../../common/image_extention.dart';

class PersonalInfo extends StatelessWidget {
  const PersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileViewModel());

    return Scaffold(
      appBar: const AppBarProfile(title: 'Personal Info'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: AssetImage(ImageAsset.users),
            ),
            const SizedBox(height: 20),
            Text(
              controller.userData['fullName'] ?? '',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xff111A2C),
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 5),
            Text(
              controller.userData['email'] ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xff6C757D),
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 30),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildUserInfoTile(
                      title: 'Full Name',
                      value: controller.userData['fullName'],
                      icon: Icons.person,
                    ),
                    const Divider(),
                    _buildUserEmailTile(
                      title: 'Email',
                      icon: Icons.email,
                      value: controller.userData['email'],
                    ),
                    const Divider(),
                    _buildUserInfoTile(
                      title: 'Gender',
                      value: controller.userData['sex'],
                      icon: Icons.wc,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Các nút chức năng
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.toNamed('/edit-profile');
                      },
                      icon: const Icon(
                        Icons.edit,
                        size: 18,
                        color: Color(0xff111A2C), // icon màu đen
                      ),
                      label: const Text(
                        'Sửa thông tin',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Color(0xff111A2C), // chữ màu đen
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // nền trắng
                        elevation: 0, // không bóng
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                            color: Color(0xff111A2C), // viền đen
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const ChangePasswordSheet(),
                        );
                      },
                      icon: const Icon(
                        Icons.lock,
                        size: 18,
                        color: Color(0xff111A2C), // icon màu đen
                      ),
                      label: const Text(
                        'Đổi mật khẩu',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Color(0xff111A2C), // chữ màu đen
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // nền trắng
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                            color: Color(0xff111A2C), // viền đen
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoTile({
    required String title,
    String? value,
    required IconData icon,
  }) {
    String displayedValue = (value != null && value.length > 12)
        ? value.substring(0, 12) + '...'
        : (value ?? 'N/A');

    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xff111A2C),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xff111A2C),
          fontFamily: 'Inter',
        ),
      ),
      trailing: Text(
        displayedValue,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Color(0xff6C757D),
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildUserEmailTile({
    required String title,
    String? value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: const Color(0xff111A2C),
                size: 20,
              ),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff111A2C),
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value ?? 'N/A',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color(0xff6C757D),
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
