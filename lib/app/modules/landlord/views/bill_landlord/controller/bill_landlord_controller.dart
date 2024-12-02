import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../data/models/hoa_don_model.dart';
import '../../../../../data/models/phong_model.dart';
import '../../../../../data/models/dich_vu_model.dart';
import '../../../controllers/landlord_controller.dart';

class BillLandlordController extends GetxController {
  final LandlordController landlordController;
  final _firestore = FirebaseFirestore.instance;

  BillLandlordController(this.landlordController);

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
      final user = landlordController.currentUser;
      if (user == null) return;

      // Lấy danh sách phòng
      final roomsSnapshot = await _firestore
          .collection('phong')
          .where('chuTroId', isEqualTo: user.uid)
          .where('trangThai', isEqualTo: 'daThue')
          .get();

      rooms.clear();
      for (var doc in roomsSnapshot.docs) {
        rooms[doc.id] = PhongModel.fromJson({
          'id': doc.id,
          ...doc.data(),
        });
      }

      // Lấy danh sách dịch vụ
      final servicesSnapshot = await _firestore
          .collection('dichVu')
          .where('chuTroId', isEqualTo: user.uid)
          .get();

      services.clear();
      for (var doc in servicesSnapshot.docs) {
        services[doc.id] = DichVuModel.fromJson({
          'id': doc.id,
          ...doc.data(),
        });
      }

      // Lấy danh sách hóa đơn
      final billsSnapshot = await _firestore
          .collection('hoaDon')
          .where('chuTroId', isEqualTo: user.uid)
          .orderBy('ngayTao', descending: true)
          .get();

