import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../data/models/user_model.dart';
import '../../../../auth/controllers/auth_controller.dart';
import '../../../../../routes/app_pages.dart';

class ChatLandlordController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final isLoading = true.obs;
  final chats = <String, Map<String, dynamic>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadChats();
  }

  Future<void> loadChats() async {
    try {
      isLoading.value = true;
      final currentUser = Get.find<AuthController>().currentUser.value;
      if (currentUser == null) return;

      // Lắng nghe thay đổi từ collection chatRooms
      _firestore
          .collection('chatRooms')
          .where('participants', arrayContains: currentUser.uid)
          .snapshots()
          .listen((snapshot) async {
        for (var doc in snapshot.docs) {
          final chatData = doc.data();
          final participants = List<String>.from(chatData['participants'] ?? []);
          
          // Lấy ID của người còn lại trong cuộc trò chuyện
          final otherUserId = participants.firstWhere(
            (id) => id != currentUser.uid,
            orElse: () => '',
          );

          if (otherUserId.isEmpty) continue;

          // Lấy thông tin người dùng
          final otherUserDoc = await _firestore
              .collection('nguoiDung')
              .doc(otherUserId)
              .get();

          if (!otherUserDoc.exists) continue;

          final otherUser = UserModel.fromJson({
            'uid': otherUserDoc.id,
            ...otherUserDoc.data()!,
          });

          // Chỉ hiển thị chat với người thuê
          if (otherUser.vaiTro != 'nguoiThue') continue;

          // Kiểm tra xem người này có đang thuê phòng của mình không
          Map<String, dynamic>? roomInfo;
          final roomQuery = await _firestore
              .collection('phong')
              .where('chuTroId', isEqualTo: currentUser.uid)
              .where('nguoiThueHienTai', arrayContains: otherUser.uid)
              .get();

          if (roomQuery.docs.isNotEmpty) {
            roomInfo = {
              'id': roomQuery.docs.first.id,
              'soPhong': roomQuery.docs.first.data()['soPhong'],
            };
          }

          // Cập nhật danh sách chat
          chats[doc.id] = {
            'chatId': doc.id,
            'otherUser': otherUser,
            'lastMessage': chatData['lastMessage'],
            'lastMessageTime': chatData['lastMessageTime'],
            'roomInfo': roomInfo,
          };
        }
        chats.refresh(); // Cập nhật UI
      });
    } catch (e) {
      print('Lỗi tải danh sách chat: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void openChat(String chatId, UserModel otherUser) {
    Get.toNamed(
      Routes.CHAT_ROOM,
      arguments: {
        'chatRoomId': chatId,
        'otherUser': otherUser,
      },
    );
  }

  String getTimeAgo(Timestamp? timestamp) {
    if (timestamp == null) return '';

    final now = DateTime.now();
    final time = timestamp.toDate();
    final difference = now.difference(time);

    if (difference.inDays > 7) {
      return '${time.day}/${time.month}/${time.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }
} 