import 'package:flutter/material.dart';

Color getAqiColor(int aqi) {
  switch (aqi) {
    case 1:
      return Colors.green;
    case 2:
      return Colors.yellow;
    case 3:
      return Colors.orange;
    case 4:
      return Colors.red;
    case 5:
      return Colors.purple;
    default:
      return Colors.grey;
  }
}

LinearGradient getAqiGradient(int aqi) {
  switch (aqi) {
    case 1:
      return LinearGradient(
        colors: [Colors.green.shade700, Colors.green.shade900],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    case 2:
      return const LinearGradient(
        colors: [Colors.lightGreen, Colors.green],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    case 3:
      return const LinearGradient(
        colors: [Colors.yellow, Colors.orange],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    case 4:
      return const LinearGradient(
        colors: [Colors.orange, Colors.deepOrange],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    case 5:
      return const LinearGradient(
        colors: [Colors.red, Colors.redAccent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    default:
      return const LinearGradient(
        colors: [Colors.white, Colors.white],
      );
  }
}