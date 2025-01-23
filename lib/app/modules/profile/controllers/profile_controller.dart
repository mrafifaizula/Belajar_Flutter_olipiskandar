import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class ProfileController extends GetxController {
  //TODO: Implement ProfileController

  final count = 0.obs;

  void logOut() async {
    final response = await _getConnect.post(
      BaseUrl.logout,
      {},
      headers: {'Authorization': "Bearer $token"},
      contentType: "application/json",
    );

    // Kalau server bilang logout sukses
    if (response.statusCode == 200) {
      Get.snackbar(
        'Success',
        'Logout Success',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      GetStorage().erase();

      Get.offAllNamed('/login');
    } else {
      Get.snackbar(
        'Failed',
        'Logout Failed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
