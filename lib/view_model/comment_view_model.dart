import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CommentViewModel extends GetxController{
  Future<void> addCommentToFirestore({
    required String content,
    required String emailUser,
    required String idProduct,
    required String idUser,
    required String nameProduct,
    required String nameUser,
  }) async {
    try {
      // Lấy tham chiếu đến collection 'orders'
      final ordersCollection = FirebaseFirestore.instance.collection('Comments');

      // Tạo orderId bằng timestamp
      final orderId = DateTime.now().millisecondsSinceEpoch.toString();

      // Dữ liệu đơn hàng với orderId
      final orderData = {
        "id": orderId,
        "content": content,
        "hasFix": true,
        "emailUser": emailUser,
        "idProduct": idProduct,
        "idUser": idUser,
        "nameProduct": nameProduct,
        "nameUser": nameUser,
        "timeEvaluation": Timestamp.now(),
      };

      // Lưu dữ liệu với orderId là ID của tài liệu
      await ordersCollection.doc(orderId).set(orderData);

      print('Evalua with ID $orderId added successfully!');
    } catch (e) {
      print('Error adding order: $e');
    }
  }
  Future<List<Map<String, dynamic>>> fetchCommentFromFirestore() async {
    try {
      final evaluationsCollection =
      FirebaseFirestore.instance.collection('Comments');

      // Lấy dữ liệu từ Firestore, sắp xếp theo `timeEvaluation` giảm dần
      final querySnapshot =
      await evaluationsCollection.orderBy('timeEvaluation', descending: true).get();

      // Chuyển đổi danh sách thành List<Map<String, dynamic>>
      final List<Map<String, dynamic>> evaluations = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return evaluations;
    } catch (e) {
      print('Error fetching evaluations: $e');
      return [];
    }
  }
}