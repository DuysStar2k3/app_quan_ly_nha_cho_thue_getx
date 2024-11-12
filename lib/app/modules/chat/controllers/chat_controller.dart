import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/message_model.dart';
import '../../auth/controllers/auth_controller.dart';

class ChatController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final messages = <MessageModel>[].obs;
  final isLoading = true.obs;
  late final String chatId;
  late final UserModel otherUser;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    chatId = args['chatId'];
    otherUser = args['otherUser'];
    loadMessages();
  }

  void loadMessages() {
    try {
      isLoading.value = true;
      // Lắng nghe tin nhắn realtime
      _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen((snapshot) {
        try {
          messages.value = snapshot.docs.map((doc) {
            return MessageModel.fromJson({
              'id': doc.id,
              ...doc.data(),
            });
          }).toList();
        } catch (e) {
          print('Error parsing messages: $e');
          messages.value = [];
        }
      });
    } catch (e) {
      print('Error loading messages: $e');
      messages.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage(String content) async {
    try {
      if (content.trim().isEmpty) return;

      final currentUser = Get.find<AuthController>().currentUser;
      if (currentUser.value == null) return;

      // Tạo tin nhắn mới
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'senderId': currentUser.value?.uid,
        'content': content,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Cập nhật thông tin chat
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': content,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'participants': [currentUser.value?.uid, otherUser.uid],
      });
    } catch (e) {
      print('Error sending message: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể gửi tin nhắn',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
} 