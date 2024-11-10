import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/phong_model.dart';
import '../../../data/models/hop_dong_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/user_model.dart';

class HomeController extends GetxController {
  final AuthRepository _authRepository;
  final _firestore = FirebaseFirestore.instance;

  HomeController(this._authRepository);

  UserModel? get currentUser => _authRepository.currentUser.value;

  final isLoading = true.obs;
  final currentRoom = Rxn<PhongModel>();
  final currentContract = Rxn<HopDongModel>();
  final recentActivities = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      isLoading.value = true;
      final user = currentUser;
      if (user != null) {
        await Future.wait([
          _loadCurrentRoom(user.uid),
          _loadRecentActivities(user.uid),
        ]);
      }
    } catch (e) {
      print('Error loading home data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadCurrentRoom(String userId) async {
    // Tìm phòng hiện tại của người thuê
    final roomSnapshot = await _firestore
        .collection('phong')
        .where('nguoiThueHienTai', arrayContains: userId)
        .get();

    if (roomSnapshot.docs.isNotEmpty) {
      currentRoom.value = PhongModel.fromJson({
        'id': roomSnapshot.docs.first.id,
        ...roomSnapshot.docs.first.data(),
      });

      // Load hợp đồng của phòng
      await _loadCurrentContract(userId, roomSnapshot.docs.first.id);
    }
  }

  Future<void> _loadCurrentContract(String userId, String roomId) async {
    final contractSnapshot = await _firestore
        .collection('hopDong')
        .where('nguoiThueId', isEqualTo: userId)
        .where('phongId', isEqualTo: roomId)
        .where('trangThai', isEqualTo: 'hieuLuc')
        .get();

    if (contractSnapshot.docs.isNotEmpty) {
      currentContract.value = HopDongModel.fromJson({
        'id': contractSnapshot.docs.first.id,
        ...contractSnapshot.docs.first.data(),
      });
    }
  }

  Future<void> _loadRecentActivities(String userId) async {
    final activitiesSnapshot = await _firestore
        .collection('hoatDong')
        .where('nguoiThueId', isEqualTo: userId)
        .orderBy('ngayTao', descending: true)
        .limit(5)
        .get();

    recentActivities.value = activitiesSnapshot.docs
        .map((doc) => {
              'id': doc.id,
              ...doc.data(),
            })
        .toList();
  }

  Future<void> refreshData() async {
    await _loadData();
  }

  // Helper methods for activities
  String getActivityTitle(Map<String, dynamic> activity) {
    switch (activity['loai']) {
      case 'thanhToan':
        return 'Thanh toán tiền phòng';
      case 'suaChua':
        return 'Yêu cầu sửa chữa';
      case 'thongBao':
        return 'Thông báo mới';
      default:
        return 'Hoạt động khác';
    }
  }

  String getActivityDescription(Map<String, dynamic> activity) {
    switch (activity['loai']) {
      case 'thanhToan':
        return 'Đã thanh toán ${activity['soTien']}đ cho tháng ${activity['thang']}';
      case 'suaChua':
        return activity['noiDung'] ?? 'Yêu cầu sửa chữa mới';
      case 'thongBao':
        return activity['noiDung'] ?? 'Có thông báo mới';
      default:
        return activity['noiDung'] ?? 'Chi tiết hoạt động';
    }
  }

  String getTimeAgo(Timestamp timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp.toDate());

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