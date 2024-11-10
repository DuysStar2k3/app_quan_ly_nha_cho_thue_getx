import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';
import '../../../data/repositories/auth_repository.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditProfileController(Get.find<AuthRepository>()));
  }
} 