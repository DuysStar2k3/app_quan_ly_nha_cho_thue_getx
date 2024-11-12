import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/dich_vu_model.dart';
import '../../../../data/models/phong_model.dart';
import '../../controllers/bill_landlord_controller.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'bill_details_landlord_view.dart';
import 'create_bill_landlord_view.dart';

class BillLandlordView extends GetView<BillLandlordController> {
  const BillLandlordView({super.key});

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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Get.to(() => const CreateBillLandlordView()),
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add),
          label: const Text('Tạo hóa đơn'),
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
                onTap: () => Get.to(() => BillDetailsLandlordView(bill: bill)),
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
                            decoration: const BoxDecoration(
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
                          if (!isPaid && bill.trangThai == 'chuaThanhToan')
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () =>
                                  _showDeleteConfirmDialog(bill.id),
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
                          if (bill.trangThai == 'choXacNhan')
                            ElevatedButton(
                              onPressed: () => _showConfirmDialog(bill.id),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                              child: const Text('Xác nhận'),
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

  void _showDeleteConfirmDialog(String billId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc muốn xóa hóa đơn này?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteBill(billId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
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

  Widget _buildServiceInput({
    required DichVuModel service,
    required PhongModel room,
    required TextEditingController quantityController,
    required TextEditingController oldValueController,
    required TextEditingController newValueController,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    service.tenDichVu,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  NumberFormat.currency(
                    locale: 'vi_VN',
                    symbol: 'đ',
                  ).format(service.gia),
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (service.donVi == 'kWh' || service.donVi == 'm³') ...[
              TextField(
                controller: oldValueController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Chỉ số cũ',
                  suffixText: service.donVi,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: newValueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Chỉ số mới',
                  suffixText: service.donVi,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) {
                  final newValue = double.tryParse(value) ?? 0;
                  final oldValue =
                      double.tryParse(oldValueController.text) ?? 0;
                  if (newValue > oldValue) {
                    quantityController.text = (newValue - oldValue).toString();
                  }
                },
              ),
            ] else if (service.donVi == 'người') ...[
              TextField(
                controller: quantityController
                  ..text = room.nguoiThueHienTai.length.toString(),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Số người',
                  suffixText: service.donVi,
                  border: const OutlineInputBorder(),
                ),
              ),
            ] else ...[
              TextField(
                controller: quantityController..text = '1',
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Số lượng',
                  suffixText: service.donVi,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
            const SizedBox(height: 8),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: quantityController,
              builder: (context, value, child) {
                final quantity = double.tryParse(value.text) ?? 0;
                final total = quantity * service.gia;
                return Text(
                  'Thành tiền: ${NumberFormat.currency(
                    locale: 'vi_VN',
                    symbol: 'đ',
                  ).format(total)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ],
        ),
      ),
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

  String _getEmptyMessage(String status) {
    switch (status) {
      case 'chuaThanhToan':
        return 'Không có hóa đơn chờ thanh toán';
      case 'choXacNhan':
        return 'Không có hóa đơn chờ xác nhận';
      case 'daThanhToan':
        return 'Không có hóa đơn đã thanh toán';
      default:
        return 'Không có hóa đơn nào';
    }
  }
}
