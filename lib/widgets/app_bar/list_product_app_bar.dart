import 'package:flutter/material.dart';
import 'package:flutter_pnj/widgets/common/image_extention.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ListProductAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final BuildContext context;

  const ListProductAppBar({super.key, required this.context, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          const SizedBox(width: 12,),
          Text(title, style: const TextStyle(
            fontSize: 24,
            color: Color(0xff131118),
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,),),
          const Spacer(),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