      bills.value = billsSnapshot.docs
          .map((doc) => HoaDonModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      print('Error loading bills: $e');
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> createBill({
    required String phongId,
    required String thang,
    required List<ChiTietDichVu> dichVu,
    required double tongTien,
    required Map<String, Map<String, double>> chiSoCongTo,
  }) async {
    try {
      final user = landlordController.currentUser;
      if (user == null) return;

      // Kiểm tra xem đã có hóa đơn cho phòng này trong tháng này chưa
      final existingBill = await _firestore
          .collection('hoaDon')
          .where('phongId', isEqualTo: phongId)
          .where('thang', isEqualTo: thang)
          .where('trangThai',
              whereIn: ['chuaThanhToan', 'choXacNhan', 'daThanhToan']).get();

      if (existingBill.docs.isNotEmpty) {
        throw 'Đã tồn tại hóa đơn cho phòng này trong tháng $thang';
      }

      // Lấy thông tin phòng
      final room = rooms[phongId];
      if (room == null) throw 'Không tìm thấy thông tin phòng';
      // Tạo danh sách dịch vụ với chỉ số công tơ
      final List<Map<String, dynamic>> dichVuList = dichVu.map((d) {
        final Map<String, dynamic> data = d.toJson();
        if (chiSoCongTo.containsKey(d.dichVuId)) {
          data['chiSoCu'] = chiSoCongTo[d.dichVuId]!['cu'];
          data['chiSoMoi'] = chiSoCongTo[d.dichVuId]!['moi'];
        }
        return data;
      }).toList();

      // Tạo hóa đơn mới
      final docRef = await _firestore.collection('hoaDon').add({
        'chuTroId': user.uid,
        'phongId': phongId,
        'thang': thang,
        'dichVu': dichVuList,
        'tongTien': tongTien,
        'trangThai': 'chuaThanhToan',
        'ngayTao': FieldValue.serverTimestamp(),
        'ngayCapNhat': FieldValue.serverTimestamp(),
      });

      // Cập nhật ID
      await docRef.update({'id': docRef.id});

      // Thêm hoạt động
      await _firestore.collection('hoatDong').add({
        'chuTroId': user.uid,
        'phongId': phongId,
        'loai': 'taoHoaDon',
        'soPhong': room.soPhong,
        'thang': thang,
        'tongTien': tongTien,
        'ngayTao': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Thành công',
        'Đã tạo hóa đơn mới',
        snackPosition: SnackPosition.BOTTOM,
      );

      await loadData();
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể tạo hóa đơn: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteBill(String billId) async {
    try {
      // Lấy thông tin hóa đơn
      final bill = bills.firstWhere((b) => b.id == billId);

      // Chỉ cho phép xóa hóa đơn chưa thanh toán
      if (bill.trangThai == 'daThanhToan' || bill.trangThai == 'choXacNhan') {
        throw 'Không thể xóa hóa đơn đã thanh toán hoặc chờ xác nhận';
      }
      // Xóa hóa đơn
      await _firestore.collection('hoaDon').doc(billId).delete();
      // Thêm hoạt động
      await _firestore.collection('hoatDong').add({
        'chuTroId': landlordController.currentUser?.uid,
        'phongId': bill.phongId,
        'loai': 'xoaHoaDon',
        'soPhong': rooms[bill.phongId]?.soPhong,
        'thang': bill.thang,
        'ngayTao': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Thành công',
        'Đã xóa hóa đơn',
        snackPosition: SnackPosition.BOTTOM,
      );

      await loadData();
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể xóa hóa đơn: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  PhongModel? getRoomInfo(String roomId) => rooms[roomId];
  DichVuModel? getServiceInfo(String serviceId) => services[serviceId];

  Future<void> refreshData() => loadData();

  // Thêm phương thức xác nhận thanh toán
  Future<void> confirmPayment(String billId) async {
    try {
      final user = landlordController.currentUser;
      if (user == null) return;

      // Lấy thông tin hóa đơn
      final bill = bills.firstWhere((b) => b.id == billId);

      // Cập nhật trạng thái hóa đơn
      await _firestore.collection('hoaDon').doc(billId).update({
        'trangThai': 'daThanhToan',
        'ngayCapNhat': FieldValue.serverTimestamp(),
      });

      // Cập nhật trạng thái thanh toán
      final paymentSnapshot = await _firestore
          .collection('thanhToan')
          .where('hoaDonId', isEqualTo: billId)
          .where('trangThai', isEqualTo: 'choXacNhan')
          .get();

      if (paymentSnapshot.docs.isNotEmpty) {
        await _firestore
            .collection('thanhToan')
            .doc(paymentSnapshot.docs.first.id)
            .update({
          'trangThai': 'daThanhToan',
          'ngayCapNhat': FieldValue.serverTimestamp(),
        });
      }

      // Cập nhật chỉ số công tơ cho phòng
      final updates = <String, dynamic>{
        'ngayCapNhat': FieldValue.serverTimestamp(),
      };

      // Tìm các dịch vụ tính theo công tơ
      for (var dichVu in bill.dichVu) {
        final service = services[dichVu.dichVuId];
        if (service == null) continue;

        if (service.donVi == 'kWh') {
          updates['congTo.dienKe'] = {
            'chiSoCuoi': dichVu.chiSoMoi,
            'ngayGhi': FieldValue.serverTimestamp(),
            'soCongTo': 'DIEN01',
          };
        } else if (service.donVi == 'm³') {
          updates['congTo.nuocKe'] = {
            'chiSoCuoi': dichVu.chiSoMoi,
            'ngayGhi': FieldValue.serverTimestamp(),
            'soCongTo': 'NUOC01',
          };
        }
      }

      // Cập nhật chỉ số công tơ mới cho phòng
      await _firestore.collection('phong').doc(bill.phongId).update(updates);

      // Thêm hoạt động
      await _firestore.collection('hoatDong').add({
        'chuTroId': user.uid,
        'phongId': bill.phongId,
        'loai': 'xacNhanThanhToan',
        'hoaDonId': billId,
        'soTien': bill.tongTien,
        'thang': bill.thang,
        'soPhong': rooms[bill.phongId]?.soPhong,
        'ngayTao': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Thành công',
        'Đã xác nhận thanh toán',
        snackPosition: SnackPosition.BOTTOM,
      );

      await loadData();
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể xác nhận thanh toán: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Thêm phương thức lấy số công tơ cũ
  Future<Map<String, double>> getRoomMeterReadings(String roomId) async {
    try {
      // Lấy tài liệu của phòng từ Firestore
      final roomSnapshot =
          await _firestore.collection('phong').doc(roomId).get();

      if (!roomSnapshot.exists) return {};

      // Trích xuất dữ liệu `congTo` từ tài liệu `phong`
      final roomData = roomSnapshot.data();
      final congTo = roomData?['congTo'] as Map<String, dynamic>?;
      if (congTo == null) return {};

      // Lấy chỉ số cuối của điện kế và nước kế
      final dienKe = congTo['dienKe'] as Map<String, dynamic>?;
      final nuocKe = congTo['nuocKe'] as Map<String, dynamic>?;

      Map<String, double> meterReadings = {};

      // Tìm dịch vụ điện và nước
      for (var service in services.values) {
        if (service.donVi == 'kWh' && dienKe != null) {
          meterReadings[service.id] = (dienKe['chiSoCuoi'] ?? 0).toDouble();
        } else if (service.donVi == 'm³' && nuocKe != null) {
          meterReadings[service.id] = (nuocKe['chiSoCuoi'] ?? 0).toDouble();
        }
      }

      return meterReadings;
    } catch (e) {
      print('Lỗi khi lấy chỉ số công tơ từ bảng phong: $e');
      return {};
    }
  }

  // Thêm phương thức tính số lượng dịch vụ theo đơn vị
  double calculateServiceQuantity(DichVuModel service, PhongModel room) {
    switch (service.donVi) {
      case 'người':
        return room.nguoiThueHienTai.length.toDouble();
      case 'tháng':
        return 1;
      default:
        return 0; // Đối với công tơ sẽ được tính dựa trên chỉ số mới - cũ
    }
  }

  // Thêm phương thức getMeterReadings
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
