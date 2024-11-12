import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/landlord_controller.dart';
import 'chat_landlord/chat_landlord_view.dart';
import 'home_landlord_view/home_landlord_view.dart';
import 'rooms_landlord_view/rooms_landlord_view.dart';
import 'tenant_landlord_view/tenant_landlord_view.dart';
import 'settings_landlord_view/settings_landlord_view.dart';
import '../../../core/theme/app_colors.dart';

class LandlordPage extends GetView<LandlordController> {
  const LandlordPage({super.key});

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
            return HomeLandlordView();
          case 1:
            return const RoomsLandlordView();
          case 2:
            return const TenantLandlordView();
          case 3:
            return const SettingsLandlordView();
          case 4:
            return const ChatLandlordView();
          default:
            return HomeLandlordView();
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
                      icon: Icons.dashboard_outlined,
                      selectedIcon: Icons.dashboard_rounded,
                      label: 'Tổng quan',
                    ),
                    _buildNavItem(
                      index: 1,
                      icon: Icons.meeting_room_outlined,
                      selectedIcon: Icons.meeting_room_rounded,
                      label: 'Phòng',
                    ),
                    _buildNavItem(
                      index: 2,
                      icon: Icons.people_outline,
                      selectedIcon: Icons.people_rounded,
                      label: 'Người thuê',
                    ),
                    _buildNavItem(
                      index: 4,
                      icon: Icons.chat_outlined,
                      selectedIcon: Icons.chat_rounded,
                      label: 'Chat',
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
