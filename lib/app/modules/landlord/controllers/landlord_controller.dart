import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/user_model.dart';

class LandlordController extends GetxController {
  final AuthRepository _authRepository;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  LandlordController(this._authRepository);

  // Navigation
  final selectedIndex = 0.obs;
  final isLoading = false.obs;

  // User info
  UserModel? get currentUser => _authRepository.currentUser.value;

  // Recent Activities
  final recentActivities = <Map<String, dynamic>>[].obs;
  StreamSubscription? _activitiesSubscription;

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  @override
  void onClose() {
    _activitiesSubscription?.cancel();
    super.onClose();
  }

  Future<void> _initData() async {
    try {
      isLoading.value = true;
      await _initActivities();
    } catch (e) {
      print('Error initializing data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _initActivities() async {
    final user = currentUser;
    if (user != null) {
      _activitiesSubscription = _firestore
          .collection('hoatDong')
          .where('chuTroId', isEqualTo: user.uid)
          .orderBy('ngayTao', descending: true)
          .limit(10)
          .snapshots()
          .listen(
        (snapshot) {
          recentActivities.value = snapshot.docs
              .map((doc) => {
                    'id': doc.id,
                    ...doc.data(),
                  })
              .toList();
        },
        onError: (error) => print('Error loading activities: $error'),
      );
    }
  }

  Future<void> refreshData() async {
    await _initData();
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  // Activity helpers
  String getActivityTitle(String type) {
    switch (type) {
      case 'thanhToan':
        return 'Thanh toán tiền phòng';
      case 'suaChua':
        return 'Yêu cầu sửa chữa';
      case 'thongBao':
        return 'Thông báo mới';
      case 'guiYeuCauThamGia':
        return 'Gửi yêu cầu tham gia';
      case 'chapNhanYeuCau':
        return 'Chấp nhận yêu cầu thuê';
      case 'tuChoiYeuCau':
        return 'Từ chối yêu cầu thuê';
      case 'xacNhanThamGia':
        return 'Xác nhận tham gia';
      case 'traPhong':
        return 'Trả phòng';
      default:
        return 'Hoạt động khác';
    }
  }

  String getActivityDescription(Map<String, dynamic> activity) {
    final type = activity['loai'] ?? '';
    final soPhong = activity['soPhong']?.toString() ?? '';
    
    switch (type) {
      case 'thanhToan':
        return 'Đã thanh toán ${activity['soTien']}đ cho tháng ${activity['thang']}';
      case 'suaChua':
        return activity['noiDung'] ?? 'Yêu cầu sửa chữa mới';
      case 'thongBao':
        return activity['noiDung'] ?? 'Thông báo mới';
      case 'guiYeuCauThamGia':
        return 'Đã gửi yêu cầu tham gia phòng $soPhong';
      case 'chapNhanYeuCau':
        return 'Đã chấp nhận yêu cầu thuê phòng $soPhong';
      case 'tuChoiYeuCau':
        return 'Đã từ chối yêu cầu thuê phòng $soPhong';
      case 'xacNhanThamGia':
        return 'Đã xác nhận tham gia phòng $soPhong';
      case 'traPhong':
        return 'Người thuê đã trả phòng $soPhong';
      default:
        return activity['noiDung'] ?? 'Không có mô tả';
    }
  }

  IconData getActivityIcon(String type) {
    switch (type) {
      case 'thanhToan':
        return Icons.payment;
      case 'suaChua':
        return Icons.build;
      case 'thongBao':
        return Icons.notifications;
      case 'guiYeuCauThamGia':
        return Icons.person_add;
      case 'chapNhanYeuCau':
        return Icons.check_circle;
      case 'tuChoiYeuCau':
        return Icons.cancel;
      case 'xacNhanThamGia':
        return Icons.how_to_reg;
      case 'traPhong':
        return Icons.logout;
      default:
        return Icons.circle_notifications;
    }
  }

  Color getActivityColor(String type) {
    switch (type) {
      case 'thanhToan':
        return Colors.green;
      case 'suaChua':
        return Colors.orange;
      case 'thongBao':
        return Colors.blue;
      case 'guiYeuCauThamGia':
        return Colors.purple;
      case 'chapNhanYeuCau':
        return Colors.green;
      case 'tuChoiYeuCau':
        return Colors.red;
      case 'xacNhanThamGia':
        return Colors.green;
      case 'traPhong':
        return Colors.red;
      default:
        return Colors.grey;
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
