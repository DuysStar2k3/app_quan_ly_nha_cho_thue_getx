import 'package:get/get.dart';
import '../controllers/tenant_page_controller.dart';
import '../views/chat_tenant/controller/chat_tenant_controller.dart';
import '../views/home_tenant_view/controller/home_tenant_controller.dart';
import '../views/bill_tenant/controller/bill_tenant_controller.dart';
import '../views/services_tenant_view/controller/service_tenant_controller.dart';
import '../views/requests_tenant/controller/tenant_requests_controller.dart';
import '../../../data/repositories/auth_repository.dart';

class TenantBindingPage extends Bindings {
  @override
  void dependencies() {
    // Controller chính - permanent
    if (!Get.isRegistered<TenantPageController>()) {
      Get.put<TenantPageController>(
          TenantPageController(Get.find<AuthRepository>()),
          permanent: true);
    }

    // Các controller con - được tạo lại khi cần
    Get.lazyPut<HomeTenantController>(
        () => HomeTenantController(Get.find<TenantPageController>()),
        fenix: true);

    Get.lazyPut<BillTenantController>(
        () => BillTenantController(Get.find<TenantPageController>()),
        fenix: true);

    Get.lazyPut<ServiceTenantController>(
        () => ServiceTenantController(Get.find<TenantPageController>()),
        fenix: true);

    Get.lazyPut<TenantRequestsController>(
        () => TenantRequestsController(Get.find<TenantPageController>()),
        fenix: true);
    Get.lazyPut<ChatTenantController>(() => ChatTenantController(),
        fenix: true // Cho phép tái sử dụng controller khi quay lại
        );
  }
}
