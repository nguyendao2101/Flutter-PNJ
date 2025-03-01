import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pnj/view_model/get_data_view_model.dart';
import 'package:flutter_pnj/view_model/home_view_model.dart';
import 'package:flutter_pnj/widgets/common/image_extention.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../widgets/common_widget/button/bassic_button_inter.dart';
import '../widgets/common_widget/footer/footer_view.dart';

class CollectionView extends StatefulWidget {
  const CollectionView({super.key});

  @override
  State<CollectionView> createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionView> {
  int _currentIndex = 0;
  final controller = Get.put(HomeViewModel());
  final controllerGetData = Get.put(GetDataViewModel());
  List<Map<String, dynamic>> _adminTitle = [];
  bool _isLoadingAdminTitle = true;

  List<Map<String, dynamic>> _advertisement = [];
  bool _isLoadingAdvertisement = true;

  @override
  void initState() {
    super.initState();
    _loadAdvertisement();
    _loadAdminTitle();
  }

  Future<void> _loadAdminTitle() async {
    await controllerGetData.fetchAdminTitle();
    setState(() {
      _adminTitle = controllerGetData.adminTitle;
      _isLoadingAdminTitle = false;
    });
  }


  Future<void> _loadAdvertisement() async {
    await controllerGetData.fetchAdvertisement();
    setState(() {
      _advertisement = controllerGetData.advertisement;
      _isLoadingAdvertisement = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 60,),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text('Món quà tuyệt vời cho tình yêu của bạn', style: TextStyle(
                  fontSize: 24,
                  color: Color(0xff131118),
                  fontFamily: 'Prata',
                  fontWeight: FontWeight.w400,),
                textAlign: TextAlign.center,),
              ),
              const SizedBox(height: 20),
              SvgPicture.asset(ImageAsset.horizontal),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Image.network('https://firebasestorage.googleapis.com/v0/b/duan-4904c.appspot.com/o/flutter_pnj%2FImage%20Home%2FImage%20B%E1%BB%99%20s%C6%B0u%20t%E1%BA%ADp%2FBosuutap_Onlyyou.png?alt=media&token=39ff59eb-d3e8-45d3-9d2a-d54cdaaf32fd'),
                    const SizedBox(height: 20),
                    const Text('Vì em là duy nhất', style: TextStyle(
                      fontSize: 24,
                      color: Color(0xff131118),
                      fontFamily: 'Prata',
                      fontWeight: FontWeight.w400,),
                      textAlign: TextAlign.center,),
                    const Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Text(' Bộ sưu tập lấy cảm hứng từ "Only You",với hình ảnh chữ O và U lồng ghép vào nhau tạo thành biểu tượng tinh tế, khéo léo mang vào thiết kế để tạo nên chiếc nhẫn cầu hôn với ý nghĩa đặc biệt: Chỉ trao tình yêu duy nhất một đời.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff131118),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,),
                        textAlign: TextAlign.center,),
                    ),
                    Image.network('https://firebasestorage.googleapis.com/v0/b/duan-4904c.appspot.com/o/flutter_pnj%2FImage%20Home%2FImage%20trang%20s%E1%BB%A9c%2FTrangsuc_nhan.png?alt=media&token=71f900cb-5a5a-416a-a344-1b47e9a596dc', height: 106,),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100),
                      child: BassicButtonInter(onPressed: () {},
                        title: 'SEE NOW', sizeTitle: 12,fontW: FontWeight.w700,colorButton: const Color(0xffAC3843),
                        height: 44, radius: 5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        const SizedBox(height: 20,),
                        Image.network('https://firebasestorage.googleapis.com/v0/b/duan-4904c.appspot.com/o/flutter_pnj%2FScreenshot%202025-02-26%20152938.png?alt=media&token=9090aaba-a778-4c7e-965c-75e8ebd95b66',),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: const Color(0xffFFBEC4)
                            )
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 80,),
                              const Text('Chót Mê', style: TextStyle(
                                fontSize: 24,
                                color: Color(0xff131118),
                                fontFamily: 'Prata',
                                fontWeight: FontWeight.w400,),
                                textAlign: TextAlign.center,),
                              const SizedBox(height: 40,),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: Text('Tình yêu là sự rung động từ trái tim, là những khoảnh khắc đáng trân quý mà ta luôn muốn gìn giữ.Bộ sưu tập Chót Mê ra đời như một cách tôn vinh cảm xúc chân thành, giúp bạn gửi gắm những lời yêu thương sâu sắc qua từng thiết kế trang sức tinh xảo.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff131118),
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,),
                                  textAlign: TextAlign.center,),
                              ),
                              const SizedBox(height: 60),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 100),
                                child: BassicButtonInter(onPressed: () {},
                                  title: 'SEE NOW', sizeTitle: 12,fontW: FontWeight.w700,colorButton: const Color(0xffAC3843),
                                  height: 44, radius: 5,
                                ),
                              ),
                              const SizedBox(height: 50),
      
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 60,),
              Container(
                width: double.infinity,
                height: 600,
                child: Stack(
                  children: [
                    Positioned.fill( // Ảnh nền lấp đầy Container
                      child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/duan-4904c.appspot.com/o/flutter_pnj%2FScreenshot%202025-02-26%20155924.png?alt=media&token=b024b5a8-c061-49c2-9b69-dfcc2eec80ea',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, 0.2), // Căn giữa theo chiều ngang, dịch xuống một chút
                      child: Column(
                        children: [
                          const SizedBox(height: 250,),
                          Container(
                            width: 180,
                            height: 44,
                            child: BassicButtonInter(
                              onPressed: () {},
                              title: 'SEE NOW',
                              sizeTitle: 12,
                              fontW: FontWeight.w700,
                              colorButton: const Color(0xffFFFFFF),
                              colortext: const Color(0xffAC3843),
                              height: 44,
                              radius: 5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Image.network('https://firebasestorage.googleapis.com/v0/b/duan-4904c.appspot.com/o/flutter_pnj%2FScreenshot%202025-02-26%20162938.png?alt=media&token=4a37cf34-db96-4180-a203-9e7e3af4fb10'),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: const Color(0xffFFBEC4)
                          )
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 80,),
                          const Text('Quý phái', style: TextStyle(
                            fontSize: 24,
                            color: Color(0xff131118),
                            fontFamily: 'Prata',
                            fontWeight: FontWeight.w400,),
                            textAlign: TextAlign.center,),
                          const SizedBox(height: 40,),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Text('Tỏa sáng với những thiết kế tinh xảo từ PNJ, được chế tác từ vàng, kim cương và đá quý cao cấp. Mỗi đôi bông tai không chỉ tôn vinh nét thanh lịch mà còn là biểu tượng của sự sang trọng và đẳng cấp, giúp bạn luôn rạng rỡ trong mọi khoảnh khắc.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff131118),
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,),
                              textAlign: TextAlign.center,),
                          ),
                          const SizedBox(height: 60),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 100),
                            child: BassicButtonInter(onPressed: () {},
                              title: 'SEE NOW', sizeTitle: 12,fontW: FontWeight.w700,colorButton: const Color(0xffAC3843),
                              height: 44, radius: 5,
                            ),
                          ),
                          const SizedBox(height: 50),
      
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
              Container(
                color: Color(0xffF5F3EF),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          const SizedBox(height: 80,),
                          const Text('COMBO ƯU ĐÃI', style: TextStyle(
                            fontSize: 24,
                            color: Color(0xff131118),
                            fontFamily: 'Prata',
                            fontWeight: FontWeight.w400,),
                            textAlign: TextAlign.center,),
                          const SizedBox(height: 40,),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Text('Khám phá ngay những combo trang sức PNJ với thiết kế tinh xảo, kết hợp hoàn hảo giữa nhẫn, bông tai, dây chuyền và lắc tay. Sở hữu vẻ đẹp sang trọng với mức giá hấp dẫn, giúp bạn tỏa sáng trong mọi dịp đặc biệt!',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff131118),
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,),
                              textAlign: TextAlign.center,),
                          ),
                          const SizedBox(height: 60),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 100),
                            child: BassicButtonInter(onPressed: () {},
                              title: 'SEE NOW', sizeTitle: 12,fontW: FontWeight.w700,colorButton: const Color(0xffAC3843),
                              height: 44, radius: 5,
                            ),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                    Image.network('https://firebasestorage.googleapis.com/v0/b/duan-4904c.appspot.com/o/flutter_pnj%2FScreenshot%202025-02-26%20164336.png?alt=media&token=3462d822-26a1-499a-aeab-c86e79d02d47'),
                    const SizedBox(height: 40,)
                  ],
                ),
              ),
              const FooterView(),
      
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _siboxTitle(String text, double width){
    return SizedBox(
      width: width,
      child: Column(
        children: [
          Text(text, style: const TextStyle(
            fontSize: 24,
            color: Color(0xff131118),
            fontFamily: 'Prata',
            fontWeight: FontWeight.w400,),),
          const SizedBox(height: 6,),
          const Divider(
            height: 1,
            thickness: 1,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
