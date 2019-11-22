import 'package:flutter/material.dart';

Map<String, BoxFit> boxFitMap = {
  'cover': BoxFit.cover,
  'contain': BoxFit.contain,
};

BoxFit boxFitFromString(String string) {
  return boxFitMap[string ?? ''] ?? BoxFit.contain;
}
