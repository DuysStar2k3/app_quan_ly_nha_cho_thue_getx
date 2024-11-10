import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/landlord_controller.dart';
import './rooms_view/rooms_view.dart';
import './home_view/home_view.dart';
import './settings_view/settings_view.dart';
import './services_view/services_view.dart';
import 'tenant_view/tenant_view.dart';

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
            return  HomeView();
          case 1:
            return const RoomsView();
          case 2:
            return const ServicesView();
          case 3:
            return const TenantView();
          case 4:
            return const SettingsView();
          default:
            return  HomeView();
        }
      }),
      bottomNavigationBar: Obx(() => NavigationBar(
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: controller.changeTab,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: 'Tổng quan',
              ),
              NavigationDestination(
                icon: Icon(Icons.meeting_room_outlined),
                selectedIcon: Icon(Icons.meeting_room),
                label: 'Phòng trọ',
              ),
              NavigationDestination(
                icon: Icon(Icons.home_repair_service_outlined),
                selectedIcon: Icon(Icons.home_repair_service),
                label: 'Dịch vụ',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Thành viên',
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
