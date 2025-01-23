import 'package:get/get.dart';
import 'package:bismillah/app/modules/dashboard/views/index_view.dart';
import 'package:bismillah/app/modules/dashboard/views/your_event_view.dart';
import 'package:bismillah/app/modules/dashboard/views/profile_view.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:bismillah/app/utils/api.dart';
import 'package:bismillah/app/data/event_response.dart';
import 'package:flutter/material.dart';
import 'package:bismillah/app/data/detail_event_response.dart';

class DashboardController extends GetxController {
  var selectedIndex = 0.obs;
  final _getConnect = GetConnect();
  final token = GetStorage().read('token');
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController eventDateController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  // untuk logout
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

  // Fungsi buat hapus event, tinggal kasih ID-nya
  void deleteEvent({required int id}) async {
    final response = await _getConnect.post(
      '${BaseUrl.deleteEvents}$id', 
      {
        '_method': 'delete',
      },
      headers: {
        'Authorization': "Bearer $token"
      },
      contentType: "application/json",
    );

    if (response.statusCode == 200) {
      Get.snackbar(
        'Success',
        'Event Deleted',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green, 
        colorText: Colors.white, 
      );

      update(); 
      getEvent();
      getYourEvent(); 
    } else {
      Get.snackbar(
        'Failed',
        'Event Failed to Delete', 
        snackPosition: SnackPosition.BOTTOM, 
        backgroundColor: Colors.red,
        colorText: Colors.white, 
      );
    }
  }

  // Fungsi buat edit data event, tinggal panggil terus kasih ID-nya
  void editEvent({required int id}) async {
    final response = await _getConnect.post(
      '${BaseUrl.events}/$id',
      {
        'name': nameController.text,
        'description': descriptionController.text,
        'event_date': eventDateController.text, 
        'location': locationController.text,
        '_method': 'PUT', 
      },
      headers: {'Authorization': "Bearer $token"},
      contentType: "application/json", 
    );

    if (response.statusCode == 200) {
      Get.snackbar(
        'Success', 
        'Event Updated',
        snackPosition: SnackPosition.BOTTOM, 
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      nameController.clear();
      descriptionController.clear();
      eventDateController.clear();
      locationController.clear();

      update();
      getEvent(); 
      getYourEvent(); 
      Get.close(1);
    } else {
      Get.snackbar(
        'Failed',
        'Event Failed to Update', 
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red, 
        colorText: Colors.white,
      );
    }
  }

  Future<DetailEventResponse> getDetailEvent({required int id}) async {
    final response = await _getConnect.get(
      '${BaseUrl.detailEvents}/$id',
      headers: {
        'Authorization': "Bearer $token"
      },
      contentType: "application/json",
    );
    return DetailEventResponse.fromJson(response.body);
  }

  void addEvent() async {
    final response = await _getConnect.post(
      BaseUrl.events, 
      {
        'name': nameController.text, 
        'description': descriptionController.text,
        'event_date': eventDateController.text,
        'location': locationController.text,
      },
      headers: {
        'Authorization': "Bearer $token"
      },
      contentType: "application/json",
    );

    if (response.statusCode == 201) {
      Get.snackbar(
        'Success', 
        'Event Added',
        snackPosition: SnackPosition.BOTTOM, 
        backgroundColor: Colors.green,
        colorText: Colors.white, 
      );
      nameController.clear();
      descriptionController.clear();
      eventDateController.clear();
      locationController.clear();
      update(); 
      getEvent(); 
      getYourEvent();
      Get.close(1); 
    } else {
      Get.snackbar(
        'Failed',
        'Event Failed to Add', 
        snackPosition: SnackPosition.BOTTOM, 
        backgroundColor: Colors.red,
        colorText: Colors.white, 
      );
    }
  }

  Future<EventResponse> getEvent() async {
    final response = await _getConnect.get(
      BaseUrl.events,
      headers: {'Authorization': "Bearer $token"},
      contentType: "application/json",
    );
    return EventResponse.fromJson(response.body);
  }

  var yourEvents = <Events>[].obs;

  Future<void> getYourEvent() async {
    final response = await _getConnect.get(
      BaseUrl.yourEvent,
      headers: {'Authorization': "Bearer $token"},
      contentType: "application/json",
    );
    final eventResponse = EventResponse.fromJson(response.body);
    yourEvents.value = eventResponse.events ?? [];
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  final List<Widget> pages = [
    IndexView(),
    YourEventView(),
    ProfileView(),
  ];

  @override
  void onInit() {
    super.onInit();
    getEvent();
    getYourEvent();
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
