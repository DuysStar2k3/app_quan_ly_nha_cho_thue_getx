import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/hoa_don_model.dart';
import '../../controllers/bill_tenant_controller.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:intl/intl.dart';

class BillTenantDetailsView extends GetView<BillTenantController> {
  final HoaDonModel bill;
  const BillTenantDetailsView({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    final room = controller.getRoomInfo(bill.phongId);
    if (room == null) return const Scaffold();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết hóa đơn'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin cơ bản
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.receipt_long,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Phòng ${room.soPhong}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Tháng ${bill.thang}',
                                style: TextStyle(
                                  color: Colors.grey[600],
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
                            color: bill.trangThai == 'daThanhToan'
                                ? Colors.green.withOpacity(0.1)
                                : bill.trangThai == 'choXacNhan'
                                    ? Colors.yellow.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            bill.trangThai == 'daThanhToan'
                                ? 'Đã thanh toán'
                                : bill.trangThai == 'choXacNhan'
                                    ? 'Chờ xác nhận'
                                    : 'Chưa thanh toán',
                            style: TextStyle(
                              color: bill.trangThai == 'daThanhToan'
                                  ? Colors.green
                                  : bill.trangThai == 'choXacNhan'
                                      ? Colors.orange
                                      : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    _buildDetailRow(
                      'Tiền phòng',
                      NumberFormat.currency(
                        locale: 'vi_VN',
                        symbol: 'đ',
                      ).format(room.giaThue),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Chi tiết dịch vụ
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chi tiết dịch vụ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...bill.dichVu.map((dichVu) {
                      final service =
                          controller.getServiceInfo(dichVu.dichVuId);
                      if (service == null) return const SizedBox.shrink();

                      return Column(
                        children: [
                          if (service.donVi == 'kWh' ||
                              service.donVi == 'm³') ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  _buildMeterRow(
                                    'Chỉ số cũ',
                                    'Chỉ số mới',
                                    'Tiêu thụ',
                                    isHeader: true,
                                  ),
                                  const SizedBox(height: 8),
                                  FutureBuilder<Map<String, double>>(
                                    future: controller.getMeterReadings(
                                      bill.phongId,
                                      dichVu.dichVuId,
                                      bill.thang,
                                    ),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }
                                      final readings = snapshot.data!;
                                      final oldValue = readings['chiSoCu'] ?? 0;
                                      final newValue =
                                          readings['chiSoMoi'] ?? 0;
                                      return _buildMeterRow(
                                        oldValue.toString(),
                                        newValue.toString(),
                                        '${(newValue - oldValue).toString()} ${service.donVi}',
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          _buildDetailRow(
                            service.tenDichVu,
                            NumberFormat.currency(
                              locale: 'vi_VN',
                              symbol: 'đ',
                            ).format(dichVu.thanhTien),
                            subtitle: service.donVi == 'kWh' ||
                                    service.donVi == 'm³'
                                ? 'Đơn giá: ${NumberFormat.currency(
                                    locale: 'vi_VN',
                                    symbol: 'đ',
                                  ).format(service.gia)}/${service.donVi}'
                                : 'Số lượng: ${dichVu.soLuong} ${service.donVi}',
                          ),
                          const Divider(),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tổng tiền
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildDetailRow(
                      'Tổng tiền',
                      NumberFormat.currency(
                        locale: 'vi_VN',
                        symbol: 'đ',
                      ).format(bill.tongTien),
                      titleStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      valueStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: bill.trangThai == 'chuaThanhToan'
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => _showPaymentMethodDialog(bill.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Thanh toán',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildDetailRow(
    String title,
    String value, {
    String? subtitle,
    TextStyle? titleStyle,
    TextStyle? valueStyle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: titleStyle ??
                      const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          Text(
            value,
            style: valueStyle ??
                const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tiền mặt',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: selectedMethod.value ==
                                                    'tienMat'
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Chuyển khoản',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: selectedMethod.value ==
                                                    'chuyenKhoan'
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
                      billId, 'chuyenKhoan', false); // false: chờ xác nhận
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

  Widget _buildMeterRow(
    String oldValue,
    String newValue,
    String consumption, {
    bool isHeader = false,
  }) {
    final style = isHeader
        ? const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          )
        : const TextStyle(
            fontWeight: FontWeight.w500,
          );

    return Row(
      children: [
        Expanded(
          child: Text(oldValue, style: style),
        ),
        Expanded(
          child: Text(newValue, style: style),
        ),
        Expanded(
          child: Text(consumption, style: style),
        ),
      ],
    );
  }
}
