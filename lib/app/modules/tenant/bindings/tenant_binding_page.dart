import 'package:get/get.dart';
import '../controllers/tenant_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/room_search_controller.dart';
import '../controllers/room_details_controller.dart';
import '../../../data/repositories/auth_repository.dart';

class TenantBindingPage extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TenantController(Get.find<AuthRepository>()));
    Get.lazyPut(() => HomeController(Get.find<AuthRepository>()));
    Get.lazyPut(() => RoomSearchController(Get.find<AuthRepository>()));
    Get.lazyPut(() => RoomDetailsController());
  }
} 