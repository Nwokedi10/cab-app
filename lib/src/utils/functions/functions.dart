import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '/src/utils/utils_barrel.dart';

///file for all #resusable functions
///Guideline: strongly type all variables and functions

abstract class UtilFunctions {
  static const pideg = 180 / pi;

  static PasswordStrength passwordStrengthChecker(String value) {
    value = value.trim();
    final bool passwordHasLetters = Regex.letterReg.hasMatch(value);
    final bool passwordHasNum = Regex.numReg.hasMatch(value);
    final bool passwordHasSpecialChar = Regex.specialCharReg.hasMatch(value);
    if (value.isEmpty) {
      return PasswordStrength.normal;
    } else if (passwordHasLetters && passwordHasNum && passwordHasSpecialChar) {
      return PasswordStrength.strong;
    } else if ((passwordHasLetters && passwordHasNum) ||
        (passwordHasSpecialChar && passwordHasNum) ||
        (passwordHasSpecialChar && passwordHasLetters)) {
      return PasswordStrength.okay;
    } else if (passwordHasLetters ^ passwordHasSpecialChar ^ passwordHasNum) {
      return PasswordStrength.weak;
    } else {
      return PasswordStrength.strong;
    }
  }

  static double deg(double a) => a / pideg;

  static clearTextEditingControllers(List<TextEditingController> conts) {
    for (var i = 0; i < conts.length; i++) {
      conts[i].clear();
    }
  }

  static String moneyRange(num a, num b) {
    return "${a.toCurrency()} - ${b.toCurrency()}";
  }

  static String formatPhone(String phone) {
    switch (phone[0]) {
      case '0':
        return '+234${phone.substring(1)}';
      case '+':
        return phone;
      default:
        return '+234${phone.substring(1)}';
    }
  }

  static String formatFullName(String s) {
    return s.maxLength();
  }

  static bool nullOrEmpty(String? s) {
    return s == null || s.isEmpty;
  }

  static returnNullEmpty(dynamic k, dynamic v) {
    if (k is String || k is List) {
      if (k == null || k.isEmpty) {
        return v;
      }
      return k;
    }
    return k ?? v;
  }

  static List<LatLng> decodeEncodedPolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      LatLng p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }
}
