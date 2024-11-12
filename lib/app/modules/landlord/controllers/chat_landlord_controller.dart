import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_pages.dart';
import '../../auth/controllers/auth_controller.dart';

class ChatLandlordController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final chats = <String, dynamic>{}.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadChats();
  }

  void loadChats() {
    try {
      isLoading.value = true;
      final currentUser = Get.find<AuthController>().currentUser;
      if (currentUser.value == null) return;

      // Lắng nghe các cuộc trò chuyện realtime
      _firestore
          .collection('chats')
          .where('participants', arrayContains: currentUser.value!.uid)
          .where('lastMessage', isNull: false)
          .snapshots()
          .listen((snapshot) async {
        chats.clear();
        
        for (var doc in snapshot.docs) {
          final chatData = doc.data();
          final participants = List<String>.from(chatData['participants'] ?? []);
          
          final tenantId = participants.firstWhere(
            (id) => id != currentUser.value!.uid,
            orElse: () => '',
          );

          if (tenantId.isNotEmpty) {
            final userDoc = await _firestore
                .collection('nguoiDung')
                .doc(tenantId)
                .get();
            
            if (userDoc.exists) {
              final userData = userDoc.data()!;

              // Lấy thông tin phòng của người thuê
              final roomSnapshot = await _firestore
                  .collection('phong')
                  .where('nguoiThueHienTai', arrayContains: tenantId)
                  .get();

              Map<String, dynamic>? roomInfo;
              if (roomSnapshot.docs.isNotEmpty) {
                roomInfo = {
                  'id': roomSnapshot.docs.first.id,
                  'soPhong': roomSnapshot.docs.first.data()['soPhong'],
                };
              }

              chats[doc.id] = {
                'chatId': doc.id,
                'lastMessage': chatData['lastMessage'],
                'lastMessageTime': chatData['lastMessageTime'],
                'otherUser': UserModel.fromJson({
                  'uid': userDoc.id,
                  ...userData,
                }),
                'roomInfo': roomInfo,
              };
            }
          }
        }
        chats.refresh();
      });
    } finally {
      isLoading.value = false;
    }
  }

  void openChat(String chatId, UserModel otherUser) {
    Get.toNamed(
      Routes.CHAT_ROOM,
      arguments: {
        'chatId': chatId,
        'otherUser': otherUser,
      },
    );
  }

  String getTimeAgo(Timestamp? timestamp) {
    if (timestamp == null) return '';
    
    final now = DateTime.now();
    final time = timestamp.toDate();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
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