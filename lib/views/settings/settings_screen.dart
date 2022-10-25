import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:trading_psycology/components/custom_appbar.dart';
import 'package:trading_psycology/views/auth/login_screen.dart';

import '../../utils/Constants.dart';
import '../home/home_controller.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    var storage = GetStorage();
    final TextEditingController countController = TextEditingController();
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Settings",
        height: 120,
        plusButtonHide: true,
      ),
      body: Column(
        children: [
          vHeight20(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Obx(
              () => TextField(
                keyboardType: TextInputType.number,
                controller: countController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText:
                      'Enter daily trade limit! currently set to - ${controller.tradeCount.value}',
                ),
              ),
            ),
          ),
          vHeight10(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: Get.width,
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0))),
                    backgroundColor: MaterialStateProperty.all(myColor)),
                onPressed: () {
                  if (countController.text.isNotEmpty) {
                    storage.write('count', countController.text);
                    controller.changeTradeCount();
                    Get.snackbar(
                        'update success', "trade count updated successfully",
                        duration: const Duration(seconds: 1),
                        snackPosition: SnackPosition.BOTTOM);
                    Navigator.of(context).pop();
                  } else {
                    Get.snackbar('Fill', "Please fill the count to continue!",
                        duration: const Duration(seconds: 1),
                        snackPosition: SnackPosition.BOTTOM);
                  }
                },
                child: const Text(
                  'Change',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: Get.width,
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0))),
                    backgroundColor: MaterialStateProperty.all(myColor)),
                onPressed: () {
                  storage.write('email', null);
                  Get.offAll(() => Login());
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          vHeight20(),
        ],
      ),
    );
  }
}
