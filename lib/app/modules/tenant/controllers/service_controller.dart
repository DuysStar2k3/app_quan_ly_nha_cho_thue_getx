import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/dich_vu_model.dart';
import '../../../data/models/phong_model.dart';
import '../../../data/repositories/auth_repository.dart';

class ServiceController extends GetxController {
  final AuthRepository _authRepository;
  final _firestore = FirebaseFirestore.instance;

  ServiceController(this._authRepository);

  final isLoading = true.obs;
  final currentRoom = Rxn<PhongModel>();
  final services = <DichVuModel>[].obs;
  final amenities = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      final user = _authRepository.currentUser.value;
      if (user == null) return;

      // Lấy phòng hiện tại của người thuê
      final roomSnapshot = await _firestore
          .collection('phong')
          .where('nguoiThueHienTai', arrayContains: user.uid)
          .get();

      if (roomSnapshot.docs.isNotEmpty) {
        currentRoom.value = PhongModel.fromJson({
          'id': roomSnapshot.docs.first.id,
          ...roomSnapshot.docs.first.data(),
        });

        // Lấy danh sách dịch vụ của phòng
        if (currentRoom.value!.dichVu.isNotEmpty) {
          final servicesSnapshot = await _firestore
              .collection('dichVu')
              .where(FieldPath.documentId, whereIn: currentRoom.value!.dichVu)
              .get();

          services.value = servicesSnapshot.docs
              .map((doc) => DichVuModel.fromJson({
                    'id': doc.id,
                    ...doc.data(),
                  }))
              .toList();
        } else {
          services.clear();
        }

        // Lấy tiện ích của phòng
        amenities.value = List<String>.from(currentRoom.value!.tienNghi);
      }
    } catch (e) {
      print('Error loading services: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> requestService(String serviceType, String description) async {
    try {
      final user = _authRepository.currentUser.value;
      if (user == null || currentRoom.value == null) return;

      // Tạo yêu cầu dịch vụ mới
      await _firestore.collection('yeuCauDichVu').add({
        'nguoiThueId': user.uid,
        'phongId': currentRoom.value!.id,
        'loaiDichVu': serviceType,
        'moTa': description,
        'trangThai': 'choXacNhan',
        'ngayTao': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Thành công',
        'Đã gửi yêu cầu dịch vụ',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể gửi yêu cầu: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> refreshData() => loadData();

  // Helper methods
  String getServiceStatus(String status) {
    switch (status) {
      case 'choXacNhan':
        return 'Đang chờ xác nhận';
      case 'daChapNhan':
        return 'Đã chấp nhận';
      case 'dangXuLy':
        return 'Đang xử lý';
      case 'daHoanThanh':
        return 'Đã hoàn thành';
      case 'daHuy':
        return 'Đã hủy';
      default:
        return 'Không xác định';
    }
  }

  String getServiceIcon(String type) {
    switch (type) {
      case 'suaChua':
        return 'repair';
      case 'veSinh':
        return 'cleaning';
      case 'baoTri':
        return 'maintenance';
      default:
        return 'other';
    }
  }
} 