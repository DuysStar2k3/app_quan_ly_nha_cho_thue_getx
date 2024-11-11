class ContractTemplate {
  static String generateContent({
    required String tenChuTro,
    required String soCmndChuTro,
    required String diaChiChuTro,
    required String sdtChuTro,
    required String tenNguoiThue,
    required String soCmndNguoiThue,
    required String diaChiNguoiThue,
    required String sdtNguoiThue,
    required String soPhong,
    required String dienTich,
    required String giaThue,
    required String tienCoc,
    required String ngayBatDau,
    required String ngayKetThuc,
  }) {
    return '''
HỢP ĐỒNG THUÊ PHÒNG TRỌ

I. BÊN CHO THUÊ (Bên A):
- Ông/Bà: $tenChuTro
- CMND/CCCD số: $soCmndChuTro
- Địa chỉ: $diaChiChuTro
- Điện thoại: $sdtChuTro

II. BÊN THUÊ (Bên B):
- Ông/Bà: $tenNguoiThue
- CMND/CCCD số: $soCmndNguoiThue
- Địa chỉ thường trú: $diaChiNguoiThue
- Điện thoại: $sdtNguoiThue

III. NỘI DUNG HỢP ĐỒNG:
1. Bên A đồng ý cho Bên B thuê phòng trọ với các thông tin sau:
   - Số phòng: $soPhong
   - Diện tích: $dienTich m²
   - Giá thuê: $giaThue đồng/tháng
   - Tiền cọc: $tienCoc đồng

2. Thời hạn thuê:
   - Từ ngày: $ngayBatDau
   - Đến ngày: $ngayKetThuc

3. Thanh toán:
   - Tiền thuê phòng được thanh toán vào ngày 05 hàng tháng
   - Hình thức thanh toán: Tiền mặt hoặc chuyển khoản

4. Trách nhiệm của Bên A:
   - Đảm bảo cơ sở vật chất của phòng trọ
   - Bảo trì, sửa chữa những hư hỏng không do lỗi của Bên B
   - Thông báo trước cho Bên B khi có thay đổi về giá thuê hoặc các điều khoản khác

5. Trách nhiệm của Bên B:
   - Thanh toán tiền thuê đúng hạn
   - Giữ gìn vệ sinh và an ninh trật tự
   - Bảo quản tài sản và trang thiết bị trong phòng
   - Không được tự ý sửa chữa, cải tạo phòng khi chưa có sự đồng ý của Bên A

6. Chấm dứt hợp đồng:
   - Hai bên có quyền chấm dứt hợp đồng trước thời hạn với điều kiện thông báo trước ít nhất 30 ngày
   - Bên vi phạm các điều khoản của hợp đồng sẽ phải bồi thường thiệt hại (nếu có)

7. Điều khoản chung:
   - Hai bên cam kết thực hiện đúng các điều khoản của hợp đồng
   - Hợp đồng có hiệu lực kể từ ngày ký
   - Hợp đồng được lập thành 02 bản có giá trị pháp lý như nhau, mỗi bên giữ 01 bản

Ngày ... tháng ... năm ...

          BÊN A                                                  BÊN B
     (Ký và ghi rõ họ tên)                               (Ký và ghi rõ họ tên)
''';
  }
}
