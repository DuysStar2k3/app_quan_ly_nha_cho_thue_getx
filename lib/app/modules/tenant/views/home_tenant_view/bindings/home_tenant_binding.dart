import 'package:get/get.dart';
import '../controller/home_tenant_controller.dart';
import '../../../controllers/tenant_page_controller.dart';
import '../../../bindings/tenant_binding_page.dart';

class HomeTenantBinding extends Bindings {
  @override
  void dependencies() {
    TenantBindingPage().dependencies();
    Get.lazyPut<HomeTenantController>(
      () => HomeTenantController(Get.find<TenantPageController>()),
      fenix: true
    );
  }
} 