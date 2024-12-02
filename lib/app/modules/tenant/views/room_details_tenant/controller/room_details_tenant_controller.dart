import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../data/models/user_model.dart';
import '../../../../../data/models/dich_vu_model.dart';
import '../../../../../data/models/phong_model.dart';
import '../../../../../routes/app_pages.dart';
import '../../../../auth/controllers/auth_controller.dart';

class RoomDetailsTenantController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final isLoading = true.obs;
  final services = <DichVuModel>[].obs;
  final landlordInfo = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    final room = Get.arguments as PhongModel;
    loadServices(room);
    loadLandlordInfo(room.chuTroId);
  }

  Future<void> loadServices(PhongModel room) async {
    try {
      isLoading.value = true;
      services.clear();

      for (String serviceId in room.dichVu) {
        final doc = await _firestore.collection('dichVu').doc(serviceId).get();
        if (doc.exists) {
          services.add(DichVuModel.fromJson({
            'id': doc.id,
            ...doc.data()!,
          }));
        }
      }
    } catch (e) {
      print('Error loading services: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadLandlordInfo(String landlordId) async {
    try {
      final doc = await _firestore.collection('nguoiDung').doc(landlordId).get();
      if (doc.exists) {
        landlordInfo.value = UserModel.fromJson({
          'uid': doc.id,
          ...doc.data()!,
        });
      }
    } catch (e) {
      print('Error loading landlord info: $e');
    }
  }

  Future<void> callLandlord() async {
    if (landlordInfo.value?.soDienThoai == null) return;
    
    final url = 'tel:${landlordInfo.value!.soDienThoai}';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Future<void> messageLandlord() async {
    if (landlordInfo.value?.soDienThoai == null) return;
    
    final url = 'sms:${landlordInfo.value!.soDienThoai}';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Future<void> openChat() async {
    try {
      if (landlordInfo.value == null) return;

      final currentUser = Get.find<AuthController>().currentUser.value;
      if (currentUser == null) return;

      // Tạo chatRoomId từ ID của 2 người dùng
      final users = [currentUser.uid, landlordInfo.value!.uid];
      users.sort(); // Sắp xếp để đảm bảo thứ tự nhất quán
      final chatRoomId = users.join('_');

      // Chuyển đến màn hình chat với đầy đủ tham số
      await Get.toNamed(
        Routes.CHAT_ROOM,
        arguments: {
          'chatRoomId': chatRoomId,
          'otherUser': landlordInfo.value,
        },
      );
    } catch (e) {
      print('Lỗi mở chat: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể mở chat. Vui lòng thử lại sau.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
} 