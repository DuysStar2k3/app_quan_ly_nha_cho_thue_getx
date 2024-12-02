import 'package:get/get.dart';
import '../controller/home_tenant_controller.dart';
import '../../../controllers/tenant_page_controller.dart';

class HomeTenantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeTenantController>(
      () => HomeTenantController(Get.find<TenantPageController>()),
    );
  }
}
