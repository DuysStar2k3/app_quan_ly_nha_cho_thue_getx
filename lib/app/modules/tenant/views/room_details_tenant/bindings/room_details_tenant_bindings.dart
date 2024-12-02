import 'package:get/get.dart';
import '../controller/room_details_tenant_controller.dart';

class RoomDetailsTenantBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(() => RoomDetailsTenantController());
  }
}
