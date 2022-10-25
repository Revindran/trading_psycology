import 'package:flutter/material.dart';
import 'package:trading_psycology/components/trade_button.dart';

class SmallTradeButtonWidget extends StatelessWidget {
  final String id;
  final List<dynamic> listData;

  const SmallTradeButtonWidget(
      {Key? key, required this.id, required this.listData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: listData.length,
          itemBuilder: (BuildContext context, int index) {
            var ds = listData[index];
            return TradeButtonSmall(result: ds);
          }),
    );
  }
}
