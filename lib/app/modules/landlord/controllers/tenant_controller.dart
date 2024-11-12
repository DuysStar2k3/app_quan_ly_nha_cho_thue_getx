// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../../data/models/phong_model.dart';
// import '../../../data/models/user_model.dart';

// class TenantController extends GetxController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final PhongModel room;

//   TenantController(this.room);

//   final isLoading = false.obs;
//   final tenants = <UserModel>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     _loadTenants();
//   }

//   Future<void> _loadTenants() async {
//     try {
//       isLoading.value = true;
//       final snapshot = await _firestore
//           .collection('nguoiDung')
//           .where('uid', whereIn: room.nguoiThueHienTai)
//           .get();

//       tenants.value = snapshot.docs
//           .map((doc) => UserModel.fromJson({
//                 'uid': doc.id,
//                 ...doc.data(),
//               }))
//           .toList();
//     } catch (e) {
//       print('Error loading tenants: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> addTenant({
//     required String ten,
//     required String email,
//     required String soDienThoai,
//     required Map<String, String> diaChi,
//   }) async {
//     try {
//       isLoading.value = true;

//       // Tạo tài khoản người thuê mới
//       final userDoc = await _firestore.collection('nguoiDung').add({
//         'ten': ten,
//         'email': email,
//         'soDienThoai': soDienThoai,
//         'diaChi': diaChi,
//         'vaiTro': 'nguoiThue',
//         'ngayTao': FieldValue.serverTimestamp(),
//         'ngayCapNhat': FieldValue.serverTimestamp(),
//       });

//       // Cập nhật danh sách người thuê của phòng
//       await _firestore.collection('phong').doc(room.id).update({
//         'nguoiThueHienTai': FieldValue.arrayUnion([userDoc.id]),
//         'trangThai': 'daThue',
//         'ngayCapNhat': FieldValue.serverTimestamp(),
//       });

//       // Thêm hoạt động
//       await _firestore.collection('hoatDong').add({
//         'chuTroId': room.chuTroId,
//         'loai': 'nguoiThue',
//         'soPhong': room.soPhong,
//         'tenNguoiThue': ten,
//         'ngayTao': FieldValue.serverTimestamp(),
//       });

//       Get.back();
//       Get.snackbar(
//         'Thành công',
//         'Đã thêm người thuê mới',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Lỗi',
//         'Không thể thêm người thuê: $e',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> removeTenant(String tenantId) async {
//     try {
//       isLoading.value = true;

//       // Xóa người thuê khỏi phòng
//       await _firestore.collection('phong').doc(room.id).update({
//         'nguoiThueHienTai': FieldValue.arrayRemove([tenantId]),
//         'trangThai': room.nguoiThueHienTai.length <= 1 ? 'trong' : 'daThue',
//         'ngayCapNhat': FieldValue.serverTimestamp(),
//       });

//       // Thêm hoạt động
//       await _firestore.collection('hoatDong').add({
//         'chuTroId': room.chuTroId,
//         'loai': 'traPhong',
//         'soPhong': room.soPhong,
//         'ngayTao': FieldValue.serverTimestamp(),
//       });

//       Get.back();
//       Get.snackbar(
//         'Thành công',
//         'Đã xóa người thuê',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Lỗi',
//         'Không thể xóa người thuê: $e',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
// } 