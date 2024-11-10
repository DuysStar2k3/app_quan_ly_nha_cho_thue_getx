import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/phong_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';

class RoomSearchController extends GetxController {
  final AuthRepository _authRepository;
  final _firestore = FirebaseFirestore.instance;

  RoomSearchController(this._authRepository);

  final isLoading = true.obs;
  final rooms = <PhongModel>[].obs;
  final landlords = <String, UserModel>{}.obs; // Map để lưu thông tin chủ trọ
  final searchQuery = ''.obs;
  
  // Filters
  final sortByPrice = false.obs;
  final showOnlyAvailable = false.obs;
  final minPrice = 0.0.obs;
  final maxPrice = 10000000.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadRooms();
  }

  Future<void> loadRooms() async {
    try {
      isLoading.value = true;
      
      Query query = _firestore.collection('phong');
      
      if (showOnlyAvailable.value) {
        query = query.where('trangThai', isEqualTo: 'trong');
      }

      final snapshot = await query.get();
      
      var roomsList = snapshot.docs.map((doc) {
        return PhongModel.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }).toList();

      // Apply filters
      roomsList = roomsList.where((room) {
        return room.giaThue >= minPrice.value && 
               room.giaThue <= maxPrice.value;
      }).toList();

      if (searchQuery.value.isNotEmpty) {
        roomsList = roomsList.where((room) {
          return room.soPhong.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
                 room.loaiPhong.toLowerCase().contains(searchQuery.value.toLowerCase());
        }).toList();
      }

      if (sortByPrice.value) {
        roomsList.sort((a, b) => a.giaThue.compareTo(b.giaThue));
      }

      rooms.value = roomsList;

      // Load thông tin chủ trọ
      await loadLandlordsInfo(roomsList);
    } catch (e) {
      print('Error loading rooms: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadLandlordsInfo(List<PhongModel> rooms) async {
    try {
      // Lấy danh sách unique ID của chủ trọ
      final landlordIds = rooms.map((room) => room.chuTroId).toSet();
      
      // Load thông tin từng chủ trọ
      for (String id in landlordIds) {
        final doc = await _firestore.collection('nguoiDung').doc(id).get();
        if (doc.exists) {
          landlords[id] = UserModel.fromJson({
            'uid': doc.id,
            ...doc.data()!,
          });
        }
      }
    } catch (e) {
      print('Error loading landlords info: $e');
    }
  }

  // Hàm helper để lấy thông tin chủ trọ
  UserModel? getLandlordInfo(String landlordId) {
    return landlords[landlordId];
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    loadRooms();
  }

  void toggleSortByPrice(bool value) {
    sortByPrice.value = value;
    loadRooms();
  }

  void toggleShowOnlyAvailable(bool value) {
    showOnlyAvailable.value = value;
    loadRooms();
  }

  void updatePriceRange(RangeValues values) {
    minPrice.value = values.start;
    maxPrice.value = values.end;
  }

  void applyPriceFilter() {
    loadRooms();
  }

  Future<void> refreshRooms() async {
    await loadRooms();
  }

  void viewRoomDetails(PhongModel room) {
    Get.toNamed('/tenant/room-details', arguments: room);
  }

  Future<void> requestRoom(PhongModel room) async {
    try {
      final user = _authRepository.currentUser.value;
      if (user == null) {
        Get.snackbar(
          'Lỗi',
          'Vui lòng đăng nhập để đăng ký thuê phòng',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Tạo yêu cầu thuê phòng
      await _firestore.collection('yeuCauThue').add({
        'nguoiThueId': user.uid,
        'phongId': room.id,
        'trangThai': 'choXacNhan',
        'ngayTao': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Thành công',
        'Đã gửi yêu cầu thuê phòng',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể gửi yêu cầu: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
} 