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

  // Thêm phương thức để mở chat
  void openChat() async {
    try {
      final landlord = landlordInfo.value;
      if (landlord == null) return;

      // Tạo hoặc lấy ID cuộc trò chuyện
      final chatId = await _createOrGetChatId(landlord.uid);
      
      // Chuyển đến trang chat
      Get.toNamed(
        Routes.CHAT_ROOM,
        arguments: {
          'chatId': chatId,
          'otherUser': landlord,
        },
      );
    } catch (e) {
      print('Error opening chat: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể mở cuộc trò chuyện',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<String> _createOrGetChatId(String landlordId) async {
    // Lấy ID người dùng hiện tại
    final currentUserId = Get.find<AuthController>().currentUser.value?.uid;
    if (currentUserId == null) throw 'Chưa đăng nhập';

    // Sắp xếp ID để tạo chatId nhất quán
    final sortedIds = [currentUserId, landlordId]..sort();
    final chatId = sortedIds.join('_');

    // Kiểm tra xem cuộc trò chuyện đã tồn tại chưa
    final chatDoc = await _firestore.collection('chats').doc(chatId).get();

    if (!chatDoc.exists) {
      // Tạo cuộc trò chuyện mới
      await _firestore.collection('chats').doc(chatId).set({
        'participants': [currentUserId, landlordId],
        'lastMessage': null,
        'lastMessageTime': null,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return chatId;
  }
} 