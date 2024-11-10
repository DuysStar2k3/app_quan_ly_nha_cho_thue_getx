import 'package:get/get.dart';
import '../controllers/room_tenant_controller.dart';
import '../../../data/models/phong_model.dart';

class RoomTenantBinding extends Bindings {
  final PhongModel room;

  RoomTenantBinding(this.room);

  @override
  void dependencies() {
    Get.lazyPut(() => RoomTenantController(room));
  }
} 