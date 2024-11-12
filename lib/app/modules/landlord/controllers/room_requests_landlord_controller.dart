import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/yeu_cau_thue_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/phong_model.dart';
import './landlord_controller.dart';

class RoomRequestsLandlordController extends GetxController {
  final LandlordController landlordController;
  final _firestore = FirebaseFirestore.instance;

  RoomRequestsLandlordController(this.landlordController);

  final isLoading = true.obs;
  final requests = <YeuCauThueModel>[].obs;
  final tenants = <String, UserModel>{}.obs;
  final rooms = <String, PhongModel>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadRequests();
  }

  Future<void> loadRequests() async {
    try {
      isLoading.value = true;
      final user = landlordController.currentUser;
      if (user == null) return;

      // Lấy danh sách phòng của chủ trọ
      final roomsSnapshot = await _firestore
          .collection('phong')
          .where('chuTroId', isEqualTo: user.uid)
          .get();

      final roomIds = roomsSnapshot.docs.map((doc) => doc.id).toList();

      // Lấy yêu cầu thuê cho các phòng
      final requestsSnapshot = await _firestore
          .collection('yeuCauThue')
          .where('phongId', whereIn: roomIds)
          .where('trangThai', isEqualTo: 'choXacNhan')
          .orderBy('ngayTao', descending: true)
          .get();

      // Lưu thông tin phòng
      for (var doc in roomsSnapshot.docs) {
        rooms[doc.id] = PhongModel.fromJson({
          'id': doc.id,
          ...doc.data(),
        });
      }

      // Lấy thông tin người thuê
      final tenantIds = requestsSnapshot.docs
          .map((doc) => doc.data()['nguoiThueId'] as String)
          .toSet();

      for (var tenantId in tenantIds) {
        final tenantDoc =
            await _firestore.collection('nguoiDung').doc(tenantId).get();
        if (tenantDoc.exists) {
          tenants[tenantId] = UserModel.fromJson({
            'uid': tenantDoc.id,
            ...tenantDoc.data()!,
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
      // Kiểm tra xem người thuê đã có phòng chưa
      final roomsSnapshot = await _firestore
          .collection('phong')
          .where('nguoiThueHienTai', arrayContains: request.nguoiThueId)
          .get();

      if (roomsSnapshot.docs.isNotEmpty) {
        Get.snackbar(
          'Thông báo',
          'Người này đã có phòng rồi',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Kiểm tra số lượng người trong phòng
      final room = rooms[request.phongId];
      if (room != null) {
        int maxPeople = room.loaiPhong == 'ktx' ? 4 : 2;
        if (room.nguoiThueHienTai.length >= maxPeople) {
          Get.snackbar(
            'Thông báo',
            'Phòng đã đủ số người tối đa',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
      }

      // Cập nhật trạng thái yêu cầu
      await _firestore.collection('yeuCauThue').doc(request.id).update({
        'trangThai': 'daChapNhan',
        'ngayCapNhat': FieldValue.serverTimestamp(),
      });

      // Thêm hoạt động
      await _firestore.collection('hoatDong').add({
        'chuTroId': landlordController.currentUser?.uid,
        'loai': 'chapNhanYeuCau',
        'nguoiThueId': request.nguoiThueId,
        'phongId': request.phongId,
        'ngayTao': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Thành công',
        'Đã chấp nhận yêu cầu thuê phòng',
        snackPosition: SnackPosition.BOTTOM,
      );

      await loadRequests();
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể chấp nhận yêu cầu: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> rejectRequest(YeuCauThueModel request) async {
    try {
      await _firestore.collection('yeuCauThue').doc(request.id).update({
        'trangThai': 'tuChoi',
        'ngayCapNhat': FieldValue.serverTimestamp(),
      });

      // Thêm hoạt động
      await _firestore.collection('hoatDong').add({
        'chuTroId': landlordController.currentUser?.uid,
        'loai': 'tuChoiYeuCau',
        'nguoiThueId': request.nguoiThueId,
        'phongId': request.phongId,
        'ngayTao': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Thành công',
        'Đã từ chối yêu cầu thuê phòng',
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

  UserModel? getTenantInfo(String tenantId) => tenants[tenantId];
  PhongModel? getRoomInfo(String roomId) => rooms[roomId];
} 