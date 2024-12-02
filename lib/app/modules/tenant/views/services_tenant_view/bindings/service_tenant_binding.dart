import 'package:get/get.dart';
import '../controller/service_tenant_controller.dart';
import '../../../controllers/tenant_page_controller.dart';

class ServiceTenantBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<ServiceTenantController>(
        () => ServiceTenantController(Get.find<TenantPageController>()));
  }
}
