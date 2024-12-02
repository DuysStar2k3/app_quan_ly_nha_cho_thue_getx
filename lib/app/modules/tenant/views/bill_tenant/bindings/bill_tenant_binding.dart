import 'package:get/get.dart';
import '../controller/bill_tenant_controller.dart';
import '../../../controllers/tenant_page_controller.dart';

class BillTenantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BillTenantController>(
        () => BillTenantController(Get.find<TenantPageController>()));
  }
}
