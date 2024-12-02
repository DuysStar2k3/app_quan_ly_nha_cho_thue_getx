import 'package:get/get.dart';
import '../controller/contract_controller.dart';

class ContractBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContractController>(
      () => ContractController(),
    );
  }
}
