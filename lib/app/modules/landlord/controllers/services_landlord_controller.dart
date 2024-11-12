import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/dich_vu_model.dart';
import './landlord_controller.dart';

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
      await _firestore.collection('dichVu').doc(serviceId).delete();
      Get.back();
      Get.snackbar(
        'Thành công',
        'Đã xóa dịch vụ',
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
    final name = serviceName.toLowerCase();
    if (name.contains('điện')) return Icons.electric_bolt;
    if (name.contains('nước')) return Icons.water_drop;
    if (name.contains('internet')) return Icons.wifi;
    if (name.contains('rác')) return Icons.delete_outline;
    if (name.contains('giữ xe')) return Icons.local_parking;
    if (name.contains('dọn')) return Icons.cleaning_services;
    if (name.contains('bảo vệ')) return Icons.security;
    if (name.contains('giặt')) return Icons.local_laundry_service;
    return Icons.home_repair_service;
  }
} 