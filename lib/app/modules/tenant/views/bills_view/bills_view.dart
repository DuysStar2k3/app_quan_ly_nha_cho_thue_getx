import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/tenant_controller.dart';
import '../../../../core/theme/app_colors.dart';

class BillsView extends GetView<TenantController> {
  const BillsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hóa Đơn'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5, // TODO: Replace with actual bills
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.receipt,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hóa đơn tháng ${3 - index}/2024',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Phòng 101',
                              style: TextStyle(
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getBillStatusColor(index).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getBillStatus(index),
                          style: TextStyle(
                            color: _getBillStatusColor(index),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  // Bill Details
                  _buildBillDetail(
                    label: 'Tiền phòng',
                    value: '3,500,000đ',
                  ),
                  const SizedBox(height: 8),
                  _buildBillDetail(
                    label: 'Tiền điện (250 kWh)',
                    value: '875,000đ',
                  ),
                  const SizedBox(height: 8),
                  _buildBillDetail(
                    label: 'Tiền nước (15 m³)',
                    value: '225,000đ',
                  ),
                  const SizedBox(height: 8),
                  _buildBillDetail(
                    label: 'Dịch vụ khác',
                    value: '200,000đ',
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tổng cộng',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '4,800,000đ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  if (index == 0) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Handle payment
                        },
                        child: const Text('Thanh toán ngay'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBillDetail({
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textLight,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _getBillStatus(int index) {
    switch (index) {
      case 0:
        return 'Chưa thanh toán';
      case 1:
        return 'Đang xử lý';
      default:
        return 'Đã thanh toán';
    }
  }

  Color _getBillStatusColor(int index) {
    switch (index) {
      case 0:
        return AppColors.error;
      case 1:
        return AppColors.warning;
      default:
        return AppColors.success;
    }
  }
} 