// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/dich_vu_model.dart';

// class ServiceRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Lấy danh sách dịch vụ của chủ trọ
//   Stream<List<DichVuModel>> getServices(String chuTroId) {
//     return _firestore
//         .collection('dichVu')
//         .where('chuTroId', isEqualTo: chuTroId)
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs.map((doc) {
//         return DichVuModel.fromJson({
//           'id': doc.id,
//           ...doc.data(),
//         });
//       }).toList();
//     });
//   }

//   // Thêm dịch vụ mới
//   Future<DichVuModel> addService(DichVuModel service) async {
//     // Tạo document reference mới với ID tự động
//     final docRef = _firestore.collection('dichVu').doc();
    
//     // Tạo service mới với ID từ docRef
//     final newService = service.copyWith(id: docRef.id);
    
//     // Lưu dữ liệu với ID đã được tạo
//     final data = newService.toJson();
//     data['id'] = docRef.id; // Đảm bảo ID được lưu trong document
//     await docRef.set(data);
    
//     return newService;
//   }

//   // Cập nhật dịch vụ
//   Future<void> updateService(DichVuModel service) async {
//     await _firestore
//         .collection('dichVu')
//         .doc(service.id)
//         .update({
//           'tenDichVu': service.tenDichVu,
//           'gia': service.gia,
//           'donVi': service.donVi,
//           'ngayCapNhat': Timestamp.fromDate(service.ngayCapNhat),
//         });
//   }

//   // Xóa dịch vụ
//   Future<void> deleteService(String serviceId) async {
//     await _firestore
//         .collection('dichVu')
//         .doc(serviceId)
//         .delete();
//   }
// } 