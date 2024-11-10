import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tenant_controller.dart';
import 'home_view/home_view.dart';
import 'bills_view/bills_view.dart';
import 'services_view/services_view.dart';
import 'settings_view/settings_view.dart';
import '../../../core/theme/app_colors.dart';

class TenantPage extends GetView<TenantController> {
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
            return const HomeView();
          case 1:
            return const BillsView();
          case 2:
            return const ServicesView();
          case 3:
            return const SettingsView();
          default:
            return const HomeView();
        }
      }),
      bottomNavigationBar: Obx(() => NavigationBar(
        selectedIndex: controller.selectedIndex.value,
        onDestinationSelected: controller.changeTab,
        backgroundColor: AppColors.surface,
        elevation: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Tổng quan',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Hóa đơn',
          ),
          NavigationDestination(
            icon: Icon(Icons.home_repair_service_outlined),
            selectedIcon: Icon(Icons.home_repair_service),
            label: 'Dịch vụ',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Cài đặt',
          ),
        ],
      )),
    );
  }
} 