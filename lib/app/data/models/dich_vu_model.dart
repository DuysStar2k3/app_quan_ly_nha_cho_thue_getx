import 'package:cloud_firestore/cloud_firestore.dart';

class DichVuModel {
  final String id;
  final String chuTroId;
  final String tenDichVu;
  final String moTa;
  final double gia;
  final String donVi;
  final DateTime ngayTao;
  final DateTime ngayCapNhat;

  DichVuModel({
    required this.id,
    required this.chuTroId,
    required this.tenDichVu,
    required this.moTa,
    required this.gia,
    required this.donVi,
    required this.ngayTao,
    required this.ngayCapNhat,
  });

  factory DichVuModel.fromJson(Map<String, dynamic> json) {
    return DichVuModel(
      id: json['id'] ?? '',
      chuTroId: json['chuTroId'] ?? '',
      tenDichVu: json['tenDichVu'] ?? '',
      moTa: json['moTa'] ?? '',
      gia: (json['gia'] ?? 0).toDouble(),
      donVi: json['donVi'] ?? '',
      ngayTao: (json['ngayTao'] as Timestamp).toDate(),
      ngayCapNhat: (json['ngayCapNhat'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chuTroId': chuTroId,
      'tenDichVu': tenDichVu,
      'moTa': moTa,
      'gia': gia,
      'donVi': donVi,
      'ngayTao': Timestamp.fromDate(ngayTao),
      'ngayCapNhat': Timestamp.fromDate(ngayCapNhat),
    };
  }

  DichVuModel copyWith({
    String? id,
    String? chuTroId,
    String? tenDichVu,
    String? moTa,
    double? gia,
    String? donVi,
    DateTime? ngayTao,
    DateTime? ngayCapNhat,
  }) {
    return DichVuModel(
      id: id ?? this.id,
      chuTroId: chuTroId ?? this.chuTroId,
      tenDichVu: tenDichVu ?? this.tenDichVu,
      moTa: moTa ?? this.moTa,
      gia: gia ?? this.gia,
      donVi: donVi ?? this.donVi,
      ngayTao: ngayTao ?? this.ngayTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
    );
  }
}
