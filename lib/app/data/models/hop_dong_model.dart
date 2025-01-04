import 'package:cloud_firestore/cloud_firestore.dart';

class HopDongModel {
  final String id;
  final String chuTroId;
  final String phongId;
  final String nguoiThueId;
  final DateTime ngayBatDau;
  final DateTime ngayKetThuc;
  final String trangThai;
  final String noiDung;
  final DateTime ngayTao;
  final DateTime ngayCapNhat;

  HopDongModel({
    required this.id,
    required this.chuTroId,
    required this.phongId,
    required this.nguoiThueId,
    required this.ngayBatDau,
    required this.ngayKetThuc,
    required this.trangThai,
    required this.noiDung,
    required this.ngayTao,
    required this.ngayCapNhat,
  });

  factory HopDongModel.fromJson(Map<String, dynamic> json) {
    return HopDongModel(
      id: json['id'] ?? '',
      chuTroId: json['chuTroId'] ?? '',
      phongId: json['phongId'] ?? '',
      nguoiThueId: json['nguoiThueId'] ?? '',
      ngayBatDau: (json['ngayBatDau'] as Timestamp).toDate(),
      ngayKetThuc: (json['ngayKetThuc'] as Timestamp).toDate(),
      trangThai: json['trangThai'] ?? '',
      noiDung: json['noiDung'] ?? '',
      ngayTao: (json['ngayTao'] as Timestamp).toDate(),
      ngayCapNhat: (json['ngayCapNhat'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chuTroId': chuTroId,
      'phongId': phongId,
      'nguoiThueId': nguoiThueId,
      'ngayBatDau': Timestamp.fromDate(ngayBatDau),
      'ngayKetThuc': Timestamp.fromDate(ngayKetThuc),
      'trangThai': trangThai,
      'noiDung': noiDung,
      'ngayTao': Timestamp.fromDate(ngayTao),
      'ngayCapNhat': Timestamp.fromDate(ngayCapNhat),
    };
  }

  bool get conHieuLuc {
    final now = DateTime.now();
    return ngayKetThuc.isAfter(now) && trangThai == 'hieuLuc';
  }

  int get soNgayConLai {
    if (trangThai == 'daKetThuc') {
      return 0; // Mặc định trả về 0 nếu hợp đồng đã kết thúc
    }
    final now = DateTime.now();
    return ngayKetThuc.difference(now).inDays;
  }
}
