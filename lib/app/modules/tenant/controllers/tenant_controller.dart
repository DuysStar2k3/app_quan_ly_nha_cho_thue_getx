import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/user_model.dart';

class TenantController extends GetxController {
  final AuthRepository _authRepository;

  TenantController(this._authRepository);

  final selectedIndex = 0.obs;
  final isLoading = false.obs;

  UserModel? get currentUser => _authRepository.currentUser.value;

  void changeTab(int index) {
    selectedIndex.value = index;
  }
} 