import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../controllers/landlord_controller.dart';
import '../../../../../data/models/phong_model.dart';
import '../../../../../data/models/hoa_don_model.dart';
import 'package:intl/intl.dart';

class StatisticsLandlordController extends GetxController {
  final LandlordController landlordController;
  final _firestore = FirebaseFirestore.instance;

  StatisticsLandlordController(this.landlordController);

  final isLoading = true.obs;
  final rooms = <PhongModel>[].obs;
  final bills = <HoaDonModel>[].obs;
  final selectedYear = DateTime.now().year.obs;
  final selectedMonth = DateTime.now().month.obs;

  // Thống kê tổng quan
  final totalRooms = 0.obs;
  final occupiedRooms = 0.obs;
  final emptyRooms = 0.obs;
  final totalTenants = 0.obs;

  // Thống kê doanh thu
  final monthlyRevenue = 0.0.obs;
  final yearlyRevenue = 0.0.obs;
  final unpaidAmount = 0.0.obs;
  final pendingAmount = 0.0.obs;

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
          .get();

      rooms.value = roomsSnapshot.docs
          .map((doc) => PhongModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();

      // Cập nhật thống kê phòng
      totalRooms.value = rooms.length;
      occupiedRooms.value =
          rooms.where((room) => room.trangThai == 'daThue').length;
      emptyRooms.value = rooms.where((room) => room.trangThai == 'trong').length;
      totalTenants.value =
          rooms.fold(0, (sum, room) => sum + room.nguoiThueHienTai.length);

      // Lấy hóa đơn theo tháng/năm
      await loadBills();
    } catch (e) {
      print('Error loading statistics: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadBills() async {
    try {
      final user = landlordController.currentUser;
      if (user == null) return;

      final startDate = DateTime(selectedYear.value, selectedMonth.value, 1);
      final endDate = DateTime(selectedYear.value, selectedMonth.value + 1, 0);

      // Lấy hóa đơn trong tháng
      final billsSnapshot = await _firestore
          .collection('hoaDon')
          .where('chuTroId', isEqualTo: user.uid)
          .where('ngayTao', isGreaterThanOrEqualTo: startDate)
          .where('ngayTao', isLessThanOrEqualTo: endDate)
          .get();

      bills.value = billsSnapshot.docs
          .map((doc) => HoaDonModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();

      // Cập nhật thống kê doanh thu
      monthlyRevenue.value = bills
          .where((bill) => bill.trangThai == 'daThanhToan')
          .fold(0.0, (sum, bill) => sum + bill.tongTien);

      // Cập nhật số tiền chưa thanh toán và chờ xác nhận
      unpaidAmount.value = bills
          .where((bill) => bill.trangThai == 'chuaThanhToan')
          .fold(0.0, (sum, bill) => sum + bill.tongTien);
        
      pendingAmount.value = bills
          .where((bill) => bill.trangThai == 'choXacNhan')
          .fold(0.0, (sum, bill) => sum + bill.tongTien);

      // Tính doanh thu năm
      final yearBillsSnapshot = await _firestore
          .collection('hoaDon')
          .where('chuTroId', isEqualTo: user.uid)
          .where('ngayTao',
              isGreaterThanOrEqualTo: DateTime(selectedYear.value, 1, 1))
          .where('ngayTao',
              isLessThanOrEqualTo: DateTime(selectedYear.value, 12, 31))
          .where('trangThai', isEqualTo: 'daThanhToan')
          .get();

      yearlyRevenue.value = yearBillsSnapshot.docs.fold(
          0.0,
          (sum, doc) =>
              sum + (doc.data()['tongTien'] as num? ?? 0.0).toDouble());
    } catch (e) {
      print('Error loading bills: $e');
    }
  }

  void changeMonth(int month) {
    selectedMonth.value = month;
    loadBills();
  }

  void changeYear(int year) {
    selectedYear.value = year;
    loadBills();
  }

  String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(amount);
  }

  // Lấy doanh thu theo tháng trong năm
  Future<List<double>> getMonthlyRevenueData() async {
    try {
      final user = landlordController.currentUser;
      if (user == null) return List.filled(12, 0);

      final revenueData = List.filled(12, 0.0);

      // Lấy tất cả hóa đơn đã thanh toán trong năm
      final billsSnapshot = await _firestore
          .collection('hoaDon')
          .where('chuTroId', isEqualTo: user.uid)
          .where('ngayTao',
              isGreaterThanOrEqualTo: DateTime(selectedYear.value, 1, 1))
          .where('ngayTao',
              isLessThanOrEqualTo: DateTime(selectedYear.value, 12, 31))
          .where('trangThai', isEqualTo: 'daThanhToan')
          .get();

      // Phân loại doanh thu theo tháng
      for (var doc in billsSnapshot.docs) {
        final data = doc.data();
        final ngayTao = (data['ngayTao'] as Timestamp).toDate();
        final tongTien = (data['tongTien'] as num).toDouble();
        revenueData[ngayTao.month - 1] += tongTien;
      }

      return revenueData;
    } catch (e) {
      print('Error getting monthly revenue data: $e');
      return List.filled(12, 0);
    }
  }

  // Lấy tỷ lệ phòng theo trạng thái
  Map<String, double> getRoomStatusData() {
    final total = rooms.length;
    if (total == 0) return {};

    return {
      'Đang thuê':
          (rooms.where((r) => r.trangThai == 'daThue').length / total) * 100,
      'Trống': (rooms.where((r) => r.trangThai == 'trong').length / total) * 100,
      'Đang sửa':
          (rooms.where((r) => r.trangThai == 'dangSuaChua').length / total) * 100,
    };
  }
} 