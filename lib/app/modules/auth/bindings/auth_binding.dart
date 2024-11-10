import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/login_controller.dart';
import '../controllers/register_controller.dart';
import '../../../data/repositories/auth_repository.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthRepository());
    Get.lazyPut(() => AuthController(Get.find<AuthRepository>()));
    Get.lazyPut(() => LoginController(Get.find<AuthRepository>()));
    Get.lazyPut(() => RegisterController(Get.find<AuthRepository>()));
  }
}
