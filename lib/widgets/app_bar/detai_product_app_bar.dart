import 'package:flutter/material.dart';
import 'package:flutter_pnj/widgets/common/image_extention.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetaiProductAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;

  const DetaiProductAppBar({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 🔙 Nút quay lại
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 36,
              width: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffD9D9D9),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  ImageAsset.backButton,
                  height: 5,
                  width: 6,
                  // color: Colors.red,
                ),
              ),
            ),
          ),

          // 🔘 Menu thả xuống
          SizedBox(
            width: 24,
            height: 24,
            child: PopupMenuButton<int>(
              color: Colors.white,
              offset: const Offset(-10, 15),
              elevation: 1,
              icon: SvgPicture.asset(
                ImageAsset.more,
                width: 12,
                height: 12,
              ),
              padding: EdgeInsets.zero,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  height: 30,
                  child: InkWell(
                    onTap: () {},
                    child: const Text(
                      "Report",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff32343E),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Jost',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
