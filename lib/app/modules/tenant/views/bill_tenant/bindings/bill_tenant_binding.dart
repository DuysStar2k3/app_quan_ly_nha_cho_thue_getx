import 'package:get/get.dart';
import '../controller/bill_tenant_controller.dart';
import '../../../controllers/tenant_page_controller.dart';
import '../../../bindings/tenant_binding_page.dart';

class BillTenantBinding extends Bindings {
  @override
  void dependencies() {
    TenantBindingPage().dependencies();
    Get.lazyPut<BillTenantController>(
        () => BillTenantController(Get.find<TenantPageController>()),
        fenix: true);
  }
}
