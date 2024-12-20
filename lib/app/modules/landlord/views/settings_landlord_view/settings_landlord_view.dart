import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quan_ly_nha_thue/app/data/repositories/auth_repository.dart';
import '../../bindings/edit_profile_binding.dart';
import '../../controllers/landlord_controller.dart';
import 'edit_profile_landlord_view.dart';

class SettingsLandlordView extends GetView<LandlordController> {
  const SettingsLandlordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài Đặt'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Card
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
                                'Chủ Trọ',
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
                          () => EditProfileLandlordView(),
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

          // Settings Section
          _buildSectionHeader('Cài đặt chung', Icons.settings_outlined),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildSettingTile(
                  icon: Icons.notifications_outlined,
                  title: 'Thông báo',
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {
                      // TODO: Toggle notifications
                    },
                  ),
                ),
                _buildDivider(),
                _buildSettingTile(
                  icon: Icons.language,
                  title: 'Ngôn ngữ',
                  subtitle: 'Tiếng Việt',
                ),
                _buildDivider(),
                _buildSettingTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Giao diện',
                  subtitle: 'Sáng',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Security Section
          _buildSectionHeader('Bảo mật', Icons.security),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildSettingTile(
                  icon: Icons.lock_outline,
                  title: 'Đổi mật khẩu',
                ),
                _buildDivider(),
                _buildSettingTile(
                  icon: Icons.fingerprint,
                  title: 'Xác thực sinh trắc học',
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {
                      // TODO: Toggle biometric auth
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Logout Button
          ElevatedButton.icon(
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  title: const Text('Xác nhận'),
                  content: const Text('Bạn có chắc muốn đăng xuất?'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Hủy'),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back(); // Đóng dialog xác nhận
                        _handleSignOut(context); // Gọi hàm xử lý đăng xuất
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Đăng xuất'),
                    ),
                  ],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[50],
              foregroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.logout),
            label: const Text(
              'Đăng xuất',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 32),

          // App Version
          Center(
            child: Text(
              'Phiên bản 1.0.0',
              style: TextStyle(
                color: Colors.grey.shade600,
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

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey.shade700,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Colors.grey.shade700,
          size: 20,
        ),
      ),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: trailing == null ? () {} : null,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: Colors.grey.shade200,
    );
  }

  Future<void> _handleSignOut(BuildContext context) async {
    // Hiển thị overlay loading
    showDialog(
      context: context,
      barrierDismissible: false, // Không cho phép tắt bằng cách nhấn ra ngoài
      builder: (BuildContext context) {
        return PopScope(
          canPop: false, // Không cho phép back
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Đang đăng xuất...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // Delay 2 giây
    await Future.delayed(const Duration(seconds: 2));

    // Thực hiện đăng xuất
    await Get.find<AuthRepository>().signOut();
  }
}
