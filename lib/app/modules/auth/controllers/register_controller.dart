import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final AuthRepository _authRepository;
  RegisterController(this._authRepository);

  final isLoading = false.obs;
  final selectedRole = 'nguoiThue'.obs;

  void setRole(String role) {
    selectedRole.value = role;
  }

  Future<void> register({
    required String email,
    required String password,
    required String ten,
    required String soDienThoai,
  }) async {
    try {
      isLoading.value = true;
      final user = await _authRepository.signUp(
        email: email,
        password: password,
        ten: ten,
        soDienThoai: soDienThoai,
        vaiTro: selectedRole.value,
      );

      // Kiểm tra vai trò và chuyển hướng
      if (user.vaiTro == 'chuTro') {
        Get.offAllNamed(Routes.LANDLORD);
      } else {
        Get.offAllNamed(Routes.TENANT);
      }
      
      Get.snackbar(
        'Thành Công',
        'Đăng ký tài khoản thành công',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi Đăng Ký',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }
} 