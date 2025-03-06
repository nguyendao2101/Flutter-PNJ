import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/image_extention.dart';

class FunctionPng extends StatelessWidget {
  final String image;
  final String title;
  const FunctionPng({super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
                height: 36,
                width: 36,
                decoration: const BoxDecoration(
                  shape: BoxShape
                      .circle, // Đặt hình dạng của container là hình tròn
                  color: Color(0xffFFFFFF),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    image,
                  ),
                )),
            const SizedBox(width: 20,),
            Text(title, style: const TextStyle(
              fontSize: 15,
              color: Color(0xff111A2C),
              fontWeight: FontWeight.w400,
              fontFamily: 'Inter',
            ),),
          ],
        ),
        SvgPicture.asset(ImageAsset.arrowRight),
      ],
    );
  }
}
