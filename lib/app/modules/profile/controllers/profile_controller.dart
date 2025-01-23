import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:bismillah/app/data/profile_response.dart';
import 'package:bismillah/app/utils/api.dart';

class ProfileController extends GetxController {
  //TODO: Implement ProfileController
  final box = GetStorage();
  final _getConnect = GetConnect();
  final token = GetStorage().read('token');
  final isLoading = false.obs;

  @override
  void onInit() {
    getProfile();
    super.onInit();
  }

  Future<ProfilResponse> getProfile() async {
    try {
      final response = await _getConnect.get(
        BaseUrl.profile,
        headers: {'Authorization': "Bearer $token"},
        contentType: "application/json",
      );

      if (response.statusCode == 200) {
        return ProfilResponse.fromJson(response.body);
      } else {
        throw Exception("Failed to load profile: ${response.statusText}");
      }
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  void logout() {
    box.remove('token');
    Get.offAllNamed('/login');
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
