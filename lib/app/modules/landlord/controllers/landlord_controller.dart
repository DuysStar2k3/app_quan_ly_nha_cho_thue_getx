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
  String getActivityTitle(Map<String, dynamic> activity) {
    switch (activity['loai']) {
      case 'thanhToan':
        return 'Thanh toán tiền phòng';
      case 'nguoiThue':
        return 'Người thuê mới';
      case 'suaChua':
        return 'Yêu cầu sửa chữa';
      case 'traPhong':
        return 'Trả phòng';
      default:
        return 'Hoạt động khác';
    }
  }

  String getActivityDescription(Map<String, dynamic> activity) {
    switch (activity['loai']) {
      case 'thanhToan':
        return 'Phòng ${activity['soPhong']} đã thanh toán ${activity['soTien']}đ';
      case 'nguoiThue':
        return '${activity['tenNguoiThue']} đã thuê phòng ${activity['soPhong']}';
      case 'suaChua':
        return 'Phòng ${activity['soPhong']} ${activity['noiDung']}';
      case 'traPhong':
        return 'Phòng ${activity['soPhong']} đã trả phòng';
      default:
        return activity['noiDung'] ?? 'Chi tiết hoạt động';
    }
  }

  IconData getActivityIcon(String type) {
    switch (type) {
      case 'thanhToan':
        return Icons.payment;
      case 'nguoiThue':
        return Icons.person_add;
      case 'suaChua':
        return Icons.build;
      case 'traPhong':
        return Icons.key;
      default:
        return Icons.notifications;
    }
  }

  Color getActivityColor(String type) {
    switch (type) {
      case 'thanhToan':
        return Colors.green;
      case 'nguoiThue':
        return Colors.blue;
      case 'suaChua':
        return Colors.orange;
      case 'traPhong':
        return Colors.purple;
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
