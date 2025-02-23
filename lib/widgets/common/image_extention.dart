String baseImagePathPNG = 'assets/image';
String baseImagesPathSVG = 'assets/svg';

class ImageAsset{
  static const String format = '.svg';
  //logo
  static String loadLogoApp = '$baseImagePathPNG/logoApp.png';
  //banner
  static String banner1 = '$baseImagePathPNG/banner1.png';
  static String banner2 = '$baseImagePathPNG/banner2.png';
  static String banner3 = '$baseImagePathPNG/banner3.png';


  // SVG
  static String circle1 = '$baseImagesPathSVG/circle1$format';
  static String circle2 = '$baseImagesPathSVG/circle2$format';
  static String circle3 = '$baseImagesPathSVG/circle3$format';
  static String home = '$baseImagesPathSVG/home$format';
  static String homeUn = '$baseImagesPathSVG/home_un$format';
  static String collection = '$baseImagesPathSVG/collection$format';
  static String collectionUn = '$baseImagesPathSVG/collection_un$format';
  static String buyCart = '$baseImagesPathSVG/buy_cart$format';
  static String buyCartUn = '$baseImagesPathSVG/buy_cart_un$format';
  static String user = '$baseImagesPathSVG/user$format';
  static String userUn = '$baseImagesPathSVG/user_un$format';
}