import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  final AuthRepository _authRepository;

  SplashController(this._authRepository);

  @override
  void onInit() {
    super.onInit();
    _initSplash();
  }

  Future<void> _initSplash() async {
    try {
      // Tạm dừng auto redirect từ auth repository
      _authRepository.pauseAutoRedirect();
      
      // Đảm bảo màn splash hiển thị đủ 2 giây
      await Future.delayed(const Duration(seconds: 2));
      
      // Kiểm tra trạng thái đăng nhập
      final user = _authRepository.currentUser.value;
      if (user != null) {
        Get.offAllNamed(
          user.vaiTro == 'chuTro' ? Routes.LANDLORD_PAGE : Routes.TENANT_PAGE,
        );
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }

      // Bật lại auto redirect
      _authRepository.resumeAutoRedirect();
      
    } catch (e) {
      print('Error in splash: $e');
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
