import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../data/models/dich_vu_model.dart';
import '../../../controllers/landlord_controller.dart';

class ServicesLandlordController extends GetxController {
  final LandlordController landlordController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ServicesLandlordController(this.landlordController);

  final isLoading = false.obs;
  final services = <DichVuModel>[].obs;
  StreamSubscription? _servicesSubscription;

  @override
  void onInit() {
    super.onInit();
    _initServices();
  }

  @override
  void onClose() {
    _servicesSubscription?.cancel();
    super.onClose();
  }

  Future<void> _initServices() async {
    final user = landlordController.currentUser;
    if (user != null) {
      _servicesSubscription = _firestore
          .collection('dichVu')
          .where('chuTroId', isEqualTo: user.uid)
          .where('trangThaiHoatDong', isEqualTo: true)
          .orderBy('ngayCapNhat', descending: true)
          .snapshots()
          .listen(
        (snapshot) {
          services.value = snapshot.docs
              .map((doc) => DichVuModel.fromJson({
                    'id': doc.id,
                    ...doc.data(),
                  }))
              .toList();
        },
        onError: (error) => print('Error loading services: $error'),
      );
    }
  }

  Future<void> addService({
    required String tenDichVu,
    required String moTa,
    required double gia,
    required String donVi,
  }) async {
    try {
      final user = landlordController.currentUser;
      if (user == null) throw 'User not found';

      final service = DichVuModel(
        id: '',
        chuTroId: user.uid,
        tenDichVu: tenDichVu,
        trangThaiHoatDong: true,
        gia: gia,
        donVi: donVi,
        moTa: moTa,
        ngayTao: DateTime.now(),
        ngayCapNhat: DateTime.now(),
      );

      final docRef = _firestore.collection('dichVu').doc();
      final serviceWithId = service.copyWith(id: docRef.id);
      await docRef.set({
        ...serviceWithId.toJson(),
        'id': docRef.id,
      });

      // Thêm hoạt động
      await _firestore.collection('hoatDong').add({
        'chuTroId': user.uid,
        'loai': 'themDichVu',
        'tenDichVu': tenDichVu,
        'noiDung': 'Đã thêm dịch vụ mới',
        'ngayTao': FieldValue.serverTimestamp(),
      });

      Get.back();
      Get.snackbar(
        'Thành công',
        'Đã thêm dịch vụ mới',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể thêm dịch vụ: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }

  Future<void> updateService(DichVuModel service) async {
    try {
      await _firestore.collection('dichVu').doc(service.id).update({
        'tenDichVu': service.tenDichVu,
        'moTa': service.moTa,
        'gia': service.gia,
        'donVi': service.donVi,
        'ngayCapNhat': FieldValue.serverTimestamp(),
      });
      

      Get.back();
      Get.snackbar(
        'Thành công',
        'Đã cập nhật dịch vụ',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể cập nhật dịch vụ: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }

  Future<void> deleteService(String serviceId) async {
    try {
      // Lấy danh sách tất cả các phòng đang sử dụng dịch vụ này
      final roomsSnapshot = await _firestore.collection('phong').where('dichVu', arrayContains: serviceId).get();
      
      // Bắt đầu batch write
      final batch = _firestore.batch();
      
      // Cập nhật trạng thái dịch vụ
      batch.update(_firestore.collection('dichVu').doc(serviceId), {
        'trangThaiHoatDong': false,
      });
      
      // Xóa dịch vụ khỏi tất cả các phòng
      for (var doc in roomsSnapshot.docs) {
        final List<dynamic> currentServices = List.from(doc.data()['dichVu'] ?? []);
        currentServices.remove(serviceId);
        
        batch.update(doc.reference, {
          'dichVu': currentServices,
        });
      }
      
      // Thực hiện tất cả các thay đổi
      await batch.commit();
      
      Get.back();
      Get.snackbar(
        'Thành công',
        'Đã xóa dịch vụ và cập nhật các phòng liên quan',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể xóa dịch vụ: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }

  // Helper methods
  IconData getServiceIcon(String serviceName) {
  final name = serviceName.toLowerCase(); // Chuyển thành chữ thường để không phân biệt hoa/thường

  // Danh sách các từ khóa
  final options = [
    'điện', // Chữ có dấu
    'nước',
    'internet',
    'rác',
    'giữ xe',
    'dọn',
    'bảo vệ',
    'giặt',
  ];

  // Khởi tạo đối tượng Fuzzy để tìm kiếm gần đúng
  final fuzzy = Fuzzy(options);

  // Tìm kiếm tên dịch vụ gần đúng
  final result = fuzzy.search(name);

  if (result.isNotEmpty) {
    final bestMatch = result.first.item;

    // Dựa vào từ khóa gần đúng nhất, trả về biểu tượng tương ứng
    switch (bestMatch) {
      case 'điện':
        return Icons.electric_bolt;
      case 'nước':
        return Icons.water_drop;
      case 'internet':
        return Icons.wifi;
      case 'rác':
        return Icons.delete_outline;
      case 'giữ xe':
        return Icons.local_parking;
      case 'dọn':
        return Icons.cleaning_services;
      case 'bảo vệ':
        return Icons.security;
      case 'giặt':
        return Icons.local_laundry_service;
      default:
        return Icons.home_repair_service;
    }
  }

  // Nếu không tìm thấy kết quả phù hợp, trả về biểu tượng mặc định
  return Icons.home_repair_service;
}
}
