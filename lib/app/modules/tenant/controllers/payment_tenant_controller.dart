import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/controllers/tenant_page_controller.dart';
import '../../../data/models/thanh_toan_model.dart';
import '../../../data/models/hoa_don_model.dart';

class PaymentTenantController extends GetxController {
  final TenantPageController tenantPageController;
  final _firestore = FirebaseFirestore.instance;

  PaymentTenantController(this.tenantPageController);

  final isLoading = true.obs;
  final payments = <ThanhToanModel>[].obs;
  final unpaidBills = <HoaDonModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      final user = tenantPageController.currentUser;
      if (user == null) return;

      // Lấy danh sách hóa đơn chưa thanh toán
      final billsSnapshot = await _firestore
          .collection('hoaDon')
          .where('nguoiThueId', isEqualTo: user.uid)
          .where('trangThai', isEqualTo: 'chuaThanhToan')
          .orderBy('ngayTao', descending: true)
          .get();

      unpaidBills.value = billsSnapshot.docs
          .map((doc) => HoaDonModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();

      // Lấy lịch sử thanh toán
      final paymentsSnapshot = await _firestore
          .collection('thanhToan')
          .where('nguoiThueId', isEqualTo: user.uid)
          .orderBy('ngayTao', descending: true)
          .get();

      payments.value = paymentsSnapshot.docs
          .map((doc) => ThanhToanModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      print('Error loading payment data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> makePayment({
    required String hoaDonId,
    required double soTien,
    required String phuongThuc,
    String? ghiChu,
  }) async {
    try {
      final user = tenantPageController.currentUser;
      if (user == null) return;

      // Lấy thông tin hóa đơn
      final hoaDonDoc = await _firestore.collection('hoaDon').doc(hoaDonId).get();
      if (!hoaDonDoc.exists) throw 'Không tìm thấy hóa đơn';

      final hoaDon = HoaDonModel.fromJson({
        'id': hoaDonDoc.id,
        ...hoaDonDoc.data()!,
      });

      // Tạo thanh toán mới
      final docRef = await _firestore.collection('thanhToan').add({
        'hoaDonId': hoaDonId,
        'nguoiThueId': user.uid,
        'phongId': hoaDon.phongId,
        'soTien': soTien,
        'phuongThuc': phuongThuc,
        'trangThai': 'daThanhToan',
        'ghiChu': ghiChu,
        'ngayTao': FieldValue.serverTimestamp(),
        'ngayCapNhat': FieldValue.serverTimestamp(),
      });

      // Cập nhật ID
      await docRef.update({'id': docRef.id});

      // Cập nhật trạng thái hóa đơn
      await _firestore.collection('hoaDon').doc(hoaDonId).update({
        'trangThai': 'daThanhToan',
        'ngayCapNhat': FieldValue.serverTimestamp(),
      });

      // Thêm hoạt động
      await _firestore.collection('hoatDong').add({
        'nguoiThueId': user.uid,
        'loai': 'thanhToan',
        'hoaDonId': hoaDonId,
        'phongId': hoaDon.phongId,
        'soTien': soTien,
        'thang': hoaDon.thang,
        'ngayTao': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Thành công',
        'Đã thanh toán hóa đơn',
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

  Future<void> refreshData() => loadData();
} 