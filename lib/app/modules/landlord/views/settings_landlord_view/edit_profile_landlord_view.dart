import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/edit_profile_controller.dart';

class EditProfileLandlordView extends GetView<EditProfileController> {
  EditProfileLandlordView({super.key});

  final _formKey = GlobalKey<FormState>();
  final _tenController = TextEditingController();
  final _emailController = TextEditingController();
  final _sdtController = TextEditingController();
  final _cmndController = TextEditingController();

  // Controllers cho địa chỉ
  final _soNhaController = TextEditingController();
  final _phuongController = TextEditingController();
  final _quanController = TextEditingController();
  final _thanhPhoController = TextEditingController();
  final _tenNganHangController = TextEditingController();
  final _soTaiKhoanController = TextEditingController();
  final _tenChuTaiKhoanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Khởi tạo giá trị cho các controller từ thông tin user hiện tại
    final user = controller.currentUser;
    if (user != null) {
      _tenController.text = user.ten;
      _emailController.text = user.email;
      _sdtController.text = user.soDienThoai;
      _cmndController.text = user.cmnd ?? '';

      // Khởi tạo giá trị cho địa chỉ
      _soNhaController.text = controller.currentUser?.diaChi.soNha ?? '';
      _phuongController.text = controller.currentUser?.diaChi.phuong ?? '';
      _quanController.text = controller.currentUser?.diaChi.quan ?? '';
      _thanhPhoController.text = controller.currentUser?.diaChi.thanhPho ?? '';

      _tenNganHangController.text =
          controller.currentUser?.taiKhoanNganHang?.tenNganHang ?? '';
      _soTaiKhoanController.text =
          controller.currentUser?.taiKhoanNganHang?.soTaiKhoan ?? '';
      _tenChuTaiKhoanController.text =
          controller.currentUser?.taiKhoanNganHang?.tenChuTaiKhoan ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa thông tin'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[200],
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.grey[400],
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Thông tin cá nhân
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Thông tin cá nhân',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _tenController,
                          decoration: const InputDecoration(
                            labelText: 'Họ và tên',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập họ tên';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _cmndController,
                          decoration: const InputDecoration(
                            labelText: 'CCCD/CMND',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.badge_outlined),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Thông tin liên hệ
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Thông tin liên hệ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          readOnly: true,
                          enabled: false,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _sdtController,
                          decoration: const InputDecoration(
                            labelText: 'Số điện thoại',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập số điện thoại';
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
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Địa chỉ thường trú',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _soNhaController,
                          decoration: const InputDecoration(
                            labelText: 'Số nhà, tên đường',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.home_outlined),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _phuongController,
                                decoration: const InputDecoration(
                                  labelText: 'Phường/Xã',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _quanController,
                                decoration: const InputDecoration(
                                  labelText: 'Quận/Huyện',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _thanhPhoController,
                          decoration: const InputDecoration(
                            labelText: 'Tỉnh/Thành phố',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Thông tin tài khoản ngân hàng',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _tenNganHangController,
                                decoration: const InputDecoration(
                                  labelText: 'Tên ngân hàng',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _tenChuTaiKhoanController,
                                decoration: const InputDecoration(
                                  labelText: 'Tên chủ tài khoản',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _soTaiKhoanController,
                          decoration: const InputDecoration(
                            labelText: 'Số tài khoản',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.home_outlined),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Nút lưu thay đổi
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        controller.updateProfile(
                          ten: _tenController.text,
                          soDienThoai: _sdtController.text,
                          diaChi: {
                            'soNha': _soNhaController.text,
                            'phuong': _phuongController.text,
                            'quan': _quanController.text,
                            'thanhPho': _thanhPhoController.text,
                          },
                          cmnd: _cmndController.text.trim(),
                          taiKhoanNganHang: {
                            'tenNganHang': _tenNganHangController.text,
                            'soTaiKhoan': _soTaiKhoanController.text,
                            'tenChuTaiKhoan': _tenChuTaiKhoanController.text,
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Lưu thay đổi',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
