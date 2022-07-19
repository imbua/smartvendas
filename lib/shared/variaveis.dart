import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter =
    NumberFormat.currency(locale: "pt_Br", symbol: '', decimalDigits: 2);

const Color corBotao = Color(0xff46997D);
const Color corText = Color(0xff317183);
const Color corRodape =
    Color.fromARGB(255, 112, 118, 122); // Color.fromARGB(255, 138, 169, 194);
final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  // primary: Colors.black87,
  // padding: const EdgeInsets.symmetric(horizontal: 16.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(4.0),
    ),
  ),
);
