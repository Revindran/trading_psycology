import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trading_psycology/views/auth/auth_controller.dart';

import '../../utils/constants.dart';

final controller = Get.put(AuthController());

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 150,
            width: 150,
            child: CircleAvatar(
              radius: 48, // Image radius
              backgroundImage: AssetImage("assets/logo.PNG"),
            ),
          ),
          vHeight20(),
          Text(
            "Welcome Trader!",
            style: TextStyle(
                color: myColor, fontSize: 26, fontWeight: FontWeight.bold),
          ),
          vHeight20(),
          Obx(
            () => Text(
              controller.signUP.value ? "Signup" : "Login",
              style: TextStyle(
                  color: myColor, fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          vHeight20(),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Email',
              ),
            ),
          ),
          Obx(
            () => controller.signUP.value
                ? Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Column(
                      children: [
                        vHeight20(),
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Name',
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
          ),
          vHeight20(),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Obx(
              () => TextField(
                controller: _passwordController,
                obscureText: controller.showPassword.value,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.showPassword.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () => controller.showPasswordToggle(),
                  ),
                  hintText: 'Enter password',
                ),
              ),
            ),
          ),
          vHeight10(),
          Obx(
            () => !controller.signUP.value
                ? controller.isLoading.value
                    ? CircularProgressIndicator(color: accentColor)
                    : SizedBox(
                        width: Get.width,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0)))),
                            onPressed: () {
                              if (_emailController.text.isNotEmpty &&
                                  _passwordController.text.isNotEmpty) {
                                controller.isLoadingToggle();
                                controller.userSignIn(_emailController.text,
                                    _passwordController.text);
                              } else {
                                Get.snackbar(
                                    "Error", "Fill all the fields to continue!",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white);
                              }
                            },
                            child: const Text('Login'),
                          ),
                        ),
                      )
                : Container(),
          ),
          vHeight10(),
          Obx(
            () => controller.signUP.value
                ? controller.isLoading.value
                    ? CircularProgressIndicator(color: accentColor)
                    : SizedBox(
                        width: Get.width,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0)))),
                            onPressed: () {
                              if (_emailController.text.isNotEmpty &&
                                  _nameController.text.isNotEmpty &&
                                  _passwordController.text.isNotEmpty) {
                                controller.isLoadingToggle();
                                controller.userSignUp(
                                    _emailController.text,
                                    _nameController.text,
                                    _passwordController.text);
                              } else {
                                Get.snackbar(
                                    "Error", "Fill all the fields to continue!",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white);
                              }
                            },
                            child: const Text('Register'),
                          ),
                        ),
                      )
                : Container(),
          ),
          vHeight10(),
          InkWell(
            onTap: () => controller.signUPToggle(),
            child: Obx(
              () => RichText(
                text: TextSpan(
                  text: controller.signUP.value
                      ? "Don't have account? "
                      : "Already have an account? ",
                  style: const TextStyle(color: Colors.blue),
                  children: [
                    TextSpan(
                        text: !controller.signUP.value ? 'Register!' : 'Login',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
