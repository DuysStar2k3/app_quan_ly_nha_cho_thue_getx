import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/phong_model.dart';
import '../../../../data/models/yeu_cau_thue_model.dart';
import 'controller/tenant_requests_controller.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:intl/intl.dart';

class RequestsTenantView extends GetView<TenantRequestsController> {
  const RequestsTenantView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Yêu Cầu'),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.send),
                    SizedBox(width: 8),
                    Text('Yêu cầu của tôi'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox),
                    SizedBox(width: 8),
                    Text('Yêu cầu nhận'),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Yêu cầu tôi gửi
            _buildMyRequestsTab(),
            // Tab 2: Yêu cầu chủ trọ gửi
            _buildReceivedRequestsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildMyRequestsTab() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final myRequests = controller.myRequests;

      if (myRequests.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.send_outlined,
                size: 80,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 16),
              Text(
                'Bạn chưa gửi yêu cầu nào',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.loadRequests,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: myRequests.length,
          itemBuilder: (context, index) {
            final request = myRequests[index];
            final room = controller.getRoomInfo(request.phongId);
            if (room == null) return const SizedBox.shrink();

            return _buildRequestCard(
              request: request,
              room: room,
              isMyRequest: true,
            );
          },
        ),
      );
    });
  }

  Widget _buildReceivedRequestsTab() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final receivedRequests = controller.receivedRequests;

      if (receivedRequests.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 80,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 16),
              Text(
                'Không có yêu cầu nào từ chủ trọ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.loadRequests,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: receivedRequests.length,
          itemBuilder: (context, index) {
            final request = receivedRequests[index];
            final room = controller.getRoomInfo(request.phongId);
            if (room == null) return const SizedBox.shrink();

            return _buildRequestCard(
              request: request,
              room: room,
              isMyRequest: false,
            );
          },
        ),
      );
    });
  }

  Widget _buildRequestCard({
    required YeuCauThueModel request,
    required PhongModel room,
    required bool isMyRequest,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Request Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: request.isJoinRequest
                            ? Colors.purple.withOpacity(0.1)
                            : Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            request.isJoinRequest
                                ? Icons.group_add
                                : Icons.home,
                            size: 16,
                            color: request.isJoinRequest
                                ? Colors.purple
                                : Colors.blue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            request.isJoinRequest
                                ? 'Tham gia phòng'
                                : 'Thuê phòng',
                            style: TextStyle(
                              color: request.isJoinRequest
                                  ? Colors.purple
                                  : Colors.blue,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: controller
                            .getStatusColor(request.trangThai)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        controller.getRequestStatus(request.trangThai),
                        style: TextStyle(
                          color: controller.getStatusColor(request.trangThai),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: AppColors.textLight,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('dd/MM/yyyy HH:mm').format(request.ngayTao),
                      style: TextStyle(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
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
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.meeting_room,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Phòng ${room.soPhong}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            NumberFormat.currency(
                              locale: 'vi_VN',
                              symbol: 'đ',
                            ).format(room.giaThue),
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (request.trangThai == 'daChapNhan' && !isMyRequest) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => controller.rejectRequest(request),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Từ chối'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => controller.acceptRequest(request),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: request.isJoinRequest
                                ? Colors.purple
                                : Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            request.isJoinRequest
                                ? 'Xác nhận tham gia'
                                : 'Xác nhận thuê',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (request.trangThai == 'choXacNhan' && isMyRequest) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => controller.cancelRequest(request),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Hủy yêu cầu'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
} 