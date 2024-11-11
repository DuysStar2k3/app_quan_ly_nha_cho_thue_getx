import 'package:get/get.dart';
import '../controllers/tenant_page_controller.dart';
import '../controllers/home_tenant_controller.dart';
import '../controllers/room_search_tenant_controller.dart';
import '../controllers/room_details_tenant_controller.dart';
import '../controllers/tenant_requests_controller.dart';
import '../../../data/repositories/auth_repository.dart';
import '../controllers/service_tenant_controller.dart';
import '../controllers/payment_tenant_controller.dart';
import '../controllers/bill_tenant_controller.dart';

class TenantBindingPage extends Bindings {
  @override
  void dependencies() {
    // Đăng ký TenantPageController
    Get.lazyPut(() => TenantPageController(Get.find<AuthRepository>()));

    // Đăng ký HomeTenantController
    Get.lazyPut(() => HomeTenantController(Get.find<TenantPageController>()));

    // Đăng ký RoomSearchTenantController
    Get.lazyPut(
        () => RoomSearchTenantController(Get.find<TenantPageController>()));

    // Đăng ký RoomDetailsTenantController
    Get.lazyPut(() => RoomDetailsTenantController());

    // Đăng ký TenantRequestsController
    Get.lazyPut(
        () => TenantRequestsController(Get.find<TenantPageController>()));

    // Đăng ký ServiceTenantController
    Get.lazyPut(
        () => ServiceTenantController(Get.find<TenantPageController>()));

    // Đăng ký PaymentTenantController
    Get.lazyPut(
        () => PaymentTenantController(Get.find<TenantPageController>()));

    // Đăng ký BillTenantController
    Get.lazyPut(() => BillTenantController(Get.find<TenantPageController>()));
  }
}
