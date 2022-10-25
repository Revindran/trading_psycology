import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../home/home_screen.dart';

class AuthController extends GetxController {
  final _instance = FirebaseFirestore.instance;
  final isLoading = false.obs;
  final showPassword = true.obs;
  final signUP = false.obs;
  var storage = GetStorage();

  showPasswordToggle() => showPassword.value = !showPassword.value;

  signUPToggle() => signUP.value = !signUP.value;

  isLoadingToggle() => isLoading.value = !isLoading.value;

  Future<void> userSignIn(String email, String pass) async {
    try {
      _instance.collection('users').doc(email).get().then((value) {
        if (value.exists) {
          var password = value['password'];
          if (kDebugMode) {
            print("password $password");
          }
          if (pass == password) {
            var name = value['name'];
            var email = value['email'];
            storage.write('name', name);
            storage.write('email', email);
            Get.offAll(() => const HomeScreen());
          } else {
            isLoadingToggle();
            Get.snackbar('Error', 'Wrong Password',
                duration: const Duration(seconds: 1),
                snackPosition: SnackPosition.BOTTOM);
          }
        } else {
          isLoadingToggle();
          Get.snackbar('Error', "User Not Found",
              duration: const Duration(seconds: 1),
              snackPosition: SnackPosition.BOTTOM);
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      isLoadingToggle();
      Get.snackbar('Error', "User Not Found",
          duration: const Duration(seconds: 1),
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> userSignUp(String email, String name, String pass) async {
    Map<String, dynamic> data;
    try {
      data = {
        "name": name,
        "email": email,
        "password": pass,
      };
      _instance.collection('users').doc(email).set(data).then((value) => {
            storage.write('name', name),
            storage.write('email', email),
            Get.offAll(() => const HomeScreen()),
          });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      isLoadingToggle();
      Get.snackbar('Something Wrong!', "$e",
          duration: const Duration(seconds: 1),
          snackPosition: SnackPosition.TOP);
    }
  }
}
