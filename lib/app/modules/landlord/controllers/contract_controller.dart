import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/utils/contract_template.dart';
import '../../../data/models/hop_dong_model.dart';
import '../../../data/models/phong_model.dart';
import '../../../data/models/user_model.dart';
import './landlord_controller.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/pdf_helper.dart';

class ContractController extends GetxController {
  final LandlordController landlordController;
  final _firestore = FirebaseFirestore.instance;

  ContractController(this.landlordController);

  final isLoading = true.obs;
  final contracts = <HopDongModel>[].obs;
  final rooms = <String, PhongModel>{}.obs;
  final tenants = <String, UserModel>{}.obs;

  List<PhongModel> get rentedRooms {
    return rooms.values.where((room) {
      if (room.nguoiThueHienTai.isEmpty) return false;

      return room.nguoiThueHienTai.any((tenantId) {
        return !contracts.any((contract) =>
            contract.nguoiThueId == tenantId &&
            contract.phongId == room.id &&
            contract.trangThai == 'hieuLuc');
      });
    }).toList();
  }

  List<UserModel> getRoomTenants(String roomId) {
    final room = rooms[roomId];
    if (room == null) return [];

    return room.nguoiThueHienTai
        .map((tenantId) => tenants[tenantId])
        .where((tenant) {
          if (tenant == null) return false;
          return !contracts.any((contract) =>
              contract.nguoiThueId == tenant.uid &&
              contract.phongId == roomId &&
              contract.trangThai == 'hieuLuc');
        })
        .cast<UserModel>()
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      final user = landlordController.currentUser;
      if (user == null) return;

      final roomsSnapshot = await _firestore
          .collection('phong')
          .where('chuTroId', isEqualTo: user.uid)
          .get();

      final allTenantIds = <String>{};
      for (var doc in roomsSnapshot.docs) {
        final room = PhongModel.fromJson({
          'id': doc.id,
          ...doc.data(),
        });
        rooms[doc.id] = room;
        allTenantIds.addAll(room.nguoiThueHienTai);
      }

      for (var tenantId in allTenantIds) {
        final tenantDoc =
            await _firestore.collection('nguoiDung').doc(tenantId).get();
        if (tenantDoc.exists) {
          tenants[tenantId] = UserModel.fromJson({
            'uid': tenantDoc.id,
            ...tenantDoc.data()!,
          });
        }
      }

      final contractsSnapshot = await _firestore
          .collection('hopDong')
          .where('chuTroId', isEqualTo: user.uid)
          .orderBy('ngayTao', descending: true)
          .get();

      contracts.value = contractsSnapshot.docs
          .map((doc) => HopDongModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String _generateContractContent({
    required String phongId,
    required String nguoiThueId,
    required DateTime ngayBatDau,
    required DateTime ngayKetThuc,
  }) {
    final room = rooms[phongId];
    final tenant = tenants[nguoiThueId];
    final landlord = landlordController.currentUser;

    if (room == null || tenant == null || landlord == null) {
      throw 'Thiếu thông tin để tạo hợp đồng';
    }

    return ContractTemplate.generateContent(
      tenChuTro: landlord.ten,
      soCmndChuTro: landlord.cmnd ?? '',
      diaChiChuTro: landlord.diaChi.diaChiDayDu,
      sdtChuTro: landlord.soDienThoai,
      tenNguoiThue: tenant.ten,
      soCmndNguoiThue: tenant.cmnd ?? '',
      diaChiNguoiThue: tenant.diaChi.diaChiDayDu,
      sdtNguoiThue: tenant.soDienThoai,
      soPhong: room.soPhong,
      dienTich: room.dienTich.toString(),
      giaThue: NumberFormat.currency(
        locale: 'vi_VN',
        symbol: '',
        decimalDigits: 0,
      ).format(room.giaThue),
      tienCoc: NumberFormat.currency(
        locale: 'vi_VN',
        symbol: '',
        decimalDigits: 0,
      ).format(room.tienCoc),
      ngayBatDau: DateFormat('dd/MM/yyyy').format(ngayBatDau),
      ngayKetThuc: DateFormat('dd/MM/yyyy').format(ngayKetThuc),
    );
  }

  Future<void> createContract({
    required String phongId,
    required String nguoiThueId,
    required DateTime ngayBatDau,
    required DateTime ngayKetThuc,
  }) async {
    try {
      final user = landlordController.currentUser;
      if (user == null) return;

      final existingContract = await _firestore
          .collection('hopDong')
          .where('phongId', isEqualTo: phongId)
          .where('nguoiThueId', isEqualTo: nguoiThueId)
          .where('trangThai', isEqualTo: 'hieuLuc')
          .get();

      if (existingContract.docs.isNotEmpty) {
        throw 'Người thuê này đã có hợp đồng hiệu lực';
      }

      final noiDung = _generateContractContent(
        phongId: phongId,
        nguoiThueId: nguoiThueId,
        ngayBatDau: ngayBatDau,
        ngayKetThuc: ngayKetThuc,
      );

      final docRef = await _firestore.collection('hopDong').add({
        'chuTroId': user.uid,
        'phongId': phongId,
        'nguoiThueId': nguoiThueId,
        'ngayBatDau': Timestamp.fromDate(ngayBatDau),
        'ngayKetThuc': Timestamp.fromDate(ngayKetThuc),
        'trangThai': 'hieuLuc',
        'noiDung': noiDung,
        'ngayTao': FieldValue.serverTimestamp(),
        'ngayCapNhat': FieldValue.serverTimestamp(),
      });

      await docRef.update({'id': docRef.id});

      await _firestore.collection('hoatDong').add({
        'chuTroId': user.uid,
        'nguoiThueId': nguoiThueId,
        'phongId': phongId,
        'loai': 'taoHopDong',
        'soPhong': rooms[phongId]?.soPhong,
        'ngayTao': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Thành công',
        'Đã tạo hợp đồng mới',
        snackPosition: SnackPosition.BOTTOM,
      );

      await loadData();
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể tạo hợp đồng: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> terminateContract(String contractId) async {
    try {
      await _firestore.collection('hopDong').doc(contractId).update({
        'trangThai': 'daKetThuc',
        'ngayCapNhat': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Thành công',
        'Đã kết thúc hợp đồng',
        snackPosition: SnackPosition.BOTTOM,
      );

      await loadData();
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể kết thúc hợp đồng: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  PhongModel? getRoomInfo(String roomId) => rooms[roomId];
  UserModel? getTenantInfo(String tenantId) => tenants[tenantId];

  Future<void> refreshData() => loadData();

  Map<String, dynamic> getContractDetails(String contractId) {
    final contract = contracts.firstWhere((c) => c.id == contractId);
    final room = rooms[contract.phongId];
    final tenant = tenants[contract.nguoiThueId];
    final landlord = landlordController.currentUser;

    if (room == null || tenant == null || landlord == null) {
      throw 'Không tìm thấy thông tin hợp đồng';
    }

    return {
      'contract': contract,
      'room': room,
      'tenant': tenant,
      'landlord': landlord,
    };
  }

  Future<void> exportContractPdf(String contractId) async {
    try {
      final contract = contracts.firstWhere((c) => c.id == contractId);
      final room = rooms[contract.phongId];
      if (room == null) throw 'Không tìm thấy thông tin phòng';

      await PdfHelper.generateContractPdf(
        noiDung: contract.noiDung,
        tenHopDong: 'Hop-dong-phong-${room.soPhong}',
      );

      Get.snackbar(
        'Thành công',
        'Đã xuất hợp đồng thành công',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error exporting PDF: $e');
    }
  }
}
