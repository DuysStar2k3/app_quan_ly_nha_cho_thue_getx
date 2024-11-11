import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../controllers/tenant_page_controller.dart';
import '../../../../routes/app_pages.dart';
import '../../../../core/theme/app_colors.dart';

class SettingsView extends GetView<TenantPageController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Thông tin cá nhân
          _buildSection(
            icon: Icons.person_outline,
            title: 'Thông tin cá nhân',
            children: [
              _buildMenuItem(
                icon: Icons.account_circle_outlined,
                title: 'Hồ sơ của tôi',
                subtitle: 'Xem và chỉnh sửa thông tin cá nhân',
                onTap: () {
                  // TODO: Navigate to profile page
                },
              ),
              _buildMenuItem(
                icon: Icons.phone_outlined,
                title: 'Số điện thoại',
                subtitle: controller.currentUser?.soDienThoai ?? '',
                onTap: () {
                  // TODO: Navigate to phone number page
                },
              ),
              _buildMenuItem(
                icon: Icons.location_on_outlined,
                title: 'Địa chỉ',
                subtitle: controller.currentUser?.diaChi.diaChiDayDu ?? '',
                onTap: () {
                  // TODO: Navigate to address page
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Thanh toán
          _buildSection(
            icon: Icons.payment_outlined,
            title: 'Thanh toán',
            children: [
              _buildMenuItem(
                icon: Icons.history,
                title: 'Lịch sử thanh toán',
                subtitle: 'Xem lịch sử các giao dịch',
                onTap: () => Get.toNamed(Routes.TENANT_PAYMENT),
              ),
              _buildMenuItem(
                icon: Icons.account_balance_outlined,
                title: 'Phương thức thanh toán',
                subtitle: 'Quản lý phương thức thanh toán',
                onTap: () => _showPaymentMethodsDialog(),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Thông báo & Bảo mật
          _buildSection(
            icon: Icons.security_outlined,
            title: 'Thông báo & Bảo mật',
            children: [
              _buildMenuItem(
                icon: Icons.notifications_outlined,
                title: 'Cài đặt thông báo',
                subtitle: 'Tùy chỉnh thông báo',
                onTap: () {
                  // TODO: Navigate to notification settings
                },
              ),
              _buildMenuItem(
                icon: Icons.lock_outline,
                title: 'Đổi mật khẩu',
                subtitle: 'Thay đổi mật khẩu đăng nhập',
                onTap: () {
                  // TODO: Navigate to change password
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Hỗ trợ
          _buildSection(
            icon: Icons.help_outline,
            title: 'Hỗ trợ',
            children: [
              _buildMenuItem(
                icon: Icons.help_outline,
                title: 'Trung tâm trợ giúp',
                subtitle: 'Câu hỏi thường gặp và hướng dẫn',
                onTap: () {
                  // TODO: Navigate to help center
                },
              ),
              _buildMenuItem(
                icon: Icons.info_outline,
                title: 'Về ứng dụng',
                subtitle: 'Phiên bản 1.0.0',
                onTap: () {
                  // TODO: Show app info
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Đăng xuất
          _buildSection(
            icon: Icons.logout,
            title: 'Tài khoản',
            children: [
              _buildMenuItem(
                icon: Icons.logout,
                title: 'Đăng xuất',
                subtitle: 'Đăng xuất khỏi tài khoản',
                color: Colors.red,
                onTap: () => _showLogoutConfirmDialog(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (color ?? Colors.grey[600])!.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color ?? Colors.grey[600],
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: color ?? Colors.grey[800],
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Xác nhận đăng xuất'),
        content: const Text('Bạn có chắc muốn đăng xuất khỏi tài khoản?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.find<AuthRepository>().signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethodsDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Phương thức thanh toán',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildPaymentMethodItem(
                icon: Icons.money,
                title: 'Tiền mặt',
                subtitle: 'Thanh toán trực tiếp cho chủ trọ',
                onTap: () {
                  Get.back();
                  Get.snackbar(
                    'Thông báo',
                    'Đã chọn phương thức thanh toán tiền mặt',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
              const Divider(),
              _buildPaymentMethodItem(
                icon: Icons.account_balance,
                title: 'Chuyển khoản ngân hàng',
                subtitle: 'Chuyển khoản qua tài khoản ngân hàng',
                onTap: () {
                  Get.back();
                  _showBankAccountDialog();
                },
              ),
              const Divider(),
              _buildPaymentMethodItem(
                icon: Icons.qr_code,
                title: 'Quét mã QR',
                subtitle: 'Quét mã QR để thanh toán',
                onTap: () {
                  Get.back();
                  _showQRCodeDialog();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }

  void _showBankAccountDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Thông tin tài khoản',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _buildBankInfo('Ngân hàng', 'Vietcombank'),
                    const Divider(),
                    _buildBankInfo('Số tài khoản', '1234567890'),
                    const Divider(),
                    _buildBankInfo('Chủ tài khoản', 'NGUYEN VAN A'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // TODO: Copy thông tin tài khoản
                  Get.back();
                  Get.snackbar(
                    'Thông báo',
                    'Đã sao chép thông tin tài khoản',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Sao chép thông tin'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBankInfo(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showQRCodeDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Quét mã QR',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    Icons.qr_code_2,
                    size: 150,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Sử dụng ứng dụng ngân hàng để quét mã',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
