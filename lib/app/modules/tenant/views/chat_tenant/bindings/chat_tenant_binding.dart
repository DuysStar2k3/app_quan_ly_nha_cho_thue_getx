import 'package:get/get.dart';
import '../controller/chat_tenant_controller.dart';

class ChatTenantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatTenantController>(
      () => ChatTenantController(),
    );
  }
}
