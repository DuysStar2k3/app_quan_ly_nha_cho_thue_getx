import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/phong_model.dart';
import '../../../../data/models/user_model.dart';
import '../../controllers/contract_controller.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:intl/intl.dart';

class ContractView extends GetView<ContractController> {
  const ContractView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hợp đồng'),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle),
                    SizedBox(width: 8),
                    Text('Đang hiệu lực'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cancel),
                    SizedBox(width: 8),
                    Text('Đã kết thúc'),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildContractsList(isActive: true),
            _buildContractsList(isActive: false),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showCreateContractDialog(context),
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add),
          label: const Text('Tạo hợp đồng'),
        ),
      ),
    );
  }

  Widget _buildContractsList({required bool isActive}) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final filteredContracts = controller.contracts
          .where((c) => c.trangThai == (isActive ? 'hieuLuc' : 'daKetThuc'))
          .toList();

      if (filteredContracts.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isActive ? Icons.description_outlined : Icons.cancel_outlined,
                size: 80,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 16),
              Text(
                isActive
                    ? 'Không có hợp đồng đang hiệu lực'
                    : 'Không có hợp đồng đã kết thúc',
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
          itemCount: filteredContracts.length,
          itemBuilder: (context, index) {
            final contract = filteredContracts[index];
            final room = controller.getRoomInfo(contract.phongId);
            final tenant = controller.getTenantInfo(contract.nguoiThueId);

            if (room == null || tenant == null) {
              return const SizedBox.shrink();
            }

            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () => _showContractDetails(contract),
                borderRadius: BorderRadius.circular(12),
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
                              color: isActive
                                  ? AppColors.primary.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              isActive
                                  ? Icons.description
                                  : Icons.cancel_outlined,
                              color: isActive ? AppColors.primary : Colors.red,
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
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  tenant.ten,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isActive)
                            IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () => _showContractOptions(contract),
                            ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoItem(
                            icon: Icons.calendar_today,
                            label: 'Ngày bắt đầu',
                            value: DateFormat('dd/MM/yyyy')
                                .format(contract.ngayBatDau),
                          ),
                          _buildInfoItem(
                            icon: Icons.calendar_today,
                            label: 'Ngày kết thúc',
                            value: DateFormat('dd/MM/yyyy')
                                .format(contract.ngayKetThuc),
                          ),
                          _buildInfoItem(
                            icon: Icons.access_time,
                            label: 'Thời hạn còn lại',
                            value: '${contract.soNgayConLai} ngày',
                            color: isActive ? Colors.green : Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    Color? color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  void _showCreateContractDialog(BuildContext context) {
    final selectedRoom = Rxn<PhongModel>();
    final selectedTenant = Rxn<UserModel>();
    final ngayBatDauController = TextEditingController();
    final ngayKetThucController = TextEditingController();

    // Lấy danh sách phòng có người thuê
    final rentedRooms = controller.rentedRooms;

    Get.dialog(
      AlertDialog(
        title: const Text('Tạo hợp đồng mới'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Chọn phòng
              DropdownButtonFormField<PhongModel>(
                decoration: const InputDecoration(
                  labelText: 'Chọn phòng',
                ),
                value: selectedRoom.value,
                items: rentedRooms.map((room) {
                  return DropdownMenuItem(
                    value: room,
                    child: Text('Phòng ${room.soPhong}'),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedRoom.value = value;
                  selectedTenant.value = null; // Reset selected tenant
                },
              ),
              const SizedBox(height: 16),

              // Chọn người thuê
              Obx(() => DropdownButtonFormField<UserModel>(
                    decoration: const InputDecoration(
                      labelText: 'Chọn người thuê',
                    ),
                    value: selectedTenant.value,
                    items: selectedRoom.value != null
                        ? controller
                            .getRoomTenants(selectedRoom.value!.id)
                            .map((tenant) {
                            return DropdownMenuItem(
                              value: tenant,
                              child: Text(tenant.ten),
                            );
                          }).toList()
                        : [],
                    onChanged: selectedRoom.value != null
                        ? (value) {
                            selectedTenant.value = value;
                          }
                        : null,
                  )),
              const SizedBox(height: 16),

              // Chọn ngày bắt đầu
              TextField(
                controller: ngayBatDauController,
                decoration: const InputDecoration(
                  labelText: 'Ngày bắt đầu',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    ngayBatDauController.text =
                        DateFormat('dd/MM/yyyy').format(date);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Chọn ngày kết thúc
              TextField(
                controller: ngayKetThucController,
                decoration: const InputDecoration(
                  labelText: 'Ngày kết thúc',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  if (ngayBatDauController.text.isEmpty) {
                    Get.snackbar(
                      'Lỗi',
                      'Vui lòng chọn ngày bắt đầu trước',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }
                  final startDate =
                      DateFormat('dd/MM/yyyy').parse(ngayBatDauController.text);
                  final date = await showDatePicker(
                    context: context,
                    initialDate: startDate.add(const Duration(days: 365)),
                    firstDate: startDate,
                    lastDate: startDate.add(const Duration(days: 730)),
                  );
                  if (date != null) {
                    ngayKetThucController.text =
                        DateFormat('dd/MM/yyyy').format(date);
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedRoom.value == null ||
                  selectedTenant.value == null ||
                  ngayBatDauController.text.isEmpty ||
                  ngayKetThucController.text.isEmpty) {
                Get.snackbar(
                  'Lỗi',
                  'Vui lòng điền đầy đủ thông tin',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              controller.createContract(
                phongId: selectedRoom.value!.id,
                nguoiThueId: selectedTenant.value!.uid,
                ngayBatDau:
                    DateFormat('dd/MM/yyyy').parse(ngayBatDauController.text),
                ngayKetThuc:
                    DateFormat('dd/MM/yyyy').parse(ngayKetThucController.text),
              );
              Get.back();
            },
            child: const Text('Tạo'),
          ),
        ],
      ),
    );
  }

  void _showContractOptions(dynamic contract) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.remove_red_eye),
              title: const Text('Xem chi tiết'),
              onTap: () {
                Get.back();
                _showContractDetails(contract);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.cancel,
                color: Colors.red,
              ),
              title: const Text(
                'Kết thúc hợp đồng',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Get.back();
                _showTerminateConfirmDialog(contract);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showTerminateConfirmDialog(dynamic contract) {
    Get.dialog(
      AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc muốn kết thúc hợp đồng này?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.terminateContract(contract.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Kết thúc'),
          ),
        ],
      ),
    );
  }

  void _showContractDetails(dynamic contract) {
    Get.dialog(
      Dialog(
        child: Container(
          width: Get.width * 0.9,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Chi tiết hợp đồng',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hiển thị nội dung hợp đồng với định dạng
                      Text(
                        contract.noiDung,
                        style: const TextStyle(height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Đóng'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => controller.exportContractPdf(contract.id),
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Xuất PDF'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
