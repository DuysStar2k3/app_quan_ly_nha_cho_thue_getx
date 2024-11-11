import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/hoa_don_model.dart';
import '../../../data/models/phong_model.dart';
import '../../../data/models/dich_vu_model.dart';
import '../../../data/repositories/auth_repository.dart';

class BillController extends GetxController {
  final AuthRepository _authRepository;
  final _firestore = FirebaseFirestore.instance;

  BillController(this._authRepository);

  final isLoading = true.obs;
  final bills = <HoaDonModel>[].obs;
  final rooms = <String, PhongModel>{}.obs;
  final services = <String, DichVuModel>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      final user = _authRepository.currentUser.value;
      if (user == null) return;

      // Lấy phòng hiện tại của người thuê
      final roomSnapshot = await _firestore
          .collection('phong')
          .where('nguoiThueHienTai', arrayContains: user.uid)
          .get();

      rooms.clear();
      if (roomSnapshot.docs.isNotEmpty) {
        final room = PhongModel.fromJson({
          'id': roomSnapshot.docs.first.id,
          ...roomSnapshot.docs.first.data(),
        });
        rooms[room.id] = room;

        // Lấy danh sách dịch vụ của phòng
        for (var serviceId in room.dichVu) {
          final serviceDoc =
              await _firestore.collection('dichVu').doc(serviceId).get();
          if (serviceDoc.exists) {
            services[serviceId] = DichVuModel.fromJson({
              'id': serviceDoc.id,
              ...serviceDoc.data()!,
            });
          }
        }

        // Lấy danh sách hóa đơn
        final billsSnapshot = await _firestore
            .collection('hoaDon')
            .where('phongId', isEqualTo: room.id)
            .orderBy('ngayTao', descending: true)
            .get();

        bills.value = billsSnapshot.docs
            .map((doc) => HoaDonModel.fromJson({
                  'id': doc.id,
                  ...doc.data(),
                }))
            .toList();
      }
    } catch (e) {
      print('Error loading bills: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> payBill(
      String billId, String phuongThuc, bool autoConfirm) async {
    try {
      final user = _authRepository.currentUser.value;
      if (user == null) return;

      final bill = bills.firstWhere((b) => b.id == billId);
      final room = rooms[bill.phongId];
      if (room == null) throw 'Không tìm thấy thông tin phòng';

      // Tạo thanh toán mới
      final docRef = await _firestore.collection('thanhToan').add({
        'hoaDonId': billId,
        'nguoiThueId': user.uid,
        'phongId': bill.phongId,
        'soTien': bill.tongTien,
        'phuongThuc': phuongThuc,
        'trangThai': 'choXacNhan',
        'ngayTao': FieldValue.serverTimestamp(),
        'ngayCapNhat': FieldValue.serverTimestamp(),
      });

      // Cập nhật ID
      await docRef.update({'id': docRef.id});

      // Cập nhật trạng thái hóa đơn thành chờ xác nhận
      await _firestore.collection('hoaDon').doc(billId).update({
        'trangThai': 'choXacNhan',
        'ngayCapNhat': FieldValue.serverTimestamp(),
      });

      // Thêm hoạt động
      await _firestore.collection('hoatDong').add({
        'nguoiThueId': user.uid,
        'phongId': bill.phongId,
        'loai': 'thanhToan',
        'hoaDonId': billId,
        'soTien': bill.tongTien,
        'thang': bill.thang,
        'soPhong': room.soPhong,
        'phuongThuc': phuongThuc,
        'trangThai': 'choXacNhan',
        'ngayTao': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Thành công',
        'Đã gửi yêu cầu thanh toán, chờ chủ trọ xác nhận',
        snackPosition: SnackPosition.BOTTOM,
      );

      await loadData();
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể thanh toán: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  PhongModel? getRoomInfo(String roomId) => rooms[roomId];
  DichVuModel? getServiceInfo(String serviceId) => services[serviceId];

  Future<void> refreshData() => loadData();

  // Sửa lại phương thức getMeterReadings
  Future<Map<String, double>> getMeterReadings(
    String roomId,
    String serviceId,
    String thang,
  ) async {
    try {
      // Lấy hóa đơn theo phòng và tháng
      final billSnapshot = await _firestore
          .collection('hoaDon')
          .where('phongId', isEqualTo: roomId)
          .where('thang', isEqualTo: thang)
          .get();

      if (billSnapshot.docs.isEmpty) return {'chiSoCu': 0, 'chiSoMoi': 0};

      final bill = HoaDonModel.fromJson({
        'id': billSnapshot.docs.first.id,
        ...billSnapshot.docs.first.data(),
      });

      // Tìm dịch vụ trong hóa đơn
      final dichVu = bill.dichVu.firstWhere(
        (d) => d.dichVuId == serviceId,
        orElse: () => ChiTietDichVu(
          dichVuId: serviceId,
          soLuong: 0,
          thanhTien: 0,
        ),
      );

      return {
        'chiSoCu': dichVu.chiSoCu ?? 0,
        'chiSoMoi': dichVu.chiSoMoi ?? 0,
      };
    } catch (e) {
      print('Error getting meter readings: $e');
      return {'chiSoCu': 0, 'chiSoMoi': 0};
    }
  }
}
