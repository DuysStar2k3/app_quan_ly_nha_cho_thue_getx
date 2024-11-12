import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/phong_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../controllers/room_details_tenant_controller.dart';
import '../../controllers/room_search_tenant_controller.dart';

class RoomDetailsTenantView extends StatelessWidget {
  const RoomDetailsTenantView({super.key});

  @override
  Widget build(BuildContext context) {
    final PhongModel room = Get.arguments;
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image Slider
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: room.hinhAnh.isNotEmpty
                  ? CarouselSlider(
                      options: CarouselOptions(
                        height: 300,
                        viewportFraction: 1,
                        enableInfiniteScroll: false,
                      ),
                      items: room.hinhAnh.map((url) {
                        return Image.network(
                          url,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        );
                      }).toList(),
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 64,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),

          // Room Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Room Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Phòng ${room.soPhong}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: room.trangThai == 'trong'
                              ? AppColors.success.withOpacity(0.1)
                              : AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          room.trangThai == 'trong' ? 'Còn trống' : 'Đã thuê',
                          style: TextStyle(
                            color: room.trangThai == 'trong'
                                ? AppColors.success
                                : AppColors.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Price
                  Text(
                    formatter.format(room.giaThue),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    '/tháng',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Room Info
                  _buildInfoSection(
                    title: 'Thông tin phòng',
                    children: [
                      _buildInfoItem(
                        icon: Icons.square_foot,
                        label: 'Diện tích',
                        value: '${room.dienTich}m²',
                      ),
                      _buildInfoItem(
                        icon: Icons.layers,
                        label: 'Tầng',
                        value: room.tang.toString(),
                      ),
                      _buildInfoItem(
                        icon: Icons.category,
                        label: 'Loại phòng',
                        value: room.loaiPhong,
                      ),
                      _buildInfoItem(
                        icon: Icons.monetization_on,
                        label: 'Tiền cọc',
                        value: formatter.format(room.tienCoc),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Amenities
                  _buildInfoSection(
                    title: 'Tiện nghi',
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: room.tienNghi.map((amenity) {
                          return Chip(
                            label: Text(amenity),
                            backgroundColor: AppColors.chipBackground,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Services
                  _buildInfoSection(
                    title: 'Dịch vụ có sẵn',
                    children: [
                      Obx(() {
                        if (Get.find<RoomDetailsTenantController>().isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final services =
                            Get.find<RoomDetailsTenantController>().services;

                        if (services.isEmpty) {
                          return const Center(
                            child: Text(
                              'Chưa có dịch vụ',
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: services.length,
                          itemBuilder: (context, index) {
                            final service = services[index];
                            return ListTile(
                              leading: const Icon(
                                Icons.check_circle,
                                color: AppColors.success,
                              ),
                              title: Text(service.tenDichVu),
                              subtitle: Text(
                                '${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(service.gia)}/${service.donVi}',
                                style: TextStyle(
                                  color: AppColors.textLight,
                                ),
                              ),
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                            );
                          },
                        );
                      }),
                    ],
                  ),

                  // Landlord Info
                  _buildInfoSection(
                    title: 'Thông tin chủ trọ',
                    children: [
                      Obx(() {
                        final landlord = Get.find<RoomDetailsTenantController>().landlordInfo.value;
                        
                        if (landlord == null) {
                          return const Center(
                            child: Text(
                              'Không có thông tin chủ trọ',
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary.withOpacity(0.1),
                                  ),
                                  child: landlord.hinhAnh != null
                                      ? ClipOval(
                                          child: Image.network(
                                            landlord.hinhAnh!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Icon(
                                          Icons.person,
                                          size: 30,
                                          color: AppColors.primary,
                                        ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        landlord.ten,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        landlord.soDienThoai,
                                        style: TextStyle(
                                          color: AppColors.textLight,
                                        ),
                                      ),
                                      if (landlord.diaChi.diaChiDayDu.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          landlord.diaChi.diaChiDayDu,
                                          style: TextStyle(
                                            color: AppColors.textLight,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () =>
                                        Get.find<RoomDetailsTenantController>().callLandlord(),
                                    icon: const Icon(Icons.phone),
                                    label: const Text('Gọi điện'),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () =>
                                        Get.find<RoomDetailsTenantController>().messageLandlord(),
                                    icon: const Icon(Icons.message),
                                    label: const Text('Nhắn tin'),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: room.trangThai == 'trong'
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Get.find<RoomSearchTenantController>().requestRoom(room);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Đăng ký thuê phòng'),
              ),
            )
          : null,
    );
  }

  Widget _buildInfoSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
