import 'package:flutter_slides/models/slide_factors.dart';
import 'package:flutter/material.dart';

class Slide {
  final List<dynamic> content;
  final int advancementCount;
  final Color backgroundColor;
  final SlideFactors slideFactors;
  final bool animatedTransition;
  final List<dynamic> notes;

  Slide({
    @required this.content,
    @required this.slideFactors,
    @required this.advancementCount,
    @required this.backgroundColor,
    @required this.animatedTransition,
    @required this.notes,
  });
}
