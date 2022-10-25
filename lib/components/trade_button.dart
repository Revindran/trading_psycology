import 'package:flutter/material.dart';

class TradeButton extends StatelessWidget {
  final String result;

  const TradeButton({required this.result, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey, //
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(100),
          color: result == "win"
              ? Colors.green
              : result == "loss"
                  ? Colors.redAccent
                  : Colors.white),
    );
  }
}

class TradeButtonSmall extends StatelessWidget {
  final String result;

  const TradeButtonSmall({required this.result, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right:8.0),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            // border: Border.all(
            //   color: Colors.grey, //
            //   width: 2.0,
            // ),
            borderRadius: BorderRadius.circular(100),
            color: result == "win"
                ? Colors.green
                : result == "loss"
                    ? Colors.redAccent
                    : Colors.white),
      ),
    );
  }
}
