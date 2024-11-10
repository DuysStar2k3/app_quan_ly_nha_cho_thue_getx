import 'package:get/get.dart';
import '../controllers/landlord_controller.dart';
import '../controllers/rooms_controller.dart';
import '../controllers/services_controller.dart';
import '../../../data/repositories/auth_repository.dart';

class LandlordBinding extends Bindings {
  @override
  void dependencies() {
    // Đăng ký LandlordController
    Get.lazyPut(() => LandlordController(
          Get.find<AuthRepository>(),
        ));

    // Đăng ký RoomsController
    Get.lazyPut(() => RoomsController(Get.find<LandlordController>()));

    // Đăng ký ServicesController
    Get.lazyPut(() => ServicesController(Get.find<LandlordController>()));
  }
}
