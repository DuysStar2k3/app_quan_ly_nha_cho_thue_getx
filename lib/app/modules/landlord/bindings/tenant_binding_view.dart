import 'package:get/get.dart';
import '../controllers/tenant_controller.dart';
import '../../../data/models/phong_model.dart';

class TenantBindingView extends Bindings {
  final PhongModel room;

  TenantBindingView(this.room);

  @override
  void dependencies() {
    Get.lazyPut(() => TenantController(room));
  }
} 