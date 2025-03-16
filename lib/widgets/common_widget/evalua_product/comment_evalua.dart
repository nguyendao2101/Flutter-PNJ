import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../view_model/by_cart_view_model.dart';
import '../../../view_model/comment_view_model.dart';
import '../../../view_model/evalua_product_view_model.dart';
import '../../../view_model/profile_view_model.dart';
import '../../common/image_extention.dart';
import '../rating/product_rating_detail.dart';

class EvaluationScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  const EvaluationScreen({super.key, required this.product});
  @override
  _EvaluationScreenState createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  late Future<List<Map<String, dynamic>>> futureEvaluations;
  late Future<List<Map<String, dynamic>>> futureComment;
  final controllerId = Get.put(ByCartViewModel());
  final controllerEva = Get.put(EvaluaProductViewModel());
  final controllerComment = Get.put(CommentViewModel());
  final controllerPro = Get.put(ProfileViewModel());
  TextEditingController _commentUser = TextEditingController();
  List<Map<String, dynamic>> comments = [];

  @override
  void initState() {
    super.initState();
    futureEvaluations = controllerEva.fetchEvaluationsFromFirestore(); // Gọi 1 lần duy nhất
    futureComment = controllerComment.fetchCommentFromFirestore(); // Gọi 1 lần duy nhất
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: futureComment, // Dùng biến lưu Future
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error loading evaluations'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No evaluations found'));
              } else {
                final evaluations = snapshot.data!;
                final filteredEvaluations = evaluations.where((eval) => eval['idProduct'] == widget.product['id']).toList();
                return Column(
                  children: [
                    Column(
                      children: [
                        const Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start, // Đảm bảo căn chỉnh các thành phần theo trục trên cùng
                          children: [
                            Container(
                              width: 50,
                              height: 50,
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
                            const SizedBox(width: 10),
                            Expanded( // Đặt nội dung văn bản trong `Expanded` để hỗ trợ xuống dòng
                              child: TextField(
                                controller: _commentUser,
                                minLines: 1,
                                decoration: InputDecoration(
                                  hintText: 'Enter your comment here...',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Color(0xffA02334)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8,),
                            ElevatedButton(
                              onPressed: () {
                                controllerComment.addCommentToFirestore(
                                    content: _commentUser.text,
                                    emailUser: controllerId.userId.toString(),
                                    idProduct: widget.product['id'],
                                    idUser: controllerId.userId.toString(),
                                    nameProduct: widget.product['nameProduct'],
                                    nameUser: controllerPro.userData['fullName'] ?? 'User');
                                setState(() {
                                  filteredEvaluations.insert(0, {
                                    'content': _commentUser.text,
                                    'nameUser': controllerPro.userData['fullName'] ?? 'User',
                                    'idProduct': widget.product['id'],
                                  });
                                  _commentUser.clear();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffA02334),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Send',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: filteredEvaluations
                          .map(
                            (eval) => Column(
                          children: [
                            const Divider(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start, // Đảm bảo căn chỉnh các thành phần theo trục trên cùng
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
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
                                const SizedBox(width: 20),
                                Expanded( // Đặt nội dung văn bản trong `Expanded` để hỗ trợ xuống dòng
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        eval['nameUser'] ?? 'Unknown',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff32343E),
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Inter',
                                        ),
                                        overflow: TextOverflow.clip, // Hiển thị toàn bộ nội dung
                                        softWrap: true, // Cho phép xuống dòng
                                      ),
                                      const SizedBox(height: 5), // Thêm khoảng cách giữa các văn bản
                                      Text(
                                        eval['content'] ?? 'No comment',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff32343E),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Inter',
                                        ),
                                        overflow: TextOverflow.clip, // Hiển thị toàn bộ nội dung
                                        softWrap: true, // Cho phép xuống dòng
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                          ],
                        ),
                      )
                          .toList(),
                    ),
                  ],
                );
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: futureEvaluations, // Dùng biến lưu Future
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error loading evaluations'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No evaluations found'));
              } else {
                final evaluations = snapshot.data!;
                final filteredEvaluations = evaluations.where((eval) => eval['idProduct'] == widget.product['id']).toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: filteredEvaluations
                      .map(
                        (eval) =>
                            Column(
                      children: [
                        const Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start, // Đảm bảo căn chỉnh các thành phần theo trục trên cùng
                          children: [
                            Container(
                              width: 50,
                              height: 50,
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
                            const SizedBox(width: 20),
                            Expanded( // Đặt nội dung văn bản trong `Expanded` để hỗ trợ xuống dòng
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ProductRatingDetail(rating: eval['star']*1.0,),
                                  Text(
                                    eval['nameUser'] ?? 'Unknown',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff32343E),
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Inter',
                                    ),
                                    overflow: TextOverflow.clip, // Hiển thị toàn bộ nội dung
                                    softWrap: true, // Cho phép xuống dòng
                                  ),
                                  const SizedBox(height: 5), // Thêm khoảng cách giữa các văn bản
                                  Text(
                                    eval['content'] ?? 'No comment',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff32343E),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Inter',
                                    ),
                                    overflow: TextOverflow.clip, // Hiển thị toàn bộ nội dung
                                    softWrap: true, // Cho phép xuống dòng
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                  )
                      .toList(),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
