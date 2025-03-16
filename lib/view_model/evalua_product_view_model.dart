import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class EvaluaProductViewModel extends GetxController{
  List<Map<String, dynamic>> evaluations = <Map<String, dynamic>>[].obs;


  Future<void> addOrderToFirestore({
    required String content,
    required String emailUser,
    required double? star,
    required String idProduct,
    required String idUser,
    required String nameProduct,
    required String nameUser,
  }) async {
    try {
      // Lấy tham chiếu đến collection 'orders'
      final ordersCollection = FirebaseFirestore.instance.collection('Evaluations');

      // Tạo orderId bằng timestamp
      final orderId = DateTime.now().millisecondsSinceEpoch.toString();

      // Dữ liệu đơn hàng với orderId
      final orderData = {
        "id": orderId,
        "content": content,
        "emailUser": emailUser,
        "star": star,
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
  Future<List<Map<String, dynamic>>> fetchEvaluationsFromFirestore() async {
    try {
      final evaluationsCollection =
      FirebaseFirestore.instance.collection('Evaluations');

      // Lấy dữ liệu từ Firestore, sắp xếp theo `timeEvaluation` giảm dần
      final querySnapshot =
      await evaluationsCollection.orderBy('timeEvaluation', descending: true).get();

      // Chuyển đổi danh sách thành List<Map<String, dynamic>>
      evaluations = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return evaluations;
    } catch (e) {
      print('Error fetching evaluations: $e');
      return [];
    }
  }


  Future<double> getAverageEvaluationByProduct(String productId) async {
    try {
      // Lấy tham chiếu đến collection 'evaluations'
      final evaluationsCollection = FirebaseFirestore.instance.collection('Evaluations');

      // Lọc các đánh giá liên quan đến productId
      final querySnapshot = await evaluationsCollection.where('idProduct', isEqualTo: productId).get();

      // Kiểm tra nếu có dữ liệu
      if (querySnapshot.docs.isEmpty) {
        print('No evaluations found for product $productId.');
        return 0.0; // Trả về 0 nếu không có đánh giá cho sản phẩm
      }

      // Tính tổng điểm đánh giá và số lượng đánh giá
      double totalEvalua = 0.0;
      int count = 0;

      for (var doc in querySnapshot.docs) {
        // Lấy giá trị evalua từ mỗi đánh giá
        double evalua = doc['star'] ?? 0.0; // Nếu không có evalua, mặc định là 0.0
        totalEvalua += evalua;
        count++;
      }

      // Tính trung bình
      double averageEvalua = totalEvalua / count;

      print('Average evaluation for product $productId: $averageEvalua');
      return averageEvalua;
    } catch (e) {
      print('Error getting evaluations for product $productId: $e');
      return 0.0; // Trả về 0 nếu có lỗi
    }
  }

  Future<List<Map<String, String>>> getEvaluationsByProduct(String productId) async {
    try {
      // Lấy tham chiếu đến collection 'evaluations'
      final evaluationsCollection = FirebaseFirestore.instance.collection('Comments');

      // Lọc các đánh giá liên quan đến productId
      final querySnapshot = await evaluationsCollection.where('idProduct', isEqualTo: productId).get();

      // Kiểm tra nếu có dữ liệu
      if (querySnapshot.docs.isEmpty) {
        print('No evaluations found for product $productId.');
        return []; // Trả về danh sách trống nếu không có đánh giá
      }

      // Danh sách để lưu tên và bình luận
      List<Map<String, String>> evaluations = [];

      for (var doc in querySnapshot.docs) {
        // Lấy tên sản phẩm và bình luận từ mỗi đánh giá
        String nameUser = doc['nameUser'] ?? 'Unknown Product';
        String comment = doc['comment'] ?? 'No comment';

        // Thêm tên sản phẩm và bình luận vào danh sách
        evaluations.add({
          'nameUser': nameUser,
          'comment': comment,
        });
      }

      print('Evaluations for product $productId: $evaluations');
      return evaluations;
    } catch (e) {
      print('Error getting evaluations for product $productId: $e');
      return []; // Trả về danh sách trống nếu có lỗi
    }
  }


}