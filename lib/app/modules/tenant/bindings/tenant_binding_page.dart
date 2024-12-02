import 'package:get/get.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/chat_tenant/controller/chat_tenant_controller.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/home_tenant_view/controller/home_tenant_controller.dart';
import '../controllers/tenant_page_controller.dart';
import '../views/payment_tenant_view/controller/payment_tenant_controller.dart';
import '../views/room_details_tenant/controller/room_details_tenant_controller.dart';
import '../../../data/repositories/auth_repository.dart';

class TenantBindingPage extends Bindings {
  @override
  void dependencies() {
    // Controller chính - permanent
    Get.lazyPut(() => TenantPageController(Get.find<AuthRepository>()));
    // Controller thanh toán
    Get.lazyPut(
        () => PaymentTenantController(Get.find<TenantPageController>()));
    // Controller chi tiết phòng
    Get.lazyPut(() => RoomDetailsTenantController());
    // Controller home
    Get.lazyPut(() => HomeTenantController(Get.find<TenantPageController>()));

    // Controller tin nhắn
    Get.lazyPut(() => ChatTenantController());
  }
}
