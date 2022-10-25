import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:trading_psycology/utils/constants.dart';

class HomeController extends GetxController {
  final tradeCount = 3.obs;
  final selectResult = true.obs;

  final isLoading = false.obs;
  final _instance = FirebaseFirestore.instance;
  final database = FirebaseDatabase.instance;
  var storage = GetStorage();

  RxInt todayPAndL = 0.obs;

  RxList allHistory = [].obs;

  List<DocumentSnapshot> data = [];

  resultToggle() => selectResult.value = !selectResult.value;

  changeTradeCount() {
    tradeCount.value = int.parse(storage.read('count'));
  }

  @override
  void onInit() {
    super.onInit();
    if (storage.read('count') != null) {
      tradeCount.value = int.parse(storage.read('count'));
    } else {
      tradeCount.value = 3;
    }

    todayPAndL.value = 0;
    allHistory.value = [];
    getTodayPAndL();
  }

  isLoadingToggle() => isLoading.value = !isLoading.value;

  Future<void> addTradeForToday(String result, String pAndL) async {
    var email = storage.read('email');
    Map<String, dynamic> data;
    try {
      data = {
        "date": todayDate(),
        "timeStamp": Timestamp.now(),
        "result": result,
        "pandl": pAndL
      };
      _instance
          .collection('users')
          .doc(email)
          .collection("history")
          .doc("dateWise")
          .collection(todayDate())
          .add(data)
          .then((value) => {
                addData(result, pAndL),
                Get.back(),
                isLoadingToggle(),
                Get.snackbar('update success', "update success done!",
                    duration: const Duration(seconds: 1),
                    snackPosition: SnackPosition.BOTTOM),
                todayPAndL.value = 0,
                getTodayPAndL(),
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

  addData(String result, String pAndL) {
    Map<String, dynamic> data;
    var email = storage.read('email');
    var l = [];
    _instance
        .collection('users')
        .doc(email)
        .collection("history")
        .doc('dates')
        .collection('date')
        .doc(todayDate())
        .get()
        .then((value) => {
              if (value.exists)
                {
                  l = value.get('result'),
                  l.add(result),
                  _instance
                      .collection('users')
                      .doc(email)
                      .collection("history")
                      .doc('dates')
                      .collection('date')
                      .doc(todayDate())
                      .update({"result": l, "pandl": todayPAndL.value}),
                }
              else
                {
                  data = {
                    "date": todayDate(),
                    "timeStamp": Timestamp.now(),
                    "result": [result],
                    "pandl": todayPAndL.value
                  },
                  _instance
                      .collection('users')
                      .doc(email)
                      .collection("history")
                      .doc('dates')
                      .collection('date')
                      .doc(todayDate())
                      .set(data),
                }
            });
  }

  updatePandL() {
    var email = storage.read('email');
  }

  getTodayPAndL() {
    todayPAndL.value = 0;
    var email = storage.read('email');
    _instance
        .collection('users')
        .doc(email)
        .collection("history")
        .doc("dateWise")
        .collection(todayDate())
        .get()
        .then((value) {
      for (var element in value.docs) {
        if (element['result'] == "win") {
          todayPAndL.value = todayPAndL.value + int.parse(element['pandl']);
        } else {
          todayPAndL.value = todayPAndL.value - int.parse(element['pandl']);
        }
      }
      update();
    });
  }
}
