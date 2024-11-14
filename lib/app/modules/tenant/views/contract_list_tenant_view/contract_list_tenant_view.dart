import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';
import 'controller/contract_controller.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/phong_model.dart';
import '../../../../data/models/user_model.dart';

class ContractListTenantView extends GetView<ContractController> {
  const ContractListTenantView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hợp Đồng Của Tôi'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.contracts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.description_outlined,
                  size: 64,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Bạn chưa có hợp đồng nào',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.contracts.length,
          itemBuilder: (context, index) {
            final contract = controller.contracts[index];
            return FutureBuilder<PhongModel?>(
              future: controller.getRoom(contract.phongId),
              builder: (context, roomSnapshot) {
                if (!roomSnapshot.hasData) {
                  return const SizedBox.shrink();
                }

                final room = roomSnapshot.data!;

                return FutureBuilder<UserModel?>(
                  future: controller.getLandlord(contract.chuTroId),
                  builder: (context, landlordSnapshot) {
                    if (!landlordSnapshot.hasData) {
                      return const SizedBox.shrink();
                    }

                    final landlord = landlordSnapshot.data!;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(
                            Routes.TENANT_CONTRACT_DETAILS,
                            arguments: contract,
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: contract.conHieuLuc
                                          ? Colors.green.shade50
                                          : Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      contract.conHieuLuc
                                          ? 'Còn hiệu lực'
                                          : 'Hết hiệu lực',
                                      style: TextStyle(
                                        color: contract.conHieuLuc
                                            ? Colors.green.shade700
                                            : Colors.red.shade700,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Phòng ${room.soPhong}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow(
                                'Chủ trọ:',
                                landlord.ten,
                                Icons.person,
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                'Thời hạn:',
                                '${DateFormat('dd/MM/yyyy').format(contract.ngayBatDau)} - ${DateFormat('dd/MM/yyyy').format(contract.ngayKetThuc)}',
                                Icons.calendar_today,
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                'Giá thuê:',
                                '${NumberFormat('#,###').format(room.giaThue)}đ/tháng',
                                Icons.monetization_on,
                              ),
                              if (contract.conHieuLuc) ...[
                                const SizedBox(height: 16),
                                Text(
                                  'Còn ${contract.soNgayConLai} ngày',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      }),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
} 