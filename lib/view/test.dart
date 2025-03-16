// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../view_model/by_cart_view_model.dart';
// import '../../../view_model/comment_view_model.dart';
// import '../../../view_model/evalua_product_view_model.dart';
// import '../../../view_model/profile_view_model.dart';
// import '../../common/image_extention.dart';
// import '../rating/product_rating_detail.dart';
//
// class EvaluationScreen extends StatefulWidget {
//   final Map<String, dynamic> product;
//   const EvaluationScreen({super.key, required this.product});
//
//   @override
//   _EvaluationScreenState createState() => _EvaluationScreenState();
// }
//
// class _EvaluationScreenState extends State<EvaluationScreen> {
//   late Future<List<Map<String, dynamic>>> futureEvaluations;
//   late Future<List<Map<String, dynamic>>> futureComment;
//   final controllerId = Get.put(ByCartViewModel());
//   final controllerEva = Get.put(EvaluaProductViewModel());
//   final controllerComment = Get.put(CommentViewModel());
//   final controllerPro = Get.put(ProfileViewModel());
//   TextEditingController _commentUser  = TextEditingController();
//
//   List<Map<String, dynamic>> comments = []; // Biến để lưu trữ bình luận
//
//   @override
//   void initState() {
//     super.initState();
//     futureEvaluations = controllerEva.fetchEvaluationsFromFirestore();
//     futureComment = controllerComment.fetchCommentFromFirestore().then((value) {
//       setState(() {
//         comments = value; // Lưu bình luận vào biến
//       });
//       return value;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: FutureBuilder<List<dynamic>>(
//         future: Future.wait([futureEvaluations, futureComment]),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return const Center(child: Text('Error loading data'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No data found'));
//           } else {
//             final List<Map<String, dynamic>> evaluations = snapshot.data![0];
//
//             return Column(
//               children: [
//                 Column(
//                   children: [
//                     const Divider(),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           width: 50,
//                           height: 50,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.grey.shade300,
//                           ),
//                           child: ClipOval(
//                             child: Image.asset(
//                               ImageAsset.users,
//                               height: 40,
//                               width: 40,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: TextField(
//                             controller: _commentUser ,
//                             minLines: 1,
//                             decoration: InputDecoration(
//                               hintText: 'Enter your comment here...',
//                               hintStyle: TextStyle(color: Colors.grey),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide: const BorderSide(color: Colors.grey),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide: const BorderSide(color: Color(0xffA02334)),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 8,),
//                         ElevatedButton(
//                           onPressed: () {
//                             controllerComment.addCommentToFirestore(
//                                 content: _commentUser.text,
//                                 emailUser: controllerId.userId.toString(),
//                                 idProduct: widget.product['id'],
//                                 idUser: controllerId.userId.toString(),
//                                 nameProduct: widget.product['nameProduct'],
//                                 nameUser: controllerPro.userData['fullName'] ?? 'User');
//                             setState(() {
//                               comments.insert(0, {
//                                 'content': _commentUser.text,
//                                 'nameUser': controllerPro.userData['fullName'] ?? 'User'
//                               });
//                               _commentUser.clear();
//                             });
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xffA02334),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: const Text(
//                             'Send',
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.white
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Divider(),
//                   ],
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: evaluations.map((eval) {
//                     return Column(
//                       children: [
//                         const Divider(),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: 50,
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.grey.shade300,
//                               ),
//                               child: ClipOval(
//                                 child: Image.asset(
//                                   ImageAsset.users,
//                                   height: 40,
//                                   width: 40,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 20),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   ProductRatingDetail(rating: eval['star'] * 1.0),
//                                   Text(
//                                     eval['nameUser '] ?? 'Unknown',
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       color: Color(0xff32343E),
//                                       fontWeight: FontWeight.w600,
//                                       fontFamily: 'Inter',
//                                     ),
//                                     overflow: TextOverflow.clip,
//                                     softWrap: true,
//                                   ),
//                                   const SizedBox(height: 5),
//                                   Text(
//                                     eval['content'] ?? 'No comment',
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       color: Color(0xff32343E),
//                                       fontWeight: FontWeight.w400,
//                                       fontFamily: 'Inter',
//                                     ),
//                                     overflow: TextOverflow.clip,
//                                     softWrap: true,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         const Divider(),
//                       ],
//                     );
//                   }).toList(),
//                 ),
//                 // Hiển thị bình luận
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: comments.map((comment) {
//                     return Column(
//                       children: [
//                         const Divider(),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: 50,
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.grey.shade300,
//                               ),
//                               child: ClipOval(
//                                 child: Image.asset(
//                                   ImageAsset.users,
//                                   height: 40,
//                                   width: 40,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 20),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     comment['nameUser '] ?? 'Unknown',
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       color: Color(0xff32343E),
//                                       fontWeight: FontWeight.w600,
//                                       fontFamily: 'Inter',
//                                     ),
//                                     overflow: TextOverflow.clip,
//                                     softWrap: true,
//                                   ),
//                                   const SizedBox(height: 5),
//                                   Text(
//                                     comment['content'] ?? 'No comment',
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       color: Color(0xff32343E),
//                                       fontWeight: FontWeight.w400,
//                                       fontFamily: 'Inter',
//                                     ),
//                                     overflow: TextOverflow.clip,
//                                     softWrap: true,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         const Divider(),
//                       ],
//                     );
//                   }).toList(),
//                 ),
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }
// }