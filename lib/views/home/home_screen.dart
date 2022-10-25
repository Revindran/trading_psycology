import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:trading_psycology/components/small_button_list_widget.dart';
import 'package:trading_psycology/components/trade_button.dart';
import 'package:trading_psycology/utils/constants.dart';
import 'package:trading_psycology/views/home/home_controller.dart';

import '../../components/custom_appbar.dart';

var storage = GetStorage();
var name = storage.read('name');
var email = storage.read('email');
final _fireStoreInstance = FirebaseFirestore.instance;

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: "Hello, $name",
        height: 120,
        plusButtonHide: false,
      ),
      body: Column(
        children: [
          vHeight20(),
          StreamBuilder<QuerySnapshot>(
              stream: _fireStoreInstance
                  .collection('users')
                  .doc(email)
                  .collection("history")
                  .doc("dateWise")
                  .collection(todayDate())
                  .snapshots(),
              builder: (context, querySnapshot) {
                if (querySnapshot.hasError) {
                  return const Center(child: Text('Has Error'));
                }
                if (querySnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(color: accentColor));
                }
                if (querySnapshot.data == null) {
                  return const Center(child: Text('Empty Data'));
                }
                if (querySnapshot.data!.size == 0) {
                  return Obx(
                    () => Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey)),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                              "You have ${controller.tradeCount.value} trades left for the day"),
                        )),
                  );
                } else {
                  return Obx(
                    () => Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "You have ${controller.tradeCount.value - querySnapshot.data!.docs.length} ${(controller.tradeCount.value - querySnapshot.data!.docs.length) <= 1 ? "trade" : "trades"} left for the day"),
                        )),
                  );
                }
              }),
          vHeight20(),
          Obx(
            () => RichText(
              text: TextSpan(
                text: 'Total P/L for the day - ',
                style: const TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: '\$ ${controller.todayPAndL.value}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: controller.todayPAndL.value > 0
                              ? Colors.green
                              : Colors.red)),
                ],
              ),
            ),
          ),
          vHeight20(),
          StreamBuilder<QuerySnapshot>(
            stream: _fireStoreInstance
                .collection('users')
                .doc(email)
                .collection("history")
                .doc("dateWise")
                .collection(todayDate())
                .orderBy('timeStamp', descending: false)
                .snapshots(),
            // ignore: missing_return
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> querySnapshot) {
              if (querySnapshot.hasError) {
                return const Center(child: Text('Has Error'));
              }
              if (querySnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(color: accentColor));
              }
              if (querySnapshot.data == null) {
                return const Center(child: Text('Empty Data'));
              }
              if (querySnapshot.data!.size == 0) {
                return InkWell(
                  onTap: () => _dialog(context),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey, //
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(100)),
                    child: const Center(
                        child: Icon(
                      Icons.add,
                      color: Colors.white,
                    )),
                  ),
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: querySnapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            DocumentSnapshot ds =
                                querySnapshot.data!.docs[index];
                            return TradeButton(result: ds.get('result'));
                          }),
                    ),
                    Obx(() => querySnapshot.data!.docs.length <
                            controller.tradeCount.value
                        ? InkWell(
                            onTap: () => _dialog(context),
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey, //
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(100)),
                              child: const Center(
                                  child: Icon(
                                Icons.add,
                                color: Colors.white,
                              )),
                            ),
                          )
                        : Container()),
                  ],
                );
              }
            },
          ),
          vHeight20(),
          const Divider(),
          vHeight10(),
          Center(
              child: Text("Your trades History",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: myColor))),
          vHeight10(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _fireStoreInstance
                  .collection('users')
                  .doc(email)
                  .collection("history")
                  .doc('dates')
                  .collection('date')
                  .orderBy('timeStamp', descending: true)
                  .snapshots(),
              // ignore: missing_return
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> querySnapshot) {
                if (querySnapshot.hasError) {
                  return const Center(child: Text('Has Error'));
                }
                if (querySnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(color: accentColor));
                }
                if (querySnapshot.data == null) {
                  return const Center(child: Text('Empty Data'));
                }
                if (querySnapshot.data!.size == 0) {
                  return const Center(child: Text('No Trade History'));
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      addAutomaticKeepAlives: true,
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemCount: querySnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = querySnapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: myColor),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                          ds.id == todayDate()
                                              ? "Today ->"
                                              : "${ds.id} ->",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              fontStyle: FontStyle.italic)),
                                      SmallTradeButtonWidget(
                                          id: ds.id,
                                          listData: ds.get('result')),
                                    ],
                                  ),
                                  vHeight10(),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Total P/L for the day - ',
                                      children: [
                                        TextSpan(
                                            text: '\$ ${ds.get('pandl')}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: ds.get('pandl') > 0
                                                    ? Colors.green
                                                    : Colors.red)),
                                      ],
                                    ),
                                  ),
                                  vHeight10(),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future _dialog(context) {
  final controller = Get.put(HomeController());
  final TextEditingController resultController = TextEditingController();
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          //this right here
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text("Enter trade details!",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  vHeight20(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () => InkWell(
                          onTap: () => controller.resultToggle(),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey, //
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.green),
                            child: Center(
                                child: controller.selectResult.value
                                    ? const Icon(
                                        Icons.done_outline,
                                        color: Colors.white,
                                      )
                                    : Container()),
                          ),
                        ),
                      ),
                      Obx(
                        () => InkWell(
                          onTap: () => controller.resultToggle(),
                          child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey, //
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.red),
                              child: Center(
                                  child: controller.selectResult.value
                                      ? Container()
                                      : const Icon(
                                          Icons.done_outline,
                                          color: Colors.white,
                                        ))),
                        ),
                      ),
                    ],
                  ),
                  vHeight20(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Obx(
                      () => TextField(
                        keyboardType: TextInputType.number,
                        controller: resultController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: controller.selectResult.value
                              ? 'Enter the profit amount \$'
                              : 'Enter the loss amount \$',
                        ),
                      ),
                    ),
                  ),
                  vHeight10(),
                  Obx(
                    () => controller.isLoading.value
                        ? const Center(
                            child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ))
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: SizedBox(
                              width: Get.width,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0))),
                                    backgroundColor:
                                        MaterialStateProperty.all(myColor)),
                                onPressed: () => {
                                  if (resultController.text.isNotEmpty)
                                    {
                                      controller.isLoadingToggle(),
                                      controller.addTradeForToday(
                                          controller.selectResult.value
                                              ? "win"
                                              : "loss",
                                          resultController.text)
                                    }
                                  else
                                    {
                                      Get.snackbar("Error",
                                          "Enter P/L field to continue!",
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white),
                                    }
                                },
                                child: const Text(
                                  'Add',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
