import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

class PdfHelper {
  static Future<String> generateContractPdf({
    required String noiDung,
    required String tenHopDong,
  }) async {
    try {
      // Kiểm tra và yêu cầu quyền truy cập bộ nhớ
      if (await Permission.storage.isDenied) {
        final status = await Permission.storage.request();
        if (status.isDenied) {
          throw 'Cần cấp quyền truy cập bộ nhớ để xuất PDF';
        }
      }

      final pdf = pw.Document();

      // Tạo font chữ hỗ trợ tiếng Việt
      final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
      final ttf = pw.Font.ttf(fontData);

      // Xử lý nội dung để tách thành các dòng
      final lines = noiDung.split('\n');

      // Thêm trang vào PDF
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (context) => [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Tiêu đề
                pw.Center(
                  child: pw.Text(
                    'HỢP ĐỒNG THUÊ PHÒNG TRỌ',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),

                // Nội dung hợp đồng
                ...lines.map((line) => pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 8),
                      child: pw.Text(
                        line,
                        style: pw.TextStyle(
                          font: ttf,
                          fontSize: 12,
                        ),
                      ),
                    )),
              ],
            ),
          ],
        ),
      );

      // Lưu file PDF vào thư mục Downloads
      final output = Directory('/storage/emulated/0/Download');
      if (!await output.exists()) {
        await output.create(recursive: true);
      }

      final date = DateFormat('dd-MM-yyyy').format(DateTime.now());
      final file = File('${output.path}/$tenHopDong-$date.pdf');
      await file.writeAsBytes(await pdf.save());

      Get.snackbar(
        'Thành công',
        'File PDF đã được lưu vào thư mục Downloads',
        snackPosition: SnackPosition.BOTTOM,
      );

      return file.path;
    } catch (e) {
      print('Error generating PDF: $e');
      rethrow;
    }
  }
}
