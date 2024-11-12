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
  final double? chiSoCu;
  final double? chiSoMoi;
  final double? soLuong;
  final double thanhTien;

  ChiTietDichVu({
    required this.dichVuId,
    this.chiSoCu,
    this.chiSoMoi,
    this.soLuong,
    required this.thanhTien,
  });

  factory ChiTietDichVu.fromJson(Map<String, dynamic> json) {
    return ChiTietDichVu(
      dichVuId: json['dichVuId'] ?? '',
      chiSoCu: (json['chiSoCu'] as num?)?.toDouble(),
      chiSoMoi: (json['chiSoMoi'] as num?)?.toDouble(),
      soLuong: (json['soLuong'] as num?)?.toDouble(),
      thanhTien: (json['thanhTien'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'dichVuId': dichVuId,
      'thanhTien': thanhTien,
    };

    if (chiSoCu != null && chiSoMoi != null) {
      data['chiSoCu'] = chiSoCu;
      data['chiSoMoi'] = chiSoMoi;
    }

    if (soLuong != null) {
      data['soLuong'] = soLuong;
    }

    return data;
  }
}
