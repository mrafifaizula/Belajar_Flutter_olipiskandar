import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bismillah/app/data/profile_response.dart';
import 'package:bismillah/app/modules/profile/controllers/profile_controller.dart';
// import 'package:lottie/lottie.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Text(
          'ProfileView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.logout,
        child: const Icon(Icons.logout),
      ),
    );
  }
}
