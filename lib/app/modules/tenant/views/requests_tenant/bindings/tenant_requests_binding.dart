import 'package:get/get.dart';
import '../controller/tenant_requests_controller.dart';
import '../../../controllers/tenant_page_controller.dart';

class TenantRequestsBinding extends Bindings {
  @override
  void dependencies() {
    // Khởi tạo TenantRequestsController
    Get.lazyPut<TenantRequestsController>(
        () => TenantRequestsController(Get.find<TenantPageController>()));
  }
}
