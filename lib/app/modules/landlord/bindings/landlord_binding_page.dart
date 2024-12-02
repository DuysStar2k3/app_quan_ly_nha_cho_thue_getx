import 'package:get/get.dart';
import '../controllers/landlord_controller.dart';
import '../views/rooms_landlord_view/controller/rooms_landlord_controller.dart';
import '../views/services_landlord_view/controller/services_landlord_controller.dart';
import '../views/room_requests_landlord/controller/room_requests_landlord_controller.dart';
import '../views/tenant_landlord_view/controller/tenants_landlord_controller.dart';
import '../views/contract_landlord/controller/contract_landlord_controller.dart';
import '../../../data/repositories/auth_repository.dart';
import '../views/bill_landlord/controller/bill_landlord_controller.dart';
import '../views/statistics_landlord/controller/statistics_landlord_controller.dart';
import '../views/chat_landlord/controller/chat_landlord_controller.dart';

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
