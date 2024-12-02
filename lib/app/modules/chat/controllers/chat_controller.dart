import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/message_model.dart';
import '../../auth/controllers/auth_controller.dart';

/// Controller quản lý chức năng chat
class ChatController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  
  // Các biến observable
  final messages = <MessageModel>[].obs; // Danh sách tin nhắn
  final isLoading = true.obs; // Trạng thái loading
  
  // Thông tin người dùng và phòng chat
  late final UserModel otherUser; // Người dùng đang chat cùng
  late final String chatRoomId; // ID của phòng chat

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    chatRoomId = args['chatRoomId'];
    otherUser = args['otherUser'];
    
    // Khởi tạo phòng chat và load tin nhắn
    _initializeChatRoom();
  }

  /// Khởi tạo phòng chat nếu chưa tồn tại
  Future<void> _initializeChatRoom() async {
    try {
      final currentUser = Get.find<AuthController>().currentUser.value;
      if (currentUser == null) return;

      final chatRoomRef = _firestore.collection('chatRooms').doc(chatRoomId);
      final chatRoomDoc = await chatRoomRef.get();

      if (!chatRoomDoc.exists) {
        await chatRoomRef.set({
          'participants': [currentUser.uid, otherUser.uid],
          'lastMessage': '',
          'lastMessageTime': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Lỗi khởi tạo phòng chat: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Gửi tin nhắn mới
  Future<void> sendMessage(String content) async {
    try {
      if (content.trim().isEmpty) return;

      final currentUser = Get.find<AuthController>().currentUser.value;
      if (currentUser == null) return;

      final messageData = {
        'senderId': currentUser.uid,
        'content': content.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'chatRoomId': chatRoomId,
      };

      // Tạo tin nhắn mới
      await _firestore.collection('messages').add(messageData);

      // Cập nhật thông tin tin nhắn cuối cùng trong phòng chat
      await _firestore.collection('chatRooms').doc(chatRoomId).update({
        'lastMessage': content.trim(),
        'lastMessageTime': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Lỗi gửi tin nhắn: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể gửi tin nhắn',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    // Dọn dẹp tài nguyên nếu cần
    super.onClose();
  }
} 