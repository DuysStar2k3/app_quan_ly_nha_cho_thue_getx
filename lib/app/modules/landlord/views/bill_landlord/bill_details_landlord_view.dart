import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/hoa_don_model.dart';
import 'controller/bill_landlord_controller.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:intl/intl.dart';

class BillDetailsLandlordView extends GetView<BillLandlordController> {
  final HoaDonModel bill;
  const BillDetailsLandlordView({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    final room = controller.getRoomInfo(bill.phongId);
    if (room == null) return const Scaffold();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết hóa đơn'),
        actions: [
          if (bill.trangThai == 'chuaThanhToan')
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: () {
                // TODO: Thêm chức năng xuất PDF
              },
            ),
        ],
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
                            color: _getStatusColor(bill.trangThai)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getStatusText(bill.trangThai),
                            style: TextStyle(
                              color: _getStatusColor(bill.trangThai),
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
                      print(dichVu.toJson());
                      final service =
                          controller.getServiceInfo(dichVu.dichVuId);
                      if (service == null) return const SizedBox.shrink();

                      return Column(
                        children: [
                          if (service.donVi == 'kWh' ||
                              service.donVi == 'm³') ...[
                            // Hiển thị chỉ số công tơ
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
                                      print(snapshot.data?.toString());
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
      bottomNavigationBar: bill.trangThai == 'choXacNhan'
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
                onPressed: () => _showConfirmDialog(bill.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Xác nhận thanh toán',
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

  // Thêm widget hiển thị chỉ số công tơ
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

  void _showConfirmDialog(String billId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Xác nhận thanh toán'),
        content: const Text(
            'Bạn có chắc muốn xác nhận đã nhận được tiền thanh toán?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.confirmPayment(billId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }
}
