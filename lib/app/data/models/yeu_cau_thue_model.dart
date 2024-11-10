import 'package:cloud_firestore/cloud_firestore.dart';

class YeuCauThueModel {
  final String id;
  final String nguoiThueId;
  final String phongId;
  final String trangThai;
  final String loaiYeuCau;
  final String nguoiTaoId;
  final String loaiNguoiTao;
  final DateTime ngayTao;
  final DateTime? ngayCapNhat;

  YeuCauThueModel({
    required this.id,
    required this.nguoiThueId,
    required this.phongId,
    required this.trangThai,
    required this.loaiYeuCau,
    required this.nguoiTaoId,
    required this.loaiNguoiTao,
    required this.ngayTao,
    this.ngayCapNhat,
  });

  factory YeuCauThueModel.fromJson(Map<String, dynamic> json) {
    try {
      return YeuCauThueModel(
        id: json['id']?.toString() ?? '',
        nguoiThueId: json['nguoiThueId']?.toString() ?? '',
        phongId: json['phongId']?.toString() ?? '',
        trangThai: json['trangThai']?.toString() ?? 'choXacNhan',
        loaiYeuCau: json['loaiYeuCau']?.toString() ?? 'thuePhong',
        nguoiTaoId: json['nguoiTaoId']?.toString() ?? '',
        loaiNguoiTao: json['loaiNguoiTao']?.toString() ?? 'nguoiThue',
        ngayTao: (json['ngayTao'] as Timestamp).toDate(),
        ngayCapNhat: json['ngayCapNhat'] != null
            ? (json['ngayCapNhat'] as Timestamp).toDate()
            : null,
      );
    } catch (e) {
      print('Error parsing YeuCauThueModel: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nguoiThueId': nguoiThueId,
      'phongId': phongId,
      'trangThai': trangThai,
      'loaiYeuCau': loaiYeuCau,
      'nguoiTaoId': nguoiTaoId,
      'loaiNguoiTao': loaiNguoiTao,
      'ngayTao': Timestamp.fromDate(ngayTao),
      'ngayCapNhat': ngayCapNhat != null ? Timestamp.fromDate(ngayCapNhat!) : null,
    };
  }

  YeuCauThueModel copyWith({
    String? id,
    String? nguoiThueId,
    String? phongId,
    String? trangThai,
    String? loaiYeuCau,
    String? nguoiTaoId,
    String? loaiNguoiTao,
    DateTime? ngayTao,
    DateTime? ngayCapNhat,
  }) {
    return YeuCauThueModel(
      id: id ?? this.id,
      nguoiThueId: nguoiThueId ?? this.nguoiThueId,
      phongId: phongId ?? this.phongId,
      trangThai: trangThai ?? this.trangThai,
      loaiYeuCau: loaiYeuCau ?? this.loaiYeuCau,
      nguoiTaoId: nguoiTaoId ?? this.nguoiTaoId,
      loaiNguoiTao: loaiNguoiTao ?? this.loaiNguoiTao,
      ngayTao: ngayTao ?? this.ngayTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
    );
  }

  bool get isJoinRequest => loaiYeuCau == 'thamGia';
  bool get isRentRequest => loaiYeuCau == 'thuePhong';
  bool get isLandlordRequest => loaiNguoiTao == 'chuTro';
  bool get isTenantRequest => loaiNguoiTao == 'nguoiThue';
} 