import 'package:get/get.dart';
import '../../../../chat/controllers/chat_controller.dart';
import '../controller/chat_tenant_controller.dart';

class ChatTenantBinding extends Bindings {
  @override
  void dependencies() {
    // Đăng ký ChatController
    Get.lazyPut<ChatController>(() => ChatController());

    // Đăng ký ChatTenantController
    Get.lazyPut<ChatTenantController>(
      () => ChatTenantController(),
    );
  }
}
