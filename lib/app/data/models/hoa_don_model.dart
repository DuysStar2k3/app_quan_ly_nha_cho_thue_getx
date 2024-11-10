import 'package:cloud_firestore/cloud_firestore.dart';

class HoaDonModel {
  final String id;
  final String chuTroId;
  final String phongId;
  final String thang;
  final List<ChiTietDichVu> dichVu;
  final double tongTien;
  final String trangThai;
  final DateTime ngayTao;
  final DateTime ngayCapNhat;

  HoaDonModel({
    required this.id,
    required this.chuTroId,
    required this.phongId,
    required this.thang,
    required this.dichVu,
    required this.tongTien,
    required this.trangThai,
    required this.ngayTao,
    required this.ngayCapNhat,
  });

  factory HoaDonModel.fromJson(Map<String, dynamic> json) {
    var dichVuList = (json['dichVu'] as List? ?? [])
        .map((item) => ChiTietDichVu.fromJson(item))
        .toList();

    return HoaDonModel(
      id: json['id'] ?? '',
      chuTroId: json['chuTroId'] ?? '',
      phongId: json['phongId'] ?? '',
      thang: json['thang'] ?? '',
      dichVu: dichVuList,
      tongTien: (json['tongTien'] ?? 0).toDouble(),
      trangThai: json['trangThai'] ?? '',
      ngayTao: (json['ngayTao'] as Timestamp).toDate(),
      ngayCapNhat: (json['ngayCapNhat'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chuTroId': chuTroId,
      'phongId': phongId,
      'thang': thang,
      'dichVu': dichVu.map((item) => item.toJson()).toList(),
      'tongTien': tongTien,
      'trangThai': trangThai,
      'ngayTao': Timestamp.fromDate(ngayTao),
      'ngayCapNhat': Timestamp.fromDate(ngayCapNhat),
    };
  }
}

class ChiTietDichVu {
  final String dichVuId;
  final double soLuong;
  final double thanhTien;

  ChiTietDichVu({
    required this.dichVuId,
    required this.soLuong,
    required this.thanhTien,
  });

  factory ChiTietDichVu.fromJson(Map<String, dynamic> json) {
    return ChiTietDichVu(
      dichVuId: json['dichVuId'] ?? '',
      soLuong: (json['soLuong'] ?? 0).toDouble(),
      thanhTien: (json['thanhTien'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dichVuId': dichVuId,
      'soLuong': soLuong,
      'thanhTien': thanhTien,
    };
  }
} 