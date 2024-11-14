import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../data/models/user_model.dart';
import '../../../../../routes/app_pages.dart';
import '../../../../auth/controllers/auth_controller.dart';

class ChatTenantController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final chats = <String, dynamic>{}.obs;
  final isLoading = true.obs;
  String? currentLandlordId;

  @override
  void onInit() {
    super.onInit();
    loadCurrentLandlord();
  }

  Future<void> loadCurrentLandlord() async {
    try {
      final currentUser = Get.find<AuthController>().currentUser;
      if (currentUser.value == null) return;

      // Lấy phòng hiện tại của người thuê
      final roomSnapshot = await _firestore
          .collection('phong')
          .where('nguoiThueHienTai', arrayContains: currentUser.value!.uid)
          .get();

      if (roomSnapshot.docs.isNotEmpty) {
        currentLandlordId = roomSnapshot.docs.first.data()['chuTroId'];
      }

      loadChats();
    } catch (e) {
      print('Error loading current landlord: $e');
      loadChats();
    }
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
          
          final landlordId = participants.firstWhere(
            (id) => id != currentUser.value!.uid,
            orElse: () => '',
          );

          if (landlordId.isNotEmpty) {
            final userDoc = await _firestore
                .collection('nguoiDung')
                .doc(landlordId)
                .get();
            
            if (userDoc.exists) {
              final userData = userDoc.data()!;
              final isCurrentLandlord = landlordId == currentLandlordId;

              // Lấy thông tin phòng nếu là chủ trọ hiện tại
              Map<String, dynamic>? roomInfo;
              if (isCurrentLandlord) {
                final roomSnapshot = await _firestore
                    .collection('phong')
                    .where('nguoiThueHienTai', arrayContains: currentUser.value!.uid)
                    .get();

                if (roomSnapshot.docs.isNotEmpty) {
                  roomInfo = {
                    'id': roomSnapshot.docs.first.id,
                    'soPhong': roomSnapshot.docs.first.data()['soPhong'],
                  };
                }
              }

              chats[doc.id] = {
                'chatId': doc.id,
                'lastMessage': chatData['lastMessage'],
                'lastMessageTime': chatData['lastMessageTime'],
                'otherUser': UserModel.fromJson({
                  'uid': userDoc.id,
                  ...userData,
                }),
                'isCurrentLandlord': isCurrentLandlord,
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