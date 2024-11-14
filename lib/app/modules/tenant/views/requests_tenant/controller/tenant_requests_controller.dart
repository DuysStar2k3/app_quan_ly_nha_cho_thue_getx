import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../data/models/yeu_cau_thue_model.dart';
import '../../../../../data/models/phong_model.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/controllers/tenant_page_controller.dart';

class TenantRequestsController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final TenantPageController tenantPageController;

  TenantRequestsController(this.tenantPageController);

  final isLoading = true.obs;
  final requests = <YeuCauThueModel>[].obs;
  final rooms = <String, PhongModel>{}.obs;

  // Thêm getters để phân loại yêu cầu
  List<YeuCauThueModel> get myRequests => requests.where((req) {
        // Yêu cầu do tôi gửi đi (chờ chủ trọ xác nhận)
        return req.nguoiThueId == tenantPageController.currentUser?.uid &&
            req.trangThai == 'choXacNhan';
      }).toList();

  List<YeuCauThueModel> get receivedRequests => requests.where((req) {
        // Yêu cầu được chủ trọ gửi đến (đã chấp nhận, chờ tôi xác nhận)
        return req.nguoiThueId == tenantPageController.currentUser?.uid &&
            req.trangThai == 'daChapNhan';
      }).toList();

  @override
  void onInit() {
    super.onInit();
    loadRequests();
  }

  Future<void> loadRequests() async {
    try {
      isLoading.value = true;
      final user = tenantPageController.currentUser;
      if (user == null) return;

      // Lấy tất cả yêu cầu của người thuê
      final requestsSnapshot = await _firestore
          .collection('yeuCauThue')
          .where('nguoiThueId', isEqualTo: user.uid)
          .orderBy('ngayTao', descending: true)
          .get();

      // Lấy thông tin phòng
      final roomIds = requestsSnapshot.docs
          .map((doc) => doc.data()['phongId'] as String)
          .toSet();

      for (var roomId in roomIds) {
        final roomDoc = await _firestore.collection('phong').doc(roomId).get();
        if (roomDoc.exists) {
          rooms[roomId] = PhongModel.fromJson({
            'id': roomDoc.id,
            ...roomDoc.data()!,
          });
        }
      }

      // Cập nhật danh sách yêu cầu
      requests.value = requestsSnapshot.docs
          .map((doc) => YeuCauThueModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      print('Error loading requests: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptRequest(YeuCauThueModel request) async {
    try {
      final user = tenantPageController.currentUser;
      if (user == null) return;

      // Kiểm tra xem người thuê đã có phòng chưa
      final currentRoomSnapshot = await _firestore
          .collection('phong')
          .where('nguoiThueHienTai', arrayContains: user.uid)
          .get();

      if (currentRoomSnapshot.docs.isNotEmpty) {
        Get.snackbar(
          'Thông báo',
          'Bạn đã có phòng rồi, không thể tham gia phòng khác',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Kiểm tra số lượng người trong phòng
      final roomDoc =
          await _firestore.collection('phong').doc(request.phongId).get();
      if (!roomDoc.exists) {
        throw 'Không tìm thấy thông tin phòng';
      }

      final room = PhongModel.fromJson({
        'id': roomDoc.id,
        ...roomDoc.data()!,
      });

      int maxPeople = room.loaiPhong == 'ktx' ? 4 : 2;
      if (room.nguoiThueHienTai.length >= maxPeople) {
        Get.snackbar(
          'Thông báo',
          'Phòng đã đủ số người tối đa',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Cập nhật trạng thái yêu cầu
      await _firestore.collection('yeuCauThue').doc(request.id).update({
        'trangThai': 'daXacNhan',
        'ngayCapNhat': FieldValue.serverTimestamp(),
      });

      // Thêm người thuê vào phòng
      await _firestore.collection('phong').doc(request.phongId).update({
        'nguoiThueHienTai': FieldValue.arrayUnion([request.nguoiThueId]),
        'trangThai': 'daThue',
        'ngayCapNhat': FieldValue.serverTimestamp(),
      });

      // Thêm hoạt động
      await _firestore.collection('hoatDong').add({
        'nguoiThueId': tenantPageController.currentUser?.uid,
        'loai': 'xacNhanThamGia',
        'phongId': request.phongId,
        'soPhong': rooms[request.phongId]?.soPhong,
        'ngayTao': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Thành công',
        'Đã xác nhận tham gia phòng',
        snackPosition: SnackPosition.BOTTOM,
      );

      await loadRequests();
    } catch (e) {
      print('Error accepting request: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể xác nhận: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> rejectRequest(YeuCauThueModel request) async {
    try {
      await _firestore.collection('yeuCauThue').doc(request.id).update({
        'trangThai': 'daHuy',
        'ngayCapNhat': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Thành công',
        'Đã từ chối yêu cầu',
        snackPosition: SnackPosition.BOTTOM,
      );

      await loadRequests();
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể từ chối yêu cầu: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> cancelRequest(YeuCauThueModel request) async {
    try {
      await _firestore.collection('yeuCauThue').doc(request.id).update({
        'trangThai': 'daHuy',
        'ngayCapNhat': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Thành công',
        'Đã hủy yêu cầu',
        snackPosition: SnackPosition.BOTTOM,
      );

      await loadRequests();
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể hủy yêu cầu: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  String getRequestStatus(String status) {
    switch (status) {
      case 'choXacNhan':
        return 'Đang chờ xác nhận';
      case 'daChapNhan':
        return 'Đã chấp nhận';
      case 'daXacNhan':
        return 'Đã xác nhận';
      case 'tuChoi':
        return 'Đã từ chối';
      case 'daHuy':
        return 'Đã hủy';
      default:
        return 'Không xác định';
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'choXacNhan':
        return Colors.orange;
      case 'daChapNhan':
        return Colors.blue;
      case 'daXacNhan':
        return Colors.green;
      case 'tuChoi':
      case 'daHuy':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  PhongModel? getRoomInfo(String roomId) => rooms[roomId];
}
