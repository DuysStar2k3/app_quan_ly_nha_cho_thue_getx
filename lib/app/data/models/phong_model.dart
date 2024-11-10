import 'package:cloud_firestore/cloud_firestore.dart';

class PhongModel {
  final String id;
  final String chuTroId;
  final String soPhong;
  final int tang;
  final String loaiPhong;
  final String trangThai;
  final double dienTich;
  final double giaThue;
  final double tienCoc;
  final List<String> tienNghi;
  final List<String> hinhAnh;
  final List<String> nguoiThueHienTai;
  final List<String> dichVu;
  final CongToModel congTo;
  final DateTime ngayTao;
  final DateTime ngayCapNhat;

  PhongModel({
    required this.id,
    required this.chuTroId,
    required this.soPhong,
    required this.tang,
    required this.loaiPhong,
    required this.trangThai,
    required this.dienTich,
    required this.giaThue,
    required this.tienCoc,
    required this.tienNghi,
    required this.hinhAnh,
    required this.nguoiThueHienTai,
    required this.dichVu,
    required this.congTo,
    required this.ngayTao,
    required this.ngayCapNhat,
  });

  factory PhongModel.fromJson(Map<String, dynamic> json) {
    return PhongModel(
      id: json['id'] ?? '',
      chuTroId: json['chuTroId'] ?? '',
      soPhong: json['soPhong'] ?? '',
      tang: json['tang'] ?? 0,
      loaiPhong: json['loaiPhong'] ?? '',
      trangThai: json['trangThai'] ?? '',
      dienTich: (json['dienTich'] ?? 0).toDouble(),
      giaThue: (json['giaThue'] ?? 0).toDouble(),
      tienCoc: (json['tienCoc'] ?? 0).toDouble(),
      tienNghi: List<String>.from(json['tienNghi'] ?? []),
      hinhAnh: List<String>.from(json['hinhAnh'] ?? []),
      nguoiThueHienTai: List<String>.from(json['nguoiThueHienTai'] ?? []),
      dichVu: List<String>.from(json['dichVu'] ?? []),
      congTo: CongToModel.fromJson(json['congTo'] ?? {}),
      ngayTao: json['ngayTao'] != null
          ? (json['ngayTao'] as Timestamp).toDate()
          : DateTime.now(),
      ngayCapNhat: json['ngayCapNhat'] != null
          ? (json['ngayCapNhat'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chuTroId': chuTroId,
      'soPhong': soPhong,
      'tang': tang,
      'loaiPhong': loaiPhong,
      'trangThai': trangThai,
      'dienTich': dienTich,
      'giaThue': giaThue,
      'tienCoc': tienCoc,
      'tienNghi': tienNghi,
      'hinhAnh': hinhAnh,
      'nguoiThueHienTai': nguoiThueHienTai,
      'dichVu': dichVu,
      'congTo': congTo.toJson(),
      'ngayTao': Timestamp.fromDate(ngayTao),
      'ngayCapNhat': Timestamp.fromDate(ngayCapNhat),
    };
  }

  PhongModel copyWith({
    String? id,
    String? chuTroId,
    String? soPhong,
    int? tang,
    String? loaiPhong,
    String? trangThai,
    double? dienTich,
    double? giaThue,
    double? tienCoc,
    List<String>? tienNghi,
    List<String>? hinhAnh,
    List<String>? nguoiThueHienTai,
    List<String>? dichVu,
    CongToModel? congTo,
    DateTime? ngayTao,
    DateTime? ngayCapNhat,
  }) {
    return PhongModel(
      id: id ?? this.id,
      chuTroId: chuTroId ?? this.chuTroId,
      soPhong: soPhong ?? this.soPhong,
      tang: tang ?? this.tang,
      loaiPhong: loaiPhong ?? this.loaiPhong,
      trangThai: trangThai ?? this.trangThai,
      dienTich: dienTich ?? this.dienTich,
      giaThue: giaThue ?? this.giaThue,
      tienCoc: tienCoc ?? this.tienCoc,
      tienNghi: tienNghi ?? this.tienNghi,
      hinhAnh: hinhAnh ?? this.hinhAnh,
      nguoiThueHienTai: nguoiThueHienTai ?? this.nguoiThueHienTai,
      dichVu: dichVu ?? this.dichVu,
      congTo: congTo ?? this.congTo,
      ngayTao: ngayTao ?? this.ngayTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
    );
  }
}

class CongToModel {
  final ChiSoDienNuoc dienKe;
  final ChiSoDienNuoc nuocKe;

  CongToModel({
    required this.dienKe,
    required this.nuocKe,
  });

  factory CongToModel.fromJson(Map<String, dynamic> json) {
    return CongToModel(
      dienKe: ChiSoDienNuoc.fromJson(json['dienKe'] ?? {}),
      nuocKe: ChiSoDienNuoc.fromJson(json['nuocKe'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dienKe': dienKe.toJson(),
      'nuocKe': nuocKe.toJson(),
    };
  }
}

class ChiSoDienNuoc {
  final String soCongTo;
  final double chiSoCuoi;
  final DateTime ngayGhi;

  ChiSoDienNuoc({
    required this.soCongTo,
    required this.chiSoCuoi,
    required this.ngayGhi,
  });

  factory ChiSoDienNuoc.fromJson(Map<String, dynamic> json) {
    return ChiSoDienNuoc(
      soCongTo: json['soCongTo'] ?? '',
      chiSoCuoi: (json['chiSoCuoi'] ?? 0).toDouble(),
      ngayGhi: json['ngayGhi'] != null
          ? (json['ngayGhi'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'soCongTo': soCongTo,
      'chiSoCuoi': chiSoCuoi,
      'ngayGhi': Timestamp.fromDate(ngayGhi),
    };
  }
}
