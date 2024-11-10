import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/controllers/auth_controller.dart';
import '../../../landlord/bindings/edit_profile_binding.dart';
import '../../../landlord/views/settings_view/edit_profile_view.dart';
import '../../controllers/tenant_controller.dart';
import '../../../../core/theme/app_colors.dart';

class SettingsView extends GetView<TenantController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài Đặt'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Thông tin tài khoản
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Avatar and Name
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blue.shade100,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.blue.shade50,
                          child: Icon(
                            Icons.person,
                            size: 35,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() => Text(
                                  controller.currentUser?.ten ??
                                      'Chưa cập nhật',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Chủ trọ',
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Get.to(
                          () => EditProfileView(),
                          binding: EditProfileBinding(),
                        ),
                        icon: const Icon(Icons.edit_outlined),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Contact Info
                  _buildContactInfo(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: controller.currentUser?.email ?? 'Chưa cập nhật',
                  ),
                  const SizedBox(height: 16),
                  _buildContactInfo(
                    icon: Icons.phone_outlined,
                    label: 'Số điện thoại',
                    value:
                        controller.currentUser?.soDienThoai ?? 'Chưa cập nhật',
                  ),
                  const SizedBox(height: 16),
                  _buildContactInfo(
                    icon: Icons.location_on_outlined,
                    label: 'Địa chỉ',
                    value: controller.currentUser?.diaChi.diaChiDayDu ??
                        'Chưa cập nhật',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Cài đặt chung
          Card(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.settings, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Cài đặt chung',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text('Thông báo'),
                  trailing: Switch(
                    value: true, // TODO: Get from settings
                    onChanged: (value) {
                      // TODO: Toggle notifications
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Ngôn ngữ'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Change language
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.dark_mode_outlined),
                  title: const Text('Giao diện'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Change theme
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Bảo mật
          Card(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.security, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Bảo mật',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('Đổi mật khẩu'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Change password
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.fingerprint),
                  title: const Text('Xác thực sinh trắc học'),
                  trailing: Switch(
                    value: false, // TODO: Get from settings
                    onChanged: (value) {
                      // TODO: Toggle biometric auth
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Đăng xuất
          Card(
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: AppColors.error,
              ),
              title: Text(
                'Đăng xuất',
                style: TextStyle(
                  color: AppColors.error,
                ),
              ),
              onTap: () {
                _showLogoutConfirmDialog(context);
              },
            ),
          ),
          const SizedBox(height: 32),

          // Phiên bản
          Center(
            child: Text(
              'Phiên bản 1.0.0',
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildContactInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.blue.shade700,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
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
          ),
        ),
      ],
    );
  }

  Future<void> _showLogoutConfirmDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận đăng xuất'),
        content: const Text('Bạn có chắc muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Hủy',
              style: TextStyle(color: AppColors.textLight),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await Get.find<AuthController>().signOut();
    }
  }
}
