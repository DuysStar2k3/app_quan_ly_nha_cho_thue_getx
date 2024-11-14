import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quan_ly_nha_thue/app/data/repositories/auth_repository.dart';
import '../../../../routes/app_pages.dart';
import '../../controllers/tenant_page_controller.dart';

class SettingsTenantView extends GetView<TenantPageController> {
  const SettingsTenantView({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thông tin tài khoản
              _buildSectionHeader('Thông tin tài khoản'),
              _buildProfileCard(),
              const SizedBox(height: 24),

              // Cài đặt ứng dụng
              _buildSectionHeader('Cài đặt ứng dụng'),
              _buildSettingsCard(),
              const SizedBox(height: 24),

              // Thông tin khác
              _buildSectionHeader('Khác'),
              _buildOtherCard(),
              const SizedBox(height: 32),

              // Nút đăng xuất
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
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
                              _handleSignOut(
                                  context); // Gọi hàm xử lý đăng xuất
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildSettingTile(
            icon: Icons.person_outline,
            title: 'Thông tin cá nhân',
            onTap: () {
              Get.toNamed(Routes.TENANT_PROFILE_VIEW);
            },
          ),
          _buildDivider(),
          _buildSettingTile(
            icon: Icons.history,
            title: 'Lịch sử thanh toán',
            onTap: () {
              Get.toNamed(Routes.TENANT_PAYMENT_VIEW);
            },
          ),
          _buildDivider(),
          _buildSettingTile(
            icon: Icons.assignment,
            title: 'Hợp đồng của tôi',
            onTap: () {
              Get.toNamed(Routes.TENANT_CONTRACTS);
            },
          ),
          _buildDivider(),
          _buildSettingTile(
            icon: Icons.lock_outline,
            title: 'Đổi mật khẩu',
            onTap: () {
              // TODO: Điều hướng đến trang đổi mật khẩu
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildSettingTile(
            icon: Icons.notifications_outlined,
            title: 'Thông báo',
            trailing: Switch(
              value: true, // TODO: Bind với controller
              onChanged: (value) {
                // TODO: Xử lý bật/tắt thông báo
              },
            ),
          ),
          _buildDivider(),
          _buildSettingTile(
            icon: Icons.language_outlined,
            title: 'Ngôn ngữ',
            subtitle: 'Tiếng Việt',
            onTap: () {
              // TODO: Mở dialog chọn ngôn ngữ
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOtherCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildSettingTile(
            icon: Icons.help_outline,
            title: 'Trợ giúp & Hỗ trợ',
            onTap: () {
              // TODO: Điều hướng đến trang trợ giúp
            },
          ),
          _buildDivider(),
          _buildSettingTile(
            icon: Icons.info_outline,
            title: 'Về ứng dụng',
            onTap: () {
              // TODO: Hiển thị thông tin ứng dụng
            },
          ),
          _buildDivider(),
          _buildSettingTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Chính sách bảo mật',
            onTap: () {
              // TODO: Điều hướng đến trang chính sách
            },
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
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing:
          trailing ?? const Icon(Icons.chevron_right, color: Colors.black54),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade200,
      indent: 16,
      endIndent: 16,
    );
  }
}
