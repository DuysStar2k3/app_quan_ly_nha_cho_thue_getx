import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/phong_model.dart';
import 'controller/room_search_tenant_controller.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:intl/intl.dart';

class RoomSearchView extends GetView<RoomSearchTenantController> {
  const RoomSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm Phòng'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm phòng...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                _buildFilterChip(
                  label: 'Giá: Thấp - Cao',
                  isSelected: controller.sortByPrice.value,
                  onSelected: controller.toggleSortByPrice,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Còn trống',
                  isSelected: controller.showOnlyAvailable.value,
                  onSelected: controller.toggleShowOnlyAvailable,
                ),
                const SizedBox(width: 8),
                _buildPriceRangeFilter(),
              ],
            ),
          ),

          // Room List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.rooms.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Không tìm thấy phòng nào',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshRooms,
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: controller.rooms.length,
                  itemBuilder: (context, index) {
                    final room = controller.rooms[index];
                    return _buildRoomCard(room);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required Function(bool) onSelected,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  Widget _buildPriceRangeFilter() {
    return ActionChip(
      label: Text(
        'Giá: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(controller.minPrice.value)} - '
        '${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(controller.maxPrice.value)}',
      ),
      onPressed: () => _showPriceRangeDialog(),
      avatar: const Icon(Icons.monetization_on),
    );
  }

  void _showPriceRangeDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Chọn khoảng giá'),
        content: SizedBox(
          height: 100,
          child: Column(
            children: [
              Obx(() => RangeSlider(
                    values: RangeValues(
                      controller.minPrice.value,
                      controller.maxPrice.value,
                    ),
                    min: 0,
                    max: 10000000,
                    divisions: 20,
                    labels: RangeLabels(
                      NumberFormat.currency(locale: 'vi_VN', symbol: 'đ')
                          .format(controller.minPrice.value),
                      NumberFormat.currency(locale: 'vi_VN', symbol: 'đ')
                          .format(controller.maxPrice.value),
                    ),
                    onChanged: controller.updatePriceRange,
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Đóng'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.applyPriceFilter();
              Get.back();
            },
            child: const Text('Áp dụng'),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(PhongModel room) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final landlord = controller.getLandlordInfo(room.chuTroId);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Room Image
          if (room.hinhAnh.isNotEmpty)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: NetworkImage(room.hinhAnh[0]),
                  fit: BoxFit.cover,
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Room Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Phòng ${room.soPhong}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: room.trangThai == 'trong'
                            ? AppColors.success.withOpacity(0.1)
                            : AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        room.trangThai == 'trong' ? 'Còn trống' : 'Đã thuê',
                        style: TextStyle(
                          color: room.trangThai == 'trong'
                              ? AppColors.success
                              : AppColors.error,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Price and Area
                Row(
                  children: [
                    Text(
                      formatter.format(room.giaThue),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '/tháng',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.square_foot,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${room.dienTich}m²',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Amenities
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: room.tienNghi
                      .map<Widget>(
                        (amenity) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            amenity,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),

                // Thêm phần thông tin chủ trọ
                const Divider(height: 24),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withOpacity(0.1),
                      ),
                      child: landlord?.hinhAnh != null
                          ? ClipOval(
                              child: Image.network(
                                landlord!.hinhAnh!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              color: AppColors.primary,
                              size: 24,
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            landlord?.ten ?? 'Đang tải...',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (landlord != null) ...[
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(
                                  Icons.phone,
                                  size: 14,
                                  color: AppColors.textLight,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  landlord.soDienThoai,
                                  style: const TextStyle(
                                    color: AppColors.textLight,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => controller.viewRoomDetails(room),
                        icon: const Icon(Icons.info_outline),
                        label: const Text('Chi tiết'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: room.trangThai == 'trong'
                            ? () => controller.requestRoom(room)
                            : null,
                        icon: const Icon(Icons.send),
                        label: const Text('Đăng ký thuê'),
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
  }
}
