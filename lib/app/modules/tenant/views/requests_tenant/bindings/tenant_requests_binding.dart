import 'package:get/get.dart';
import '../controller/tenant_requests_controller.dart';
import '../../../controllers/tenant_page_controller.dart';
import '../../../bindings/tenant_binding_page.dart';

class TenantRequestsBinding extends Bindings {
  @override
  void dependencies() {
    // Đảm bảo TenantPageController đã được khởi tạo
    TenantBindingPage().dependencies();
    
    // Khởi tạo TenantRequestsController
    Get.lazyPut<TenantRequestsController>(
      () => TenantRequestsController(Get.find<TenantPageController>()),
      fenix: true // Cho phép tái sử dụng controller khi quay lại trang
    );
  }
} 