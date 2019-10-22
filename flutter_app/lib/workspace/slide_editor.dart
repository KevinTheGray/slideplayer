import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slides/models/slide.dart';
import 'package:flutter_slides/workspace/content_editor.dart';

extension ColorDude on Color {
  toHexString() => '0x${value.toRadixString(16).padLeft(8, '0')}'.toUpperCase();
}

class SlideEditor extends StatefulWidget {
  final Slide slide;
  final void Function(Map) onUpdated;

  const SlideEditor({
    Key key,
    this.slide,
    this.onUpdated,
  }) : super(key: key);
  @override
  _SlideEditorState createState() => _SlideEditorState();
}

class _SlideEditorState extends State<SlideEditor> {
  TextEditingController bgColorController = TextEditingController();
  TextEditingController advCountController = TextEditingController();
  bool animatedTransitionState;
  List<dynamic> currentContentState;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    bgColorController.text = widget.slide.backgroundColor.toHexString();
    advCountController.text = widget.slide.advancementCount.toString();
    animatedTransitionState = widget.slide.animatedTransition;
    currentContentState = widget.slide.content;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text('Background Color:'),
        TextField(
          controller: bgColorController,
          onSubmitted: (val) {
            update();
          },
        ),
        Text('Advancement Count:'),
        TextField(
          controller: advCountController,
          onSubmitted: (val) {
            update();
          },
        ),
        Text('Animated Transition:'),
        Checkbox(
          value: animatedTransitionState,
          onChanged: (value) {
            animatedTransitionState = value;
            update();
          },
        ),
        Text('Content:'),
        ...List<Widget>.generate(
          widget.slide.content.length,
          (index) {
            return ContentEditor(
              content: widget.slide.content[index],
              onUpdated: (map) {
                currentContentState = List()..addAll(currentContentState);
                currentContentState[index] = map;
                update();
              },
            );
          },
        ),
      ],
    );
  }

  void update() {
    widget.onUpdated({
      "bg_color": "${bgColorController.value.text}",
      'advancement_count': int.tryParse(advCountController.value.text) ?? 0,
      'animated_transition': animatedTransitionState,
      'notes': widget.slide.notes,
      "content": currentContentState,
    });
  }
}
