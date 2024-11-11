import 'package:cloud_firestore/cloud_firestore.dart';

class ThanhToanModel {
  final String id;
  final String hoaDonId;
  final String nguoiThueId;
  final String phongId;
  final double soTien;
  final String phuongThuc;
  final String trangThai;
  final String? ghiChu;
  final DateTime ngayTao;
  final DateTime ngayCapNhat;

  ThanhToanModel({
    required this.id,
    required this.hoaDonId,
    required this.nguoiThueId,
    required this.phongId,
    required this.soTien,
    required this.phuongThuc,
    required this.trangThai,
    this.ghiChu,
    required this.ngayTao,
    required this.ngayCapNhat,
  });

  factory ThanhToanModel.fromJson(Map<String, dynamic> json) {
    return ThanhToanModel(
      id: json['id'] ?? '',
      hoaDonId: json['hoaDonId'] ?? '',
      nguoiThueId: json['nguoiThueId'] ?? '',
      phongId: json['phongId'] ?? '',
      soTien: (json['soTien'] ?? 0).toDouble(),
      phuongThuc: json['phuongThuc'] ?? '',
      trangThai: json['trangThai'] ?? '',
      ghiChu: json['ghiChu'],
      ngayTao: (json['ngayTao'] as Timestamp).toDate(),
      ngayCapNhat: (json['ngayCapNhat'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hoaDonId': hoaDonId,
      'nguoiThueId': nguoiThueId,
      'phongId': phongId,
      'soTien': soTien,
      'phuongThuc': phuongThuc,
      'trangThai': trangThai,
      'ghiChu': ghiChu,
      'ngayTao': Timestamp.fromDate(ngayTao),
      'ngayCapNhat': Timestamp.fromDate(ngayCapNhat),
    };
  }
}
