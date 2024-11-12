import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository;
  LoginController(this._authRepository);

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      final user = await _authRepository.signIn(email, password);
      
      // Kiểm tra vai trò và chuyển hướng
      if (user.vaiTro == 'chuTro') {
        Get.offAllNamed(Routes.LANDLORD_PAGE);
      } else {
        Get.offAllNamed(Routes.TENANT_PAGE);
      }
    } catch (e) {
      Get.snackbar(
        'Lỗi Đăng Nhập',
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

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
} 