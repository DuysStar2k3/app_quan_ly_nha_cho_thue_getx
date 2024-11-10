import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/phong_model.dart';
import './landlord_controller.dart';
import 'index.dart';

class TenantsController extends GetxController {
  final LandlordController landlordController;
  final _firestore = FirebaseFirestore.instance;

  TenantsController(this.landlordController);

  final isLoading = true.obs;
  final tenants = <UserModel>[].obs;
  final rooms = <String, PhongModel>{}.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadTenants();
  }

  Future<void> loadTenants() async {
    try {
      isLoading.value = true;
      final user = landlordController.currentUser;
      if (user == null) return;

      // Lấy danh sách phòng của chủ trọ
      final roomsSnapshot = await _firestore
          .collection('phong')
          .where('chuTroId', isEqualTo: user.uid)
          .get();

      // Lưu thông tin phòng và lấy danh sách người thuê
      final allTenantIds = <String>{};
      for (var doc in roomsSnapshot.docs) {
        final room = PhongModel.fromJson({
          'id': doc.id,
          ...doc.data(),
        });
        rooms[doc.id] = room;
        allTenantIds.addAll(room.nguoiThueHienTai);
      }

      // Lấy thông tin người thuê
      if (allTenantIds.isNotEmpty) {
        final tenantsSnapshot = await _firestore
            .collection('nguoiDung')
            .where('uid', whereIn: allTenantIds.toList())
            .get();

        tenants.value = tenantsSnapshot.docs
            .map((doc) => UserModel.fromJson({
                  'uid': doc.id,
                  ...doc.data(),
                }))
            .toList();
      } else {
        tenants.clear();
      }
    } catch (e) {
      print('Error loading tenants: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  List<UserModel> get filteredTenants {
    if (searchQuery.value.isEmpty) return tenants;

    return tenants.where((tenant) {
      final query = searchQuery.value.toLowerCase();
      return tenant.ten.toLowerCase().contains(query) ||
          tenant.soDienThoai.contains(query);
    }).toList();
  }

  String getRoomNumber(String tenantId) {
    for (var room in rooms.values) {
      if (room.nguoiThueHienTai.contains(tenantId)) {
        return room.soPhong;
      }
    }
    return 'N/A';
  }

  Future<void> removeTenant(UserModel tenant) async {
    try {
      // Tìm phòng của người thuê
      String? roomId;
      PhongModel? tenantRoom;

      for (var room in rooms.entries) {
        if (room.value.nguoiThueHienTai.contains(tenant.uid)) {
          roomId = room.key;
          tenantRoom = room.value;
          break;
        }
      }

      if (roomId == null || tenantRoom == null) return;

      // Xóa người thuê khỏi phòng
      await _firestore.collection('phong').doc(roomId).update({
        'nguoiThueHienTai': FieldValue.arrayRemove([tenant.uid]),
        'trangThai':
            tenantRoom.nguoiThueHienTai.length <= 1 ? 'trong' : 'daThue',
        'ngayCapNhat': FieldValue.serverTimestamp(),
      });

      // Thêm hoạt động
      await _firestore.collection('hoatDong').add({
        'chuTroId': landlordController.currentUser?.uid,
        'loai': 'traPhong',
        'nguoiThueId': tenant.uid,
        'phongId': roomId,
        'soPhong': tenantRoom.soPhong,
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

  void showTenantDetails(UserModel tenant) {
    final roomNumber = getRoomNumber(tenant.uid);
    Get.dialog(
      AlertDialog(
        title: Text('Thông tin người thuê - Phòng $roomNumber'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Họ tên', tenant.ten),
              _buildDetailRow('Số điện thoại', tenant.soDienThoai),
              _buildDetailRow('Email', tenant.email),
              if (tenant.diaChi.diaChiDayDu.isNotEmpty)
                _buildDetailRow('Địa chỉ', tenant.diaChi.diaChiDayDu),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
