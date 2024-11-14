import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/pdf_helper.dart';
import '../../../../data/models/hop_dong_model.dart';
import '../../../../data/models/phong_model.dart';
import '../../../../data/models/user_model.dart';
import 'controller/contract_controller.dart';

class ContractDetailsTenantView extends StatelessWidget {
  final HopDongModel contract;

  const ContractDetailsTenantView({
    super.key,
    required this.contract,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi Tiết Hợp Đồng'),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await PdfHelper.generateContractPdf(
                  noiDung: contract.noiDung,
                  tenHopDong: 'Hop-Dong-Thue-Phong',
                );
              } catch (e) {
                Get.snackbar(
                  'Lỗi',
                  'Không thể tải hợp đồng: $e',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.error.withOpacity(0.1),
                  colorText: AppColors.error,
                );
              }
            },
            icon: const Icon(Icons.download),
            tooltip: 'Tải PDF',
          ),
        ],
      ),
      body: FutureBuilder(
        future: Future.wait([
          Get.find<ContractController>().getRoom(contract.phongId),
          Get.find<ContractController>().getLandlord(contract.chuTroId),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final room = snapshot.data![0] as PhongModel;
          final landlord = snapshot.data![1] as UserModel;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thông tin cơ bản
                _buildSection(
                  title: 'Thông Tin Cơ Bản',
                  child: Column(
                    children: [
                      _buildInfoRow('Số phòng:', room.soPhong),
                      _buildInfoRow('Diện tích:', '${room.dienTich} m²'),
                      _buildInfoRow(
                        'Giá thuê:',
                        '${NumberFormat('#,###').format(room.giaThue)}đ/tháng',
                      ),
                      _buildInfoRow(
                        'Tiền cọc:',
                        '${NumberFormat('#,###').format(room.tienCoc)}đ',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Thông tin chủ trọ
                _buildSection(
                  title: 'Thông Tin Chủ Trọ',
                  child: Column(
                    children: [
                      _buildInfoRow('Họ tên:', landlord.ten),
                      _buildInfoRow('Số điện thoại:', landlord.soDienThoai),
                      _buildInfoRow('Địa chỉ:', landlord.diaChi.diaChiDayDu),
                      if (landlord.cmnd != null)
                        _buildInfoRow('CMND/CCCD:', landlord.cmnd!),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Thời hạn hợp đồng
                _buildSection(
                  title: 'Thời Hạn Hợp Đồng',
                  child: Column(
                    children: [
                      _buildInfoRow(
                        'Ngày bắt đầu:',
                        DateFormat('dd/MM/yyyy').format(contract.ngayBatDau),
                      ),
                      _buildInfoRow(
                        'Ngày kết thúc:',
                        DateFormat('dd/MM/yyyy').format(contract.ngayKetThuc),
                      ),
                      if (contract.conHieuLuc) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Còn ${contract.soNgayConLai} ngày',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Nội dung hợp đồng
                _buildSection(
                  title: 'Nội Dung Hợp Đồng',
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      contract.noiDung,
                      style: const TextStyle(height: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
