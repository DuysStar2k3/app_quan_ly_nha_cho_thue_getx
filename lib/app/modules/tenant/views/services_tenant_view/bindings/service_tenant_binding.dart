import 'package:get/get.dart';
import '../controller/service_tenant_controller.dart';
import '../../../controllers/tenant_page_controller.dart';
import '../../../bindings/tenant_binding_page.dart';

class ServiceTenantBinding extends Bindings {
  @override
  void dependencies() {
    // Đảm bảo TenantPageController đã được khởi tạo
    TenantBindingPage().dependencies();
    
    Get.lazyPut<ServiceTenantController>(
      () => ServiceTenantController(Get.find<TenantPageController>()),
      fenix: true
    );
  }
} 