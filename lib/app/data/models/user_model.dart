import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String ten;
  final String email;
  final String soDienThoai;
  final String vaiTro;
  final DiaChi diaChi;
  final String? hinhAnh;
  final String? cmnd;
  final DateTime ngayTao;
  final DateTime ngayCapNhat;
  final TaiKhoanNganHang? taiKhoanNganHang;

  UserModel({
    required this.uid,
    required this.ten,
    required this.email,
    required this.soDienThoai,
    required this.vaiTro,
    required this.diaChi,
    this.hinhAnh,
    this.cmnd,
    required this.ngayTao,
    required this.ngayCapNhat,
    this.taiKhoanNganHang,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      ten: json['ten'] ?? '',
      email: json['email'] ?? '',
      soDienThoai: json['soDienThoai'] ?? '',
      vaiTro: json['vaiTro'] ?? '',
      diaChi: DiaChi.fromJson(json['diaChi'] ?? {}),
      hinhAnh: json['hinhAnh'],
      cmnd: json['cmnd'],
      ngayTao: (json['ngayTao'] as Timestamp).toDate(),
      ngayCapNhat: (json['ngayCapNhat'] as Timestamp).toDate(),
      taiKhoanNganHang: TaiKhoanNganHang.fromJson(json['taiKhoanNganHang'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'ten': ten,
      'email': email,
      'soDienThoai': soDienThoai,
      'vaiTro': vaiTro,
      'diaChi': diaChi.toJson(),
      'hinhAnh': hinhAnh,
      'cmnd': cmnd,
      'ngayTao': Timestamp.fromDate(ngayTao),
      'ngayCapNhat': Timestamp.fromDate(ngayCapNhat),
      'taiKhoanNganHang': taiKhoanNganHang,
    };
  }
}

class TaiKhoanNganHang {
  final String tenNganHang;
  final String soTaiKhoan;
  final String tenChuTaiKhoan;

  TaiKhoanNganHang({
    required this.tenNganHang,
    required this.soTaiKhoan,
    required this.tenChuTaiKhoan,
  });

  factory TaiKhoanNganHang.fromJson(Map<String, dynamic> json) {
    return TaiKhoanNganHang(
      tenNganHang: json['tenNganHang'] ?? '',
      soTaiKhoan: json['soTaiKhoan'] ?? '',
      tenChuTaiKhoan: json['tenChuTaiKhoan'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tenNganHang': tenNganHang,
      'soTaiKhoan': soTaiKhoan,
      'tenChuTaiKhoan': tenChuTaiKhoan,
    };
  }
}

class DiaChi {
  final String soNha;
  final String phuong;
  final String quan;
  final String thanhPho;

  DiaChi({
    required this.soNha,
    required this.phuong,
    required this.quan,
    required this.thanhPho,
  });

  String get diaChiDayDu {
    List<String> parts = [];
    if (soNha.isNotEmpty) parts.add(soNha);
    if (phuong.isNotEmpty) parts.add('Phường $phuong');
    if (quan.isNotEmpty) parts.add('Quận $quan');
    if (thanhPho.isNotEmpty) parts.add(thanhPho);

    return parts.isEmpty ? '' : parts.join(', ');
  }

  factory DiaChi.fromJson(Map<String, dynamic> json) {
    return DiaChi(
      soNha: json['soNha'] ?? '',
      phuong: json['phuong'] ?? '',
      quan: json['quan'] ?? '',
      thanhPho: json['thanhPho'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'soNha': soNha,
      'phuong': phuong,
      'quan': quan,
      'thanhPho': thanhPho,
    };
  }
}
