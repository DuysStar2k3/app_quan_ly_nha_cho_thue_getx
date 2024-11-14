import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../data/models/hop_dong_model.dart';
import '../../../../../data/models/phong_model.dart';
import '../../../../../data/models/user_model.dart';
import '../../../../auth/controllers/auth_controller.dart';

class ContractController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final contracts = <HopDongModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadContracts();
  }

  Future<void> loadContracts() async {
    try {
      isLoading.value = true;
      final currentUser = Get.find<AuthController>().currentUser.value;
      if (currentUser == null) return;

      // Lắng nghe thay đổi từ collection hợp đồng
      _firestore
          .collection('hopDong')
          .where('nguoiThueId', isEqualTo: currentUser.uid)
          .snapshots()
          .listen((snapshot) async {
        final contractsList = <HopDongModel>[];
        
        for (var doc in snapshot.docs) {
          final contract = HopDongModel.fromJson({
            'id': doc.id,
            ...doc.data(),
          });
          contractsList.add(contract);
        }
        
        contracts.value = contractsList;
      });
    } catch (e) {
      print('Error loading contracts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<PhongModel?> getRoom(String roomId) async {
    try {
      final doc = await _firestore.collection('phong').doc(roomId).get();
      if (doc.exists) {
        return PhongModel.fromJson({
          'id': doc.id,
          ...doc.data()!,
        });
      }
      return null;
    } catch (e) {
      print('Error getting room: $e');
      return null;
    }
  }

  Future<UserModel?> getLandlord(String landlordId) async {
    try {
      final doc = await _firestore.collection('nguoiDung').doc(landlordId).get();
      if (doc.exists) {
        return UserModel.fromJson({
          'uid': doc.id,
          ...doc.data()!,
        });
      }
      return null;
    } catch (e) {
      print('Error getting landlord: $e');
      return null;
    }
  }
} 