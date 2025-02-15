import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/rooms_landlord_controller.dart';
import '../../bindings/room_service_binding.dart';
import 'add_room_landlord_view.dart';
import 'update_service_landlord_view.dart';
import 'update_tenant_view__landlord.dart';
import '../../bindings/room_tenant_binding.dart';

class RoomsLandlordView extends GetView<RoomsLandlordController> {
  const RoomsLandlordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Quản Lý Phòng'),
            Obx(() => Text(
                  '${controller.filteredRooms.length} ${controller.filterText.toLowerCase()}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.normal,
                  ),
                )),
          ],
        ),
        actions: [
          // Nút thêm phòng
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => Get.to(() => AddRoomLandlordView()),
          ),
          // Nút filter
          PopupMenuButton(
            icon: const Icon(Icons.filter_list),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Row(
                  children: [
                    Icon(Icons.all_inclusive),
                    SizedBox(width: 8),
                    Text('Tất cả phòng'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'empty',
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline),
                    SizedBox(width: 8),
                    Text('Phòng trống'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'rented',
                child: Row(
                  children: [
                    Icon(Icons.people_outline),
                    SizedBox(width: 8),
                    Text('Đang cho thuê'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'maintenance',
                child: Row(
                  children: [
                    Icon(Icons.build_circle_outlined),
                    SizedBox(width: 8),
                    Text('Đang sửa chữa'),
                  ],
                ),
              ),
            ],
            onSelected: controller.updateFilter,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.filteredRooms.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.meeting_room_outlined,
                  size: 80,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  controller.rooms.isEmpty 
                      ? 'Chưa có phòng nào'
                      : 'Không tìm thấy phòng nào',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.rooms.isEmpty
                      ? 'Bắt đầu bằng việc thêm phòng mới'
                      : 'Thử chọn bộ lọc khác',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
                if (controller.rooms.isEmpty) ...[
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Get.to(() => AddRoomLandlordView()),
                    icon: const Icon(Icons.add),
                    label: const Text('Thêm Phòng'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.filteredRooms.length,
          itemBuilder: (context, index) {
            final room = controller.filteredRooms[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Room Status Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: controller.getRoomStatusColor(room.trangThai).withOpacity(0.1),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: controller.getRoomStatusColor(room.trangThai).withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            controller.getRoomStatusIcon(room.trangThai),
                            color: controller.getRoomStatusColor(room.trangThai),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.getRoomStatusText(room.trangThai),
                              style: TextStyle(
                                color: controller.getRoomStatusColor(room.trangThai),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (room.trangThai == 'daThue')
                              Text(
                                '${room.nguoiThueHienTai.length} người',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                          ],
                        ),
                        const Spacer(),
                        PopupMenuButton(
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.grey.shade700,
                          ),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 20),
                                  SizedBox(width: 8),
                                  Text('Chỉnh sửa'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red, size: 20),
                                  SizedBox(width: 8),
                                  Text('Xóa', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'delete') {
                              _showDeleteConfirmDialog(context, room);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  // Room Info
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Phòng ${room.soPhong}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'Tầng ${room.tang}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.blue.shade700,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    controller.getLoaiPhongText(room.loaiPhong),
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${room.giaThue.toStringAsFixed(0)}đ',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                const Text(
                                  'mỗi tháng',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Room Details
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildInfoItem(
                                icon: Icons.square_foot,
                                label: 'Diện tích',
                                value: '${room.dienTich}m²',
                              ),
                              _buildInfoItem(
                                icon: Icons.attach_money,
                                label: 'Tiền cọc',
                                value: '${room.tienCoc.toStringAsFixed(0)}đ',
                              ),
                              _buildInfoItem(
                                icon: Icons.people,
                                label: 'Tối đa',
                                value: controller.getSoNguoiToiDa(room.loaiPhong),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => Get.to(
                                  () => const UpdateServiceLandlordView(),
                                  binding: RoomServiceBinding(room),
                                ),
                                icon: const Icon(Icons.home_repair_service),
                                label: const Text('Dịch vụ'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => Get.to(
                                  () => const UpdateTenantLandlordView(),
                                  binding: RoomTenantBinding(room),
                                ),
                                icon: const Icon(Icons.people),
                                label: const Text('Người thuê'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Future<void> _showDeleteConfirmDialog(BuildContext context, dynamic room) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa phòng ${room.soPhong}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await controller.deleteRoom(room.id);
                Get.back();
              } catch (e) {
                // Error is already handled in controller
              }
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
