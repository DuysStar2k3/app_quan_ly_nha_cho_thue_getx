import 'package:get/get.dart';
import '../controllers/landlord_controller.dart';
import '../controllers/rooms_controller.dart';
import '../controllers/services_controller.dart';
import '../controllers/room_requests_controller.dart';
import '../controllers/tenants_controller.dart';
import '../../../data/repositories/auth_repository.dart';

class LandlordBindingPage extends Bindings {
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

    // Đăng ký RoomRequestsController
    Get.lazyPut(() => RoomRequestsController(Get.find<LandlordController>()));

    // Đăng ký TenantsController
    Get.lazyPut(() => TenantsController(Get.find<LandlordController>()));
  }
}
