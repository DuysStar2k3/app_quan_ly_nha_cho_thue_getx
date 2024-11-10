import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/phong_model.dart';

class RoomTenantController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final PhongModel room;

  RoomTenantController(this.room);

  final isLoading = true.obs;
  final tenants = <UserModel>[].obs;
  final searchResults = <UserModel>[].obs;
  final searchQuery = ''.obs;
  final isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTenants();
  }

  Future<void> loadTenants() async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore
          .collection('nguoiDung')
          .where('uid', whereIn: room.nguoiThueHienTai)
          .get();

      tenants.value = snapshot.docs
          .map((doc) => UserModel.fromJson({
                'uid': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      print('Error loading tenants: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      isSearching.value = false;
      return;
    }

    try {
      isSearching.value = true;

      // Lấy danh sách tất cả các phòng
      final allRoomsSnapshot = await _firestore.collection('phong').get();
      
      // Tạo set chứa ID của tất cả người thuê hiện tại
      final allTenantIds = <String>{};
      for (var doc in allRoomsSnapshot.docs) {
        final roomData = doc.data();
        if (roomData.containsKey('nguoiThueHienTai')) {
          allTenantIds.addAll(
            List<String>.from(roomData['nguoiThueHienTai'] ?? [])
          );
        }
      }

      // Tìm kiếm người thuê chưa có phòng
      final snapshot = await _firestore
          .collection('nguoiDung')
          .where('vaiTro', isEqualTo: 'nguoiThue')
          .get();

      final results = snapshot.docs
          .map((doc) => UserModel.fromJson({
                'uid': doc.id,
                ...doc.data(),
              }))
          .where((user) =>
              // Điều kiện tìm kiếm
              (user.ten.toLowerCase().contains(query.toLowerCase()) ||
                  user.soDienThoai.contains(query)) &&
              // Chưa thuê phòng nào
              !allTenantIds.contains(user.uid) &&
              // Không trong phòng hiện tại
              !room.nguoiThueHienTai.contains(user.uid))
          .toList();

      searchResults.value = results;
    } catch (e) {
      print('Error searching users: $e');
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> sendJoinRequest(UserModel user) async {
    try {
      // Kiểm tra xem người này đã có phòng chưa
      final roomsSnapshot = await _firestore
          .collection('phong')
          .where('nguoiThueHienTai', arrayContains: user.uid)
          .get();

      if (roomsSnapshot.docs.isNotEmpty) {
        Get.snackbar(
          'Thông báo',
          'Người này đã có phòng rồi',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Kiểm tra xem đã có yêu cầu chưa
      final existingRequest = await _firestore
          .collection('yeuCauThue')
          .where('nguoiThueId', isEqualTo: user.uid)
          .where('phongId', isEqualTo: room.id)
          .where('trangThai', whereIn: ['choXacNhan', 'daChapNhan', 'daXacNhan'])
          .get();

      if (existingRequest.docs.isNotEmpty) {
        Get.snackbar(
          'Thông báo',
          'Đã có yêu cầu tham gia cho người này',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Kiểm tra số lượng người trong phòng dựa vào loại phòng
      int maxPeople = room.loaiPhong == 'ktx' ? 4 : 2;
      if (room.nguoiThueHienTai.length >= maxPeople) {
        Get.snackbar(
          'Thông báo',
          'Phòng đã đủ số người tối đa',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Tạo yêu cầu mới
      final docRef = await _firestore.collection('yeuCauThue').add({
        'id': '', // Sẽ được cập nhật sau
        'nguoiThueId': user.uid,
        'phongId': room.id,
        'trangThai': 'daChapNhan', // Chủ trọ gửi nên mặc định là đã chấp nhận
        'loaiYeuCau': 'thamGia',
        'nguoiTaoId': room.chuTroId,
        'loaiNguoiTao': 'chuTro',
        'ngayTao': FieldValue.serverTimestamp(),
      });

      // Cập nhật ID cho yêu cầu
      await docRef.update({
        'id': docRef.id,
      });

      // Thêm hoạt động
      await _firestore.collection('hoatDong').add({
        'chuTroId': room.chuTroId,
        'loai': 'guiYeuCauThamGia',
        'nguoiThueId': user.uid,
        'phongId': room.id,
        'soPhong': room.soPhong,
        'ngayTao': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Thành công',
        'Đã gửi yêu cầu tham gia phòng',
        snackPosition: SnackPosition.BOTTOM,
      );

      print('Sent join request successfully: ${docRef.id}');
    } catch (e) {
      print('Error sending join request: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể gửi yêu cầu: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> removeTenant(UserModel tenant) async {
    try {
      await _firestore.collection('phong').doc(room.id).update({
        'nguoiThueHienTai': FieldValue.arrayRemove([tenant.uid]),
        'trangThai': room.nguoiThueHienTai.length <= 1 ? 'trong' : 'daThue',
        'ngayCapNhat': FieldValue.serverTimestamp(),
      });

      // Thêm hoạt động
      await _firestore.collection('hoatDong').add({
        'chuTroId': room.chuTroId,
        'loai': 'traPhong',
        'nguoiThueId': tenant.uid,
        'phongId': room.id,
        'soPhong': room.soPhong,
        'ngayTao': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Thành công',
        'Đã xóa người thuê khỏi phòng',
        snackPosition: SnackPosition.BOTTOM,
      );

      await loadTenants();
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể xóa người thuê: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
} 