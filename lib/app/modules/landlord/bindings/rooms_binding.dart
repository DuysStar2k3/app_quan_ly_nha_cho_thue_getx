import 'package:get/get.dart';
import '../controllers/rooms_controller.dart';
import '../controllers/landlord_controller.dart';

class RoomsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RoomsController(Get.find<LandlordController>()));
  }
} 