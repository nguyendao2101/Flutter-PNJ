import 'package:flutter/material.dart';
import 'package:flutter_pnj/view/buy_cart_view.dart';
import 'package:flutter_pnj/view/collection_view.dart';
import 'package:flutter_pnj/view/home_view.dart';
import 'package:flutter_pnj/view/user_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../view_model/main_nav_view_model.dart';
import '../widgets/common/image_extention.dart';

class MainNavView extends StatelessWidget {
  final int initialIndex;

  const MainNavView({super.key, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainNavViewModel());
    return DefaultTabController(
      length: 4,
      initialIndex: initialIndex,
      child: Scaffold(
        key: controller.scaffoldKey,
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(), // Tắt vuốt giữa các tab
          children: [
            HomeView(),
            CollectionView(),
            BuyCartView(),
            UserView()
          ],
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final TabController tabController = DefaultTabController.of(context);
    final controller = Get.find<MainNavViewModel>();

    return Obx(() {
      return Stack(
        children: [
          Container(
            height: 80,
            decoration:  BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, -2),
                )
              ],
            ),
            child: BottomAppBar(
              color: Colors.white,
              elevation: 0,
              child: TabBar(
                controller: tabController,
                onTap: (index) => controller.updateSelectedTab(index),
                indicator: const BoxDecoration(),
                indicatorColor: Colors.transparent,
                labelColor: const Color(0xFFD42323),
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Jost',
                  fontWeight: FontWeight.w400,
                ),
                unselectedLabelColor: Colors.black,
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Jost',
                  fontWeight: FontWeight.w400,),
                tabs: [
                  Tab(
                    text: 'Home',
                    icon: SvgPicture.asset(
                      controller.selectedTab.value == 0
                          ? ImageAsset.home
                          : ImageAsset.homeUn,
                      width: 24,
                      height: 24,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Tab(
                      text: 'Collection',
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: SvgPicture.asset(
                          controller.selectedTab.value == 1
                              ? ImageAsset.collection
                              : ImageAsset.collectionUn,
                          width: 26,
                          height: 26,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Tab(
                      text: 'By Cart',
                      icon: SvgPicture.asset(
                        controller.selectedTab.value == 2
                            ? ImageAsset.buyCart
                            : ImageAsset.buyCartUn,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Tab(
                      text: 'Profiles',
                      icon: SvgPicture.asset(
                        controller.selectedTab.value == 3
                            ? ImageAsset.user
                            : ImageAsset.userUn,
                        width: 26,
                        height: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 14,
              color: Colors.white, // Đường bo viền
            ),
          ),
        ],
      );
    });
  }

}
