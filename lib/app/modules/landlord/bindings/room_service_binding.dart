import 'package:get/get.dart';
import '../controllers/room_service_controller.dart';
import '../../../data/models/phong_model.dart';

class RoomServiceBinding extends Bindings {
  final PhongModel room;

  RoomServiceBinding(this.room);

  @override
  void dependencies() {
    Get.lazyPut(() => RoomServiceController(room));
  }
} 