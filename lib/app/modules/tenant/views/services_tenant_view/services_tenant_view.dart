import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/service_tenant_controller.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:intl/intl.dart';

class ServicesTenantView extends GetView<ServiceTenantController> {
  const ServicesTenantView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dịch Vụ'),
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshData,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.currentRoom.value == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.home_outlined,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Bạn chưa thuê phòng nào',
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

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Tiện ích hiện có
              const Text(
                'Tiện ích phòng',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.amenities.map((amenity) {
                  return _buildAmenityChip(amenity);
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Dịch vụ đang sử dụng
              const Text(
                'Dịch vụ đang sử dụng',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.services.length,
                itemBuilder: (context, index) {
                  final service = controller.services[index];
                  return Card(
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.home_repair_service,
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text(service.tenDichVu),
                      subtitle: Text(
                        NumberFormat.currency(
                          locale: 'vi_VN',
                          symbol: 'đ',
                        ).format(service.gia),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Đang sử dụng',
                          style: TextStyle(
                            color: AppColors.success,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        }),
      ),
      floatingActionButton: Obx(() {
        if (controller.currentRoom.value == null)
          return const SizedBox.shrink();

        return FloatingActionButton.extended(
          onPressed: () => _showServiceRequestDialog(context),
          icon: const Icon(Icons.add),
          label: const Text('Yêu cầu dịch vụ'),
        );
      }),
    );
  }

  Widget _buildAmenityChip(String amenity) {
    IconData getAmenityIcon() {
      switch (amenity.toLowerCase()) {
        case 'wifi':
          return Icons.wifi;
        case 'dieu_hoa':
          return Icons.ac_unit;
        case 'nong_lanh':
          return Icons.hot_tub;
        case 'tu_lanh':
          return Icons.kitchen;
        case 'may_giat':
          return Icons.local_laundry_service;
        case 'giuong':
          return Icons.bed;
        case 'tu_quan_ao':
          return Icons.door_sliding;
        case 'ban_ghe':
          return Icons.chair;
        default:
          return Icons.check_circle;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            getAmenityIcon(),
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Text(
            amenity,
            style: TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showServiceRequestDialog(BuildContext context) async {
    final serviceTypeController = TextEditingController();
    final descriptionController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yêu cầu dịch vụ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Loại dịch vụ',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'suaChua',
                  child: Text('Sửa chữa'),
                ),
                DropdownMenuItem(
                  value: 'veSinh',
                  child: Text('Vệ sinh'),
                ),
                DropdownMenuItem(
                  value: 'baoTri',
                  child: Text('Bảo trì'),
                ),
              ],
              onChanged: (value) {
                serviceTypeController.text = value ?? '';
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Mô tả',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (serviceTypeController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty) {
                controller.requestService(
                  serviceTypeController.text,
                  descriptionController.text,
                );
                Get.back();
              }
            },
            child: const Text('Gửi yêu cầu'),
          ),
        ],
      ),
    );
  }
}
