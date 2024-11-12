import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/home_tenant_view/home-tenant_view.dart';
import '../controllers/tenant_page_controller.dart';
import 'services_tenant_view/services_tenant_view.dart';
import 'settings_tenant_view/settings_tenant_view.dart';
import '../../../core/theme/app_colors.dart';
import 'bill_tenant/bill_tenant_view.dart';

class TenantPage extends GetView<TenantPageController> {
  const TenantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        switch (controller.selectedIndex.value) {
          case 0:
            return const HomeTenantView();
          case 1:
            return const BillTenantView();
          case 2:
            return const ServicesTenantView();
          case 3:
            return const SettingsTenantView();
          default:
            return const HomeTenantView();
        }
      }),
      bottomNavigationBar: Obx(() => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      index: 0,
                      icon: Icons.home_outlined,
                      selectedIcon: Icons.home_rounded,
                      label: 'Trang chủ',
                    ),
                    _buildNavItem(
                      index: 1,
                      icon: Icons.receipt_long_outlined,
                      selectedIcon: Icons.receipt_long_rounded,
                      label: 'Hóa đơn',
                    ),
                    _buildNavItem(
                      index: 2,
                      icon: Icons.home_repair_service_outlined,
                      selectedIcon: Icons.home_repair_service_rounded,
                      label: 'Dịch vụ',
                    ),
                    _buildNavItem(
                      index: 3,
                      icon: Icons.settings_outlined,
                      selectedIcon: Icons.settings_rounded,
                      label: 'Cài đặt',
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
  }) {
    final isSelected = controller.selectedIndex.value == index;
    return InkWell(
      onTap: () => controller.changeTab(index),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? AppColors.primary : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : Colors.grey,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
