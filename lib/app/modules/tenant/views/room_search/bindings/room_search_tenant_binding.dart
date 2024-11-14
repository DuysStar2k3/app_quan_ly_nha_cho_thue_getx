import 'package:get/get.dart';
import '../controller/room_search_tenant_controller.dart';
import '../../../controllers/tenant_page_controller.dart';
import '../../../bindings/tenant_binding_page.dart';

class RoomSearchTenantBinding extends Bindings {
  @override
  void dependencies() {
    TenantBindingPage().dependencies();
    Get.lazyPut<RoomSearchTenantController>(
      () => RoomSearchTenantController(Get.find<TenantPageController>()),
      fenix: true
    );
  }
} 