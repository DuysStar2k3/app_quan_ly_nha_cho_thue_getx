import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/controllers/tenant_page_controller.dart';
import '../../../../../data/models/thanh_toan_model.dart';
import '../../../../../data/models/hoa_don_model.dart';

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

  Future<void> refreshData() => loadData();

  Future<void> huyThanhToan(ThanhToanModel thanhToan) async {
    try {
      // Cập nhật trạng thái hóa đơn về choThanhToan
      await FirebaseFirestore.instance
          .collection('hoaDon')
          .doc(thanhToan.hoaDonId)
          .update({
        'trangThai': 'chuaThanhToan',
        'ngayCapNhat': FieldValue.serverTimestamp(),
      });

      // Xóa record thanh toán
      await FirebaseFirestore.instance
          .collection('thanhToan')
          .doc(thanhToan.id)
          .delete();

      // Refresh lại danh sách thanh toán
      await loadData();

      Get.snackbar(
        'Thành công',
        'Đã hủy thanh toán',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Lỗi khi hủy thanh toán: $e'); // Thêm log để debug
      Get.snackbar(
        'Lỗi',
        'Không thể hủy thanh toán. Vui lòng thử lại',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
