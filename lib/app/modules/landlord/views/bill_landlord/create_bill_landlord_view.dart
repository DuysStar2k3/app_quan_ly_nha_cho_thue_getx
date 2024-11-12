import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/hoa_don_model.dart';
import '../../controllers/bill_landlord_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/phong_model.dart';
import '../../../../data/models/dich_vu_model.dart';
import 'package:intl/intl.dart';

class CreateBillLandlordView extends GetView<BillLandlordController> {
  const CreateBillLandlordView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedRoom = Rxn<PhongModel>();
    final thangController = TextEditingController();
    final serviceQuantities = <String, TextEditingController>{};
    final oldValues = <String, TextEditingController>{};
    final newValues = <String, TextEditingController>{};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo hóa đơn mới'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chọn phòng
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin cơ bản',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(() => DropdownButtonFormField<PhongModel>(
                          decoration: const InputDecoration(
                            labelText: 'Chọn phòng',
                            border: OutlineInputBorder(),
                          ),
                          value: selectedRoom.value,
                          items: controller.rooms.values.map((room) {
                            return DropdownMenuItem(
                              value: room,
                              child: Text('Phòng ${room.soPhong}'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            selectedRoom.value = value;
                            // Reset các controller khi đổi phòng
                            serviceQuantities.clear();
                            oldValues.clear();
                            newValues.clear();
                          },
                        )),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Tháng',
                        border: OutlineInputBorder(),
                      ),
                      value: thangController.text.isNotEmpty ? thangController.text : _getNextMonth(),
                      items: _generateNextMonths().map((month) {
                        return DropdownMenuItem(
                          value: month,
                          child: Text(month),
                        );
                      }).toList(),
                      onChanged: (value) {
                        thangController.text = value ?? '';
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Danh sách dịch vụ
            Obx(() {
              if (selectedRoom.value == null) {
                return const Center(
                  child: Text('Vui lòng chọn phòng'),
                );
              }

              final roomServices = controller.services.values
                  .where((service) =>
                      selectedRoom.value!.dichVu.contains(service.id))
                  .toList();

              if (roomServices.isEmpty) {
                return const Center(
                  child: Text('Phòng này chưa có dịch vụ nào'),
                );
              }

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Chi tiết dịch vụ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...roomServices.map((service) {
                        // Tạo controllers cho dịch vụ nếu chưa có
                        serviceQuantities[service.id] ??=
                            TextEditingController();

                        oldValues[service.id] ??= TextEditingController();
                        newValues[service.id] ??= TextEditingController();

                        // Lấy số công tơ cũ nếu là dịch vụ tính theo công tơ
                        if (service.donVi == 'kWh' || service.donVi == 'm³') {
                          controller
                              .getRoomMeterReadings(selectedRoom.value!.id)
                              .then((value) => oldValues[service.id]?.text =
                                  value[service.id].toString());
                          print(oldValues[service.id]?.text);
                        }

                        return _buildServiceInput(
                          service: service,
                          room: selectedRoom.value!,
                          quantityController: serviceQuantities[service.id]!,
                          oldValueController: oldValues[service.id]!,
                          newValueController: newValues[service.id]!,
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            if (selectedRoom.value == null || thangController.text.isEmpty) {
              Get.snackbar(
                'Lỗi',
                'Vui lòng chọn phòng và nhập tháng',
                snackPosition: SnackPosition.BOTTOM,
              );
              return;
            }

            // Calculate total and create bill details
            double tongTien = selectedRoom.value!.giaThue;
            final dichVu = <ChiTietDichVu>[];
            final chiSoCongTo = <String, Map<String, double>>{};

            for (var service in controller.services.values) {
              if (service.donVi == 'kWh' || service.donVi == 'm³') {
                // Dịch vụ tính theo công tơ
                final oldValue =
                    double.tryParse(oldValues[service.id]?.text ?? '0') ?? 0;
                final newValue =
                    double.tryParse(newValues[service.id]?.text ?? '0') ?? 0;
                if (newValue > oldValue) {
                  final thanhTien = (newValue - oldValue) * service.gia;
                  dichVu.add(ChiTietDichVu(
                    dichVuId: service.id,
                    chiSoCu: oldValue,
                    chiSoMoi: newValue,
                    thanhTien: thanhTien,
                  ));
                }
              } else {
                // Dịch vụ tính theo người hoặc tháng
                final soLuong = controller.calculateServiceQuantity(
                    service, selectedRoom.value!);
                final thanhTien = soLuong * service.gia;
                dichVu.add(ChiTietDichVu(
                  dichVuId: service.id,
                  soLuong: soLuong,
                  thanhTien: thanhTien,
                ));
              }
            }

            // Tính tổng tiền
            for (var dv in dichVu) {
              tongTien += dv.thanhTien;
            }

            // Tạo hóa đơn
            controller.createBill(
              phongId: selectedRoom.value!.id,
              thang: thangController.text,
              dichVu: dichVu,
              tongTien: tongTien,
              chiSoCongTo: chiSoCongTo,
            );

            Get.back();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Tạo hóa đơn',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceInput({
    required DichVuModel service,
    required PhongModel room,
    required TextEditingController quantityController,
    required TextEditingController oldValueController,
    required TextEditingController newValueController,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    service.tenDichVu,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  NumberFormat.currency(
                    locale: 'vi_VN',
                    symbol: 'đ',
                  ).format(service.gia),
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (service.donVi == 'kWh' || service.donVi == 'm³') ...[
              TextField(
                controller: oldValueController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Chỉ số cũ',
                  suffixText: service.donVi,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: newValueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Chỉ số mới',
                  suffixText: service.donVi,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) {
                  final newValue = double.tryParse(value) ?? 0;
                  final oldValue =
                      double.tryParse(oldValueController.text) ?? 0;
                  if (newValue > oldValue) {
                    quantityController.text = (newValue - oldValue).toString();
                  }
                },
              ),
            ] else if (service.donVi == 'người') ...[
              TextField(
                controller: quantityController
                  ..text = room.nguoiThueHienTai.length.toString(),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Số người',
                  suffixText: service.donVi,
                  border: const OutlineInputBorder(),
                ),
              ),
            ] else ...[
              TextField(
                controller: quantityController..text = '1',
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Số lượng',
                  suffixText: service.donVi,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
            const SizedBox(height: 8),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: quantityController,
              builder: (context, value, child) {
                final quantity = double.tryParse(value.text) ?? 0;
                final total = quantity * service.gia;
                return Text(
                  'Thành tiền: ${NumberFormat.currency(
                    locale: 'vi_VN',
                    symbol: 'đ',
                  ).format(total)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<String> _generateNextMonths() {
    final now = DateTime.now();
    final months = <String>[];
    
    // Bắt đầu từ tháng tiếp theo
    for (int i = 1; i <= 12; i++) {
      final month = DateTime(now.year, now.month + i, 1);
      months.add(DateFormat('MM/yyyy').format(month));
    }
    return months;
  }

  String _getNextMonth() {
    final now = DateTime.now();
    final nextMonth = DateTime(now.year, now.month + 1, 1);
    return DateFormat('MM/yyyy').format(nextMonth);
  }
}
