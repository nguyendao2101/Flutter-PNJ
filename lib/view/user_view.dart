import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_model/profile_view_model.dart';
import '../widgets/common/image_extention.dart';
import '../widgets/common_widget/profile/function_png.dart';
import '../widgets/common_widget/profile/function_profile.dart';
import 'login_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final controller = Get.put(ProfileViewModel());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Profile',
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xff303030),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                ),
              )
            ],
          )),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade300,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        ImageAsset.users,
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 8),
                    child: Text(
                      controller.userData['fullName']?.toString() ?? 'User',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xff111A2C),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  const Text(
                    'Explore the food',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xff111A2C),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 16),
                    child: Container(
                      height: 170,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color(0xffF0F0F0).withOpacity(0.6)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 24, bottom: 15, left: 16, right: 20),
                          child: Column(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    // Get.to(() => const PersonalInfo());
                                  },
                                  child: FunctionProfile(
                                    image: ImageAsset.personalInfo,
                                    title: 'Personal Info',
                                  )),
                              const SizedBox(
                                height: 8,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    // Get.to(() => const Addresses());
                                  },
                                  child: FunctionProfile(
                                    image: ImageAsset.GPS,
                                    title: 'Addresses',
                                  )),
                              const SizedBox(
                                height: 8,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    // Get.to(() =>  OrderTracking(initialIndex: 0,));
                                  },
                                  child: FunctionProfile(
                                    image: ImageAsset.GPS,
                                    title: 'Order tracking',
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 16),
                    child: Container(
                      height: 214,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color(0xffF0F0F0).withOpacity(0.6)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 24, bottom: 15, left: 16, right: 20),
                          child: Column(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    print('da nhan');
                                    // Get.to(() => const OrdersView());
                                  },
                                  child: FunctionProfile(
                                    image: ImageAsset.cartPlus,
                                    title: 'Cart',
                                  )),
                              const SizedBox(
                                height: 8,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    // Get.to(() => const Favourite());
                                  },
                                  child: FunctionProfile(
                                    image: ImageAsset.favourist,
                                    title: 'Favourite',
                                  )),
                              const SizedBox(
                                height: 8,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    // Get.to(() => const NotificationPro());
                                  },
                                  child: FunctionProfile(
                                    image: ImageAsset.notification,
                                    title: 'Notification',
                                  )),
                              const SizedBox(
                                height: 8,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    // Get.to(() => Purchased());
                                  },
                                  child: FunctionPng(image: ImageAsset.purchased, title: 'Purchased')),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 16),
                    child: Container(
                      height: 80,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color(0xffF0F0F0).withOpacity(0.6)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 24, bottom: 15, left: 16, right: 20),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.offAll(() => const LoginView());
                                },
                                child: FunctionPng(image: ImageAsset.logout, title: 'Log Out'),)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
