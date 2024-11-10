import 'package:get/get.dart';
import '../controllers/tenant_controller.dart';
import '../../../data/repositories/auth_repository.dart';

class TenantBindingPage extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TenantController(Get.find<AuthRepository>()));
  }
} 