import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/user_model.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;
  AuthController(this._authRepository);

  Rx<UserModel?> get currentUser => _authRepository.currentUser;

  Future<void> signOut() async {
    await _authRepository.signOut();
  }
} 