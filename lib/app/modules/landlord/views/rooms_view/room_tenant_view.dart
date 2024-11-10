import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/tenant_controller.dart';
import '../../../../core/theme/app_colors.dart';

class RoomTenantView extends GetView<TenantController> {
  const RoomTenantView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phòng ${controller.room.soPhong}'),
            Text(
              'Quản lý người thuê',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textLight,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Room Info Card
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.meeting_room,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Phòng ${controller.room.soPhong}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Tầng ${controller.room.tang}',
                                style: TextStyle(
                                  color: AppColors.textLight,
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
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.people,
                                size: 16,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${controller.tenants.length} người',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildRoomInfo(
                            icon: Icons.square_foot,
                            label: 'Diện tích',
                            value: '${controller.room.dienTich}m²',
                          ),
                          _buildRoomInfo(
                            icon: Icons.attach_money,
                            label: 'Giá thuê',
                            value: '${controller.room.giaThue.toStringAsFixed(0)}đ',
                          ),
                          _buildRoomInfo(
                            icon: Icons.people_outline,
                            label: 'Tối đa',
                            value: '4 người',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tenants List
            Expanded(
              child: controller.tenants.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64,
                            color: AppColors.textLight,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Chưa có người thuê',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Thêm người thuê để quản lý phòng',
                            style: TextStyle(
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.tenants.length,
                      itemBuilder: (context, index) {
                        final tenant = controller.tenants[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.primary.withOpacity(0.1),
                              child: Icon(
                                Icons.person,
                                color: AppColors.primary,
                              ),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    tenant.ten,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Đang thuê',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                _buildTenantInfo(
                                  icon: Icons.phone,
                                  value: tenant.soDienThoai,
                                ),
                                const SizedBox(height: 4),
                                _buildTenantInfo(
                                  icon: Icons.email,
                                  value: tenant.email,
                                ),
                                if (tenant.diaChi.diaChiDayDu.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  _buildTenantInfo(
                                    icon: Icons.location_on,
                                    value: tenant.diaChi.diaChiDayDu,
                                  ),
                                ],
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () => _showDeleteConfirmDialog(context, tenant),
                              icon: Icon(
                                Icons.delete_outline,
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTenantDialog(context),
        icon: const Icon(Icons.person_add),
        label: const Text('Thêm Người Thuê'),
      ),
    );
  }

  Widget _buildRoomInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.textLight, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTenantInfo({
    required IconData icon,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textLight,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: AppColors.textLight,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showAddTenantDialog(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    final tenController = TextEditingController();
    final emailController = TextEditingController();
    final soDienThoaiController = TextEditingController();
    final diaChiController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm Người Thuê'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: tenController,
                  decoration: const InputDecoration(
                    labelText: 'Họ và tên',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập họ tên';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập email';
                    }
                    if (!GetUtils.isEmail(value)) {
                      return 'Email không hợp lệ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: soDienThoaiController,
                  decoration: const InputDecoration(
                    labelText: 'Số điện thoại',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số điện tho���i';
                    }
                    if (!GetUtils.isPhoneNumber(value)) {
                      return 'Số điện thoại không hợp lệ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: diaChiController,
                  decoration: const InputDecoration(
                    labelText: 'Địa chỉ',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                controller.addTenant(
                  ten: tenController.text.trim(),
                  email: emailController.text.trim(),
                  soDienThoai: soDienThoaiController.text.trim(),
                  diaChi: {
                    'soNha': '',
                    'phuong': '',
                    'quan': '',
                    'thanhPho': diaChiController.text.trim(),
                  },
                );
                Get.back();
              }
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmDialog(BuildContext context, dynamic tenant) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa ${tenant.ten} khỏi phòng?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.removeTenant(tenant.uid);
              Get.back();
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
} 