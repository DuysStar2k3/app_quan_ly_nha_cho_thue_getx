import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/phong_model.dart';
import '../../../data/models/dich_vu_model.dart';

class RoomServiceController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final PhongModel room;

  RoomServiceController(this.room);

  final isLoading = false.obs;
  final selectedServices = <String>[].obs;
  final services = <DichVuModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadServices();
    selectedServices.value = room.dichVu;
  }

  Future<void> _loadServices() async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore
          .collection('dichVu')
          .where('chuTroId', isEqualTo: room.chuTroId)
          .get();

      services.value = snapshot.docs
          .map((doc) => DichVuModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      print('Error loading services: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateRoomServices() async {
    try {
      isLoading.value = true;

      await _firestore.collection('phong').doc(room.id).update({
        'dichVu': selectedServices,
        'ngayCapNhat': FieldValue.serverTimestamp(),
      });

      await _firestore.collection('hoatDong').add({
        'chuTroId': room.chuTroId,
        'loai': 'capNhatDichVu',
        'soPhong': room.soPhong,
        'noiDung': 'Đã cập nhật dịch vụ',
        'ngayTao': FieldValue.serverTimestamp(),
      });

      Get.back();
      Get.snackbar(
        'Thành công',
        'Đã cập nhật dịch vụ cho phòng',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể cập nhật dịch vụ: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleService(String serviceId) {
    if (selectedServices.contains(serviceId)) {
      selectedServices.remove(serviceId);
    } else {
      selectedServices.add(serviceId);
    }
  }

  String getServiceName(String serviceId) {
    final service = services.firstWhereOrNull((s) => s.id == serviceId);
    return service?.tenDichVu ?? 'Không xác định';
  }

  double getServicePrice(String serviceId) {
    final service = services.firstWhereOrNull((s) => s.id == serviceId);
    return service?.gia ?? 0;
  }

  String getServiceUnit(String serviceId) {
    final service = services.firstWhereOrNull((s) => s.id == serviceId);
    return service?.donVi ?? '';
  }
} 