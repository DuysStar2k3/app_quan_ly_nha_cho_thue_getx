import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/rooms_landlord_controller.dart';
import '../../../../data/models/phong_model.dart';

class AddRoomLandlordView extends GetView<RoomsLandlordController> {
  AddRoomLandlordView({super.key});

  final _formKey = GlobalKey<FormState>();
  final _soPhongController = TextEditingController();
  final _tangController = TextEditingController();
  final _dienTichController = TextEditingController();
  final _giaThueController = TextEditingController();
  final _tienCocController = TextEditingController();
  final _soDienController = TextEditingController();
  final _soNuocController = TextEditingController();

  final _selectedLoaiPhong = 'don'.obs;
  final _selectedTienNghi = <String>[].obs;

  final _loaiPhongOptions = [
    {'value': 'don', 'label': 'Phòng đơn'},
    {'value': 'doi', 'label': 'Phòng đôi'},
    {'value': 'studio', 'label': 'Studio'},
  ];

  final List<Map<String, dynamic>> _tienNghiOptions = [
    {'value': 'wifi', 'label': 'WiFi', 'icon': Icons.wifi},
    {'value': 'dieu_hoa', 'label': 'Điều hòa', 'icon': Icons.ac_unit},
    {'value': 'nong_lanh', 'label': 'Nóng lạnh', 'icon': Icons.hot_tub},
    {'value': 'tu_lanh', 'label': 'Tủ lạnh', 'icon': Icons.kitchen},
    {
      'value': 'may_giat',
      'label': 'Máy giặt',
      'icon': Icons.local_laundry_service_sharp
    },
    {'value': 'giuong', 'label': 'Giường', 'icon': Icons.bed},
    {'value': 'tu_quan_ao', 'label': 'Tủ quần áo', 'icon': Icons.door_sliding},
    {'value': 'ban_ghe', 'label': 'Bàn ghế', 'icon': Icons.chair},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Phòng Mới'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Thông tin cơ bản
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
                      TextFormField(
                        controller: _soPhongController,
                        decoration: const InputDecoration(
                          labelText: 'Số phòng',
                          hintText: 'VD: 101',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập số phòng';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _tangController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Tầng',
                          hintText: 'VD: 1',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập tầng';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Tầng phải là số';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedLoaiPhong.value,
                        decoration: const InputDecoration(
                          labelText: 'Loại phòng',
                          border: OutlineInputBorder(),
                        ),
                        items: _loaiPhongOptions.map((option) {
                          return DropdownMenuItem(
                            value: option['value'],
                            child: Text(option['label']!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            _selectedLoaiPhong.value = value;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Diện tích và giá
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Diện tích và giá',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _dienTichController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Diện tích (m²)',
                          hintText: 'VD: 20',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập diện tích';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Diện tích không hợp lệ';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _giaThueController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Giá thuê (VNĐ)',
                          hintText: 'VD: 3000000',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập giá thuê';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Giá thuê không hợp lệ';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _tienCocController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Tiền cọc (VNĐ)',
                          hintText: 'VD: 3000000',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập tiền cọc';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Tiền cọc không hợp lệ';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tiện nghi
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tiện nghi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Obx(() => Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _tienNghiOptions.map((option) {
                              final isSelected = _selectedTienNghi
                                  .contains(option['value'] as String);
                              return FilterChip(
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      option['icon'] as IconData,
                                      size: 16,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(option['label'] as String),
                                  ],
                                ),
                                selected: isSelected,
                                onSelected: (selected) {
                                  if (selected) {
                                    _selectedTienNghi
                                        .add(option['value'] as String);
                                  } else {
                                    _selectedTienNghi
                                        .remove(option['value'] as String);
                                  }
                                },
                              );
                            }).toList(),
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Công tơ
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Chỉ số công tơ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _soDienController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Chỉ số điện ban đầu',
                          hintText: 'VD: 0',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập chỉ số điện';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Chỉ số điện không hợp lệ';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _soNuocController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Chỉ số nước ban đầu',
                          hintText: 'VD: 0',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập chỉ số nước';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Chỉ số nước không hợp lệ';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Nút thêm phòng
              ElevatedButton(
                onPressed: _handleAddRoom,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Thêm Phòng',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAddRoom() async {
    if (_formKey.currentState!.validate()) {
      try {
        await controller.addRoom(
          soPhong: _soPhongController.text.trim(),
          tang: int.parse(_tangController.text.trim()),
          loaiPhong: _selectedLoaiPhong.value,
          dienTich: double.parse(_dienTichController.text.trim()),
          giaThue: double.parse(_giaThueController.text.trim()),
          tienCoc: double.parse(_tienCocController.text.trim()),
          tienNghi: _selectedTienNghi,
          dienKe: ChiSoDienNuoc(
            soCongTo: 'DIEN${_soPhongController.text.trim()}',
            chiSoCuoi: double.parse(_soDienController.text.trim()),
            ngayGhi: DateTime.now(),
          ),
          nuocKe: ChiSoDienNuoc(
            soCongTo: 'NUOC${_soPhongController.text.trim()}',
            chiSoCuoi: double.parse(_soNuocController.text.trim()),
            ngayGhi: DateTime.now(),
          ),
        );
      } catch (e) {
        // Error is already handled in controller
      }
    }
  }
}
