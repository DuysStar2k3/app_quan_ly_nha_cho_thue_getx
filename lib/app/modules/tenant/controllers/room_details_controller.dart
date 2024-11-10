import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/phong_model.dart';
import '../../../data/models/dich_vu_model.dart';
import '../../../data/models/user_model.dart';

class RoomDetailsController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final services = <DichVuModel>[].obs;
  final isLoading = true.obs;
  final landlordInfo = Rxn<UserModel>();

  late final PhongModel room;

  @override
  void onInit() {
    super.onInit();
    room = Get.arguments;
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        loadServices(),
        loadLandlordInfo(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadServices() async {
    try {
      final serviceIds = room.dichVu;
      
      if (serviceIds.isEmpty) {
        services.value = [];
        return;
      }

      final servicesSnapshot = await _firestore
          .collection('dichVu')
          .where(FieldPath.documentId, whereIn: serviceIds)
          .get();

      services.value = servicesSnapshot.docs
          .map((doc) => DichVuModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      print('Error loading services: $e');
    }
  }

  Future<void> loadLandlordInfo() async {
    try {
      final landlordDoc = await _firestore
          .collection('nguoiDung')
          .doc(room.chuTroId)
          .get();

      if (landlordDoc.exists) {
        landlordInfo.value = UserModel.fromJson({
          'uid': landlordDoc.id,
          ...landlordDoc.data()!,
        });
      }
    } catch (e) {
      print('Error loading landlord info: $e');
    }
  }

  void callLandlord() {
    // TODO: Implement phone call
    final phone = landlordInfo.value?.soDienThoai;
    if (phone != null) {
      // Use url_launcher to make phone call
      // launchUrl(Uri.parse('tel:$phone'));
    }
  }

  void messageLandlord() {
    // TODO: Implement messaging
    final phone = landlordInfo.value?.soDienThoai;
    if (phone != null) {
      // Use url_launcher to send SMS
      // launchUrl(Uri.parse('sms:$phone'));
    }
  }
} 