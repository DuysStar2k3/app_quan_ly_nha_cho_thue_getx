import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/message_model.dart';
import '../../auth/controllers/auth_controller.dart';

class ChatController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final messages = <MessageModel>[].obs;
  final isLoading = true.obs;
  late final UserModel otherUser;
  late final String chatRoomId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    chatRoomId = args['chatRoomId'];
    otherUser = args['otherUser'];
    
    // Kiểm tra và tạo chatRoom nếu chưa tồn tại
    _initializeChatRoom();
    loadMessages();
  }

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
      print('Error initializing chat room: $e');
    }
  }

  void loadMessages() {
    try {
      isLoading.value = true;
      _firestore
          .collection('messages')
          .where('chatRoomId', isEqualTo: chatRoomId)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen(
        (snapshot) {
          try {
            messages.value = snapshot.docs.map((doc) {
              final data = doc.data();
              return MessageModel.fromJson({
                'id': doc.id,
                'senderId': data['senderId'] ?? '',
                'content': data['content'] ?? '',
                'timestamp': data['timestamp'] ?? Timestamp.now(),
                'chatRoomId': data['chatRoomId'] ?? '',
              });
            }).toList();
          } catch (e) {
            print('Error parsing messages: $e');
            messages.value = [];
          }
        },
        onError: (error) {
          print('Error listening to messages: $error');
          messages.value = [];
        },
      );
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

      // Cập nhật thông tin chat cuối cùng
      await _firestore.collection('chatRooms').doc(chatRoomId).update({
        'lastMessage': content.trim(),
        'lastMessageTime': FieldValue.serverTimestamp(),
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

  @override
  void onClose() {
    // Cleanup if needed
    super.onClose();
  }
} 