import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget vHeight20() {
  return const SizedBox(
    height: 20,
  );
}

Widget vHeight10() {
  return const SizedBox(
    height: 10,
  );
}

Map<int, Color> color = {
  50: const Color.fromRGBO(4, 131, 184, .1),
  100: const Color.fromRGBO(4, 131, 184, .2),
  200: const Color.fromRGBO(4, 131, 184, .3),
  300: const Color.fromRGBO(4, 131, 184, .4),
  400: const Color.fromRGBO(4, 131, 184, .5),
  500: const Color.fromRGBO(4, 131, 184, .6),
  600: const Color.fromRGBO(4, 131, 184, .7),
  700: const Color.fromRGBO(4, 131, 184, .8),
  800: const Color.fromRGBO(4, 131, 184, .9),
  900: const Color.fromRGBO(4, 131, 184, 1),
};

MaterialColor myColor = MaterialColor(0xFF4a76b8, color);
MaterialColor halfWhile = MaterialColor(0xFF0D151E, color);

Color bgWhite = const Color(0xFFEFEEFF);
Color accentColor = const Color(0xFF4a76b8);

String todayDate() {
  final now = DateTime.now();
  var formatter = DateFormat('EEEE, d LLLL yyyy');
  String formattedDate = formatter.format(now);
  return formattedDate;
}
