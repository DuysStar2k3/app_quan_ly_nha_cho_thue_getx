import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/user_model.dart';

class EditProfileController extends GetxController {
  final AuthRepository _authRepository;

  EditProfileController(this._authRepository);

  final isLoading = false.obs;

  UserModel? get currentUser => _authRepository.currentUser.value;

  Future<void> updateProfile({
    required String ten,
    required String soDienThoai,
    required Map<String, String> diaChi,
    String? cmnd,
    Map<String, String>? taiKhoanNganHang,
  }) async {
    try {
      isLoading.value = true;
      final user = currentUser;
      if (user == null) throw 'User not found';

      await _authRepository.updateUserProfile(
        uid: user.uid,
        ten: ten,
        soDienThoai: soDienThoai,
        diaChi: diaChi,
        cmnd: cmnd,
        taiKhoanNganHang: taiKhoanNganHang,
      );

      Get.back(); // Quay lại trang settings
      Get.snackbar(
        'Thành công',
        'Đã cập nhật thông tin',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        duration: const Duration(seconds: 3),
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
