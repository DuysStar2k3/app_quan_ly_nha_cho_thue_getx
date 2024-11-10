import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  EditProfileView({super.key});

  final _formKey = GlobalKey<FormState>();
  final _tenController = TextEditingController();
  final _soDienThoaiController = TextEditingController();
  final _soNhaController = TextEditingController();
  final _phuongController = TextEditingController();
  final _quanController = TextEditingController();
  final _thanhPhoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Khởi tạo giá trị cho các controller
    _tenController.text = controller.currentUser?.ten ?? '';
    _soDienThoaiController.text = controller.currentUser?.soDienThoai ?? '';
    _soNhaController.text = controller.currentUser?.diaChi.soNha ?? '';
    _phuongController.text = controller.currentUser?.diaChi.phuong ?? '';
    _quanController.text = controller.currentUser?.diaChi.quan ?? '';
    _thanhPhoController.text = controller.currentUser?.diaChi.thanhPho ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh Sửa Thông Tin'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Avatar Section
              Center(
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blue.shade100,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue.shade50,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Thông tin cá nhân
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thông tin cá nhân',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _tenController,
                        label: 'Họ và tên',
                        icon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập họ tên';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _soDienThoaiController,
                        label: 'Số điện thoại',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập số điện thoại';
                          }
                          if (!GetUtils.isPhoneNumber(value)) {
                            return 'Số điện thoại không hợp lệ';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Địa chỉ
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Địa chỉ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _soNhaController,
                        label: 'Số nhà',
                        icon: Icons.home_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _phuongController,
                        label: 'Phường',
                        icon: Icons.location_city_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _quanController,
                        label: 'Quận',
                        icon: Icons.location_on_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _thanhPhoController,
                        label: 'Thành phố',
                        icon: Icons.location_city,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Nút lưu
              ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Lưu Thay Đổi',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      validator: validator,
    );
  }

  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      try {
        await controller.updateProfile(
          ten: _tenController.text.trim(),
          soDienThoai: _soDienThoaiController.text.trim(),
          diaChi: {
            'soNha': _soNhaController.text.trim(),
            'phuong': _phuongController.text.trim(),
            'quan': _quanController.text.trim(),
            'thanhPho': _thanhPhoController.text.trim(),
          },
        );
      } catch (e) {
        // Error is already handled in controller
      }
    }
  }
} 