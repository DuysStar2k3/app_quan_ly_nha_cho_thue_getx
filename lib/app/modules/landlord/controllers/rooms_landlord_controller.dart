import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/phong_model.dart';
import './landlord_controller.dart';

class RoomsLandlordController extends GetxController {
  final LandlordController landlordController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RoomsLandlordController(this.landlordController);

  final isLoading = false.obs;
  final rooms = <PhongModel>[].obs;
  StreamSubscription? _roomsSubscription;

  @override
  void onInit() {
    super.onInit();
    _initRooms();
  }

  @override
  void onClose() {
    _roomsSubscription?.cancel();
    super.onClose();
  }

  Future<void> _initRooms() async {
    final user = landlordController.currentUser;
    if (user != null) {
      _roomsSubscription = _firestore
          .collection('phong')
          .where('chuTroId', isEqualTo: user.uid)
          .orderBy('ngayCapNhat', descending: true)
          .snapshots()
          .listen(
        (snapshot) {
          rooms.value = snapshot.docs
              .map((doc) => PhongModel.fromJson({
                    'id': doc.id,
                    ...doc.data(),
                  }))
              .toList();
        },
        onError: (error) => print('Error loading rooms: $error'),
      );
    }
  }

  Future<void> addRoom({
    required String soPhong,
    required int tang,
    required String loaiPhong,
    required double dienTich,
    required double giaThue,
    required double tienCoc,
    required List<String> tienNghi,
    required ChiSoDienNuoc dienKe,
    required ChiSoDienNuoc nuocKe,
  }) async {
    try {
      final user = landlordController.currentUser;
      if (user == null) throw 'User not found';

      // Kiểm tra số phòng đã tồn tại
      final existingRoom = rooms.firstWhereOrNull((r) => r.soPhong == soPhong);
      if (existingRoom != null) {
        throw 'Số phòng đã tồn tại';
      }

      final room = PhongModel(
        id: '',
        chuTroId: user.uid,
        soPhong: soPhong,
        tang: tang,
        loaiPhong: loaiPhong,
        trangThai: 'trong',
        dienTich: dienTich,
        giaThue: giaThue,
        tienCoc: tienCoc,
        tienNghi: tienNghi,
        hinhAnh: [],
        nguoiThueHienTai: [],
        dichVu: [],
        congTo: CongToModel(
          dienKe: dienKe,
          nuocKe: nuocKe,
        ),
        ngayTao: DateTime.now(),
        ngayCapNhat: DateTime.now(),
      );

      final newRoom = await _firestore.collection('phong').doc();
      final roomWithId = room.copyWith(id: newRoom.id);
      
      await newRoom.set({
        ...roomWithId.toJson(),
        'id': newRoom.id,
      });

      // Thêm hoạt động
      await _firestore.collection('hoatDong').add({
        'chuTroId': user.uid,
        'loai': 'themPhong',
        'soPhong': soPhong,
        'noiDung': 'Đã thêm phòng mới',
        'ngayTao': FieldValue.serverTimestamp(),
      });

      Get.back();
      Get.snackbar(
        'Thành công',
        'Đã thêm phòng mới',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }

  Future<void> deleteRoom(String roomId) async {
    try {
      await _firestore.collection('phong').doc(roomId).delete();
      Get.snackbar(
        'Thành công',
        'Đã xóa phòng',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể xóa phòng: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }

  // Helper methods
  Color getRoomStatusColor(String status) {
    switch (status) {
      case 'trong':
        return Colors.green;
      case 'daThue':
        return Colors.blue;
      case 'dangSuaChua':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData getRoomStatusIcon(String status) {
    switch (status) {
      case 'trong':
        return Icons.check_circle;
      case 'daThue':
        return Icons.people;
      case 'dangSuaChua':
        return Icons.build;
      default:
        return Icons.info;
    }
  }

  String getRoomStatusText(String status) {
    switch (status) {
      case 'trong':
        return 'Trống';
      case 'daThue':
        return 'Đã thuê';
      case 'dangSuaChua':
        return 'Đang sửa';
      default:
        return 'Không xác định';
    }
  }

  String getLoaiPhongText(String loaiPhong) {
    switch (loaiPhong) {
      case 'don':
        return 'Phòng đơn';
      case 'doi':
        return 'Phòng đôi';
      case 'studio':
        return 'Studio';
      default:
        return loaiPhong;
    }
  }

  String getSoNguoiToiDa(String loaiPhong) {
    switch (loaiPhong) {
      case 'don':
        return '2 người';
      case 'doi':
        return '4 người';
      case 'studio':
        return '4 người';
      default:
        return '2 người';
    }
  }
}
