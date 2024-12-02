import 'package:get/get.dart';
import '../views/settings_landlord_view/controller/edit_profile_controller.dart';
import '../../../data/repositories/auth_repository.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditProfileController(Get.find<AuthRepository>()));
  }
} 