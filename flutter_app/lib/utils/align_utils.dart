import 'package:flutter/material.dart';

Map<String, Alignment> alignMap = {
  'topLeft': Alignment.topLeft,
  'topCenter': Alignment.topCenter,
  'topRight': Alignment.topRight,
  'centerLeft': Alignment.centerLeft,
  'center': Alignment.center,
  'centerRight': Alignment.centerRight,
  'bottomLeft': Alignment.bottomLeft,
  'bottomCenter': Alignment.bottomCenter,
  'bottomRight': Alignment.bottomRight,
};

Alignment alignmentFromString(String string, {Alignment defaultAlignment}) {
  return alignMap[string ?? ''] ?? defaultAlignment ?? Alignment.center;
}
