import 'package:get/get.dart';
import '../controllers/services_controller.dart';
import '../controllers/landlord_controller.dart';

class ServicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ServicesController(Get.find<LandlordController>()));
  }
} 