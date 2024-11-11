import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/bill_tenant_controller.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:intl/intl.dart';
import './bill_details_view.dart';

class BillView extends GetView<BillTenantController> {
  const BillView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hóa đơn'),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.pending_actions),
                    SizedBox(width: 8),
                    Text('Chưa thanh toán'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle),
                    SizedBox(width: 8),
                    Text('Đã thanh toán'),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBillsList(isPaid: false),
            _buildBillsList(isPaid: true),
          ],
        ),
      ),
    );
  }

  Widget _buildBillsList({required bool isPaid}) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final filteredBills = controller.bills.where((b) {
        if (isPaid) {
          return b.trangThai == 'daThanhToan';
        } else {
          return b.trangThai == 'chuaThanhToan' || b.trangThai == 'choXacNhan';
        }
      }).toList();

      if (filteredBills.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isPaid ? Icons.check_circle_outline : Icons.pending_actions,
                size: 80,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 16),
              Text(
                isPaid
                    ? 'Không có hóa đơn đã thanh toán'
                    : 'Không có hóa đơn chưa thanh toán',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshData,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredBills.length,
          itemBuilder: (context, index) {
            final bill = filteredBills[index];
            final room = controller.getRoomInfo(bill.phongId);

            if (room == null) return const SizedBox.shrink();

            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () => Get.to(() => BillDetailsView(bill: bill)),
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _getStatusColor(bill.trangThai).withOpacity(0.1),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getStatusIcon(bill.trangThai),
                              color: _getStatusColor(bill.trangThai),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Phòng ${room.soPhong}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Tháng ${bill.thang}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _getStatusText(bill.trangThai),
                              style: TextStyle(
                                color: _getStatusColor(bill.trangThai),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tổng tiền',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  NumberFormat.currency(
                                    locale: 'vi_VN',
                                    symbol: 'đ',
                                  ).format(bill.tongTien),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _getStatusColor(bill.trangThai),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (bill.trangThai == 'chuaThanhToan')
                            ElevatedButton(
                              onPressed: () => _showPaymentMethodDialog(bill.id),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                              child: const Text('Thanh toán'),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'chuaThanhToan':
        return Colors.red;
      case 'choXacNhan':
        return Colors.orange;
      case 'daThanhToan':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'chuaThanhToan':
        return Icons.pending_actions;
      case 'choXacNhan':
        return Icons.access_time;
      case 'daThanhToan':
        return Icons.check_circle;
      default:
        return Icons.help_outline;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'chuaThanhToan':
        return 'Chưa thanh toán';
      case 'choXacNhan':
        return 'Chờ xác nhận';
      case 'daThanhToan':
        return 'Đã thanh toán';
      default:
        return 'Không xác định';
    }
  }

  void _showPaymentMethodDialog(String billId) {
    final selectedMethod = ''.obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: Get.width * 0.9,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chọn phương thức thanh toán',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedMethod.value == 'tienMat'
                                ? AppColors.primary
                                : Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => selectedMethod.value = 'tienMat',
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.money,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tiền mặt',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: selectedMethod.value == 'tienMat'
                                                ? AppColors.primary
                                                : Colors.black,
                                          ),
                                        ),
                                        const Text(
                                          'Thanh toán trực tiếp cho chủ trọ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Radio<String>(
                                    value: 'tienMat',
                                    groupValue: selectedMethod.value,
                                    onChanged: (value) =>
                                        selectedMethod.value = value!,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedMethod.value == 'chuyenKhoan'
                                ? AppColors.primary
                                : Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => selectedMethod.value = 'chuyenKhoan',
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.account_balance,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Chuyển khoản',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: selectedMethod.value == 'chuyenKhoan'
                                                ? AppColors.primary
                                                : Colors.black,
                                          ),
                                        ),
                                        const Text(
                                          'Chuyển khoản qua tài khoản ngân hàng',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Radio<String>(
                                    value: 'chuyenKhoan',
                                    groupValue: selectedMethod.value,
                                    onChanged: (value) =>
                                        selectedMethod.value = value!,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Hủy'),
                  ),
                  const SizedBox(width: 8),
                  Obx(() => ElevatedButton(
                        onPressed: selectedMethod.value.isEmpty
                            ? null
                            : () {
                                Get.back();
                                if (selectedMethod.value == 'tienMat') {
                                  _showCashPaymentDialog(billId);
                                } else {
                                  _showBankTransferDialog(billId);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Tiếp tục'),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCashPaymentDialog(String billId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Thanh toán tiền mặt'),
        content: const Text(
            'Vui lòng thanh toán trực tiếp cho chủ trọ. Chủ trọ sẽ xác nhận sau khi nhận được tiền.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Đóng'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.payBill(
                  billId, 'tienMat', false); // false: chờ xác nhận
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  void _showBankTransferDialog(String billId) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Thông tin chuyển khoản',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _buildBankInfo('Ngân hàng', 'Vietcombank'),
                    const Divider(),
                    _buildBankInfo('Số tài khoản', '1234567890'),
                    const Divider(),
                    _buildBankInfo('Chủ tài khoản', 'NGUYEN VAN A'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  controller.payBill(
                      billId, 'chuyenKhoan', true); // true: tự động xác nhận
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Đã chuyển khoản'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBankInfo(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
