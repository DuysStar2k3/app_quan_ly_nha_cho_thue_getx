import 'package:get/get.dart';
import '../controllers/landlord_controller.dart';
import '../controllers/rooms_landlord_controller.dart';
import '../controllers/services_landlord_controller.dart';
import '../controllers/room_requests_landlord_controller.dart';
import '../controllers/tenants_landlord_controller.dart';
import '../controllers/contract_landlord_controller.dart';
import '../../../data/repositories/auth_repository.dart';
import '../controllers/bill_landlord_controller.dart';
import '../controllers/statistics_landlord_controller.dart';
import '../controllers/chat_landlord_controller.dart';

class LandlordBindingPage extends Bindings {
  @override
  void dependencies() {
    // Đăng ký LandlordController
    Get.lazyPut(() => LandlordController(Get.find<AuthRepository>()));

    // Đăng ký RoomsController
    Get.lazyPut(() => RoomsLandlordController(Get.find<LandlordController>()));

    // Đăng ký ServicesController
    Get.lazyPut(
        () => ServicesLandlordController(Get.find<LandlordController>()));

    // Đăng ký RoomRequestsController
    Get.lazyPut(
        () => RoomRequestsLandlordController(Get.find<LandlordController>()));

    // Đăng ký TenantsController
    Get.lazyPut(
        () => TenantsLandlordController(Get.find<LandlordController>()));

    // Đăng ký ContractController
    Get.lazyPut(
        () => ContractLandlordController(Get.find<LandlordController>()));

    // Thêm vào dependencies
    Get.lazyPut(() => BillLandlordController(Get.find<LandlordController>()));

    // Thêm StatisticsController
    Get.lazyPut(() => StatisticsLandlordController(Get.find<LandlordController>()));

    // Thêm vào dependencies
    Get.lazyPut<ChatLandlordController>(
      () => ChatLandlordController(),
    );
  }
}
