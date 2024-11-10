import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../../routes/app_pages.dart';
import '../../core/theme/app_colors.dart';

class AuthRepository extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  bool _pauseRedirect = false;

  @override
  void onInit() {
    super.onInit();
    _initAuthListener();
  }

  void _initAuthListener() {
    _auth.authStateChanges().listen((User? firebaseUser) async {
      if (firebaseUser != null) {
        try {
          final doc = await _firestore
              .collection('nguoiDung')
              .doc(firebaseUser.uid)
              .get();
              
          if (doc.exists) {
            currentUser.value = UserModel.fromJson({
              'uid': firebaseUser.uid,
              ...doc.data()!
            });
            
            if (!_pauseRedirect) {
              if (currentUser.value!.vaiTro == 'chuTro') {
                Get.offAllNamed(Routes.LANDLORD);
              } else if (currentUser.value!.vaiTro == 'nguoiThue') {
                Get.offAllNamed(Routes.TENANT);
              } else {
                await signOut();
                Get.snackbar(
                  'Lỗi Đăng Nhập',
                  'Tài khoản này không có quyền truy cập',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.error.withOpacity(0.1),
                  colorText: AppColors.error,
                  duration: const Duration(seconds: 3),
                );
                Get.offAllNamed(Routes.LOGIN);
              }
            }
          }
        } catch (e) {
          print('Error getting user data: $e');
          currentUser.value = null;
          if (!_pauseRedirect) {
            Get.offAllNamed(Routes.LOGIN);
          }
        }
      } else {
        currentUser.value = null;
        if (!_pauseRedirect) {
          Get.offAllNamed(Routes.LOGIN);
        }
      }
    });
  }

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String ten,
    required String soDienThoai,
    required String vaiTro,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = UserModel(
        uid: userCredential.user!.uid,
        ten: ten,
        email: email,
        soDienThoai: soDienThoai,
        vaiTro: vaiTro,
        diaChi: DiaChi(
          soNha: '',
          phuong: '',
          quan: '',
          thanhPho: '',
        ),
        ngayTao: DateTime.now(),
        ngayCapNhat: DateTime.now(),
      );

      await _firestore
          .collection('nguoiDung')
          .doc(user.uid)
          .set(user.toJson());

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserModel> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final doc = await _firestore
          .collection('nguoiDung')
          .doc(userCredential.user!.uid)
          .get();
          
      if (!doc.exists) {
        throw 'Không tìm thấy thông tin người dùng';
      }
      
      return UserModel.fromJson({
        'uid': userCredential.user!.uid,
        ...doc.data()!
      });
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  void pauseAutoRedirect() {
    _pauseRedirect = true;
  }

  void resumeAutoRedirect() {
    _pauseRedirect = false;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    currentUser.value = null;
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Không tìm thấy tài khoản';
      case 'wrong-password':
        return 'Sai mật khẩu';
      case 'invalid-email':
        return 'Email không hợp lệ';
      case 'user-disabled':
        return 'Tài khoản đã bị khóa';
      case 'email-already-in-use':
        return 'Email này đã được sử dụng';
      case 'weak-password':
        return 'Mật khẩu phải có ít nhất 6 ký tự';
      default:
        return e.message ?? 'Đã có lỗi xảy ra';
    }
  }

  Future<void> updateUserProfile({
    required String uid,
    required String ten,
    required String soDienThoai,
    required Map<String, String> diaChi,
  }) async {
    try {
      await _firestore.collection('nguoiDung').doc(uid).update({
        'ten': ten,
        'soDienThoai': soDienThoai,
        'diaChi': diaChi,
        'ngayCapNhat': FieldValue.serverTimestamp(),
      });

      // Cập nhật lại currentUser
      final doc = await _firestore.collection('nguoiDung').doc(uid).get();
      if (doc.exists) {
        currentUser.value = UserModel.fromJson({
          'uid': uid,
          ...doc.data()!,
        });
      }
    } catch (e) {
      throw 'Không thể cập nhật thông tin: $e';
    }
  }
}
