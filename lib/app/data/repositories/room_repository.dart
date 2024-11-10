import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/phong_model.dart';

class RoomRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream để lắng nghe thay đổi danh sách phòng
  Stream<List<PhongModel>> getRooms(String chuTroId) {
    return _firestore
        .collection('phong')
        .where('chuTroId', isEqualTo: chuTroId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return PhongModel.fromJson({
          'id': doc.id,
          ...doc.data(),
        });
      }).toList();
    });
  }

  // Thêm phòng mới
  Future<PhongModel> addRoom(PhongModel room) async {
    final docRef = _firestore.collection('phong').doc();
    
    final newRoom = room.copyWith(id: docRef.id);
    
    final data = newRoom.toJson();
    data['id'] = docRef.id;
    await docRef.set(data);
    
    return newRoom;
  }

  // Cập nhật phòng
  Future<void> updateRoom(PhongModel room) async {
    await _firestore.collection('phong').doc(room.id).update({
      'soPhong': room.soPhong,
      'tang': room.tang,
      'dichVu': room.dichVu,
      'loaiPhong': room.loaiPhong,
      'trangThai': room.trangThai,
      'dienTich': room.dienTich,
      'giaThue': room.giaThue,
      'tienCoc': room.tienCoc,
      'tienNghi': room.tienNghi,
      'hinhAnh': room.hinhAnh,
      'nguoiThueHienTai': room.nguoiThueHienTai,
      'congTo': room.congTo.toJson(),
      'ngayCapNhat': Timestamp.fromDate(room.ngayCapNhat),
    });
  }

  // Xóa phòng
  Future<void> deleteRoom(String roomId) async {
    await _firestore.collection('phong').doc(roomId).delete();
  }
} 