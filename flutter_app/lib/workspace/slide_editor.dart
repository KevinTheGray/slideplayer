import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slides/models/slide.dart';
import 'package:flutter_slides/utils/color_utils.dart';
import 'package:flutter_slides/workspace/add_content_type_screen.dart';
import 'package:flutter_slides/workspace/content_editor.dart';
import 'package:flutter_slides/workspace/select_color_screen.dart';
import 'package:flutter_slides/workspace/select_fixed_values_screen.dart';

extension ColorDude on Color {
  toHexString() => '0x${value.toRadixString(16).padLeft(8, '0')}'.toUpperCase();
  toPrettyHexString() =>
      '#${value.toRadixString(16).padLeft(8, '0')}'.toUpperCase();
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
  TextEditingController notesController = TextEditingController();
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
    notesController.text = widget.slide.notes;
    animatedTransitionState = widget.slide.animatedTransition;
    currentContentState = widget.slide.content;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ExpansionTile(
          title: Text('Slide Options'),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('Background Color: '),
                      Expanded(
                        child: TextField(
                          controller: bgColorController,
                          onSubmitted: (val) {
                            update();
                          },
                        ),
                      ),
                      Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () async {
                            final result = await showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: SelectColorScreen(),
                                );
                              },
                            );
                            if (result != null) {
                              bgColorController.value =
                                  TextEditingValue(text: result);
                              update();
                            }
                          },
                          child: Container(
                            width: 48.0,
                            height: 48.0,
                            child: Icon(
                              Icons.palette,
                              color: colorFromString(bgColorController.text),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('Animated Transition:'),
                      Checkbox(
                        value: animatedTransitionState,
                        onChanged: (value) {
                          animatedTransitionState = value;
                          update();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('Content'),
          children: [
            Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(),
                        ),
                        Container(
                          height: 40.0,
                          child: MaterialButton(
                            onPressed: () async {
                              final result = await showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: AddContentTypeScreen(),
                                  );
                                },
                              );
                              if (result != null) {
                                currentContentState.add(result);
                                update();
                              }
                            },
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.add,
                                  color: Colors.lightBlueAccent,
                                ),
                                Text('Add Content'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text('Advancement Count: '),
                      Expanded(
                        child: TextField(
                          controller: advCountController,
                          onSubmitted: (val) {
                            update();
                          },
                        ),
                      ),
                    ],
                  ),
                  ...List<Widget>.generate(
                    widget.slide.content.length,
                    (index) {
                      return ContentEditor(
                        content: widget.slide.content[index],
                        index: index,
                        onUpdated: (map) {
                          currentContentState = List()
                            ..addAll(currentContentState);
                          if (map != null) {
                            currentContentState[index] = map;
                          } else {
                            currentContentState.removeAt(index);
                          }
                          update();
                        },
                        onMovePosition: (int toPosition) {
                          if (toPosition >= 0 &&
                              toPosition < currentContentState.length) {
                            currentContentState = List()
                              ..addAll(currentContentState);
                            final element = currentContentState.removeAt(index);
                            currentContentState.insert(toPosition, element);
                            update();
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
        ExpansionTile(
          title: Text('Notes:'),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: TextField(
                focusNode: FocusNode(onKey: (node, event) {
                  if (event.data is RawKeyEventDataMacOs) {
                    final data = event.data as RawKeyEventDataMacOs;
                    if (data.keyCode == 36) {
                      if (event.isMetaPressed) {
                        notesController.value = notesController.value
                            .copyWith(text: notesController.value.text + '\n');
                        notesController.selection = TextSelection.collapsed(
                            offset: notesController.text.length);
                      } else {
                        node.unfocus();
                        update();
                      }
                    }
                  }
                  return true;
                }),
                controller: notesController,
                maxLines: null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void update() {
    widget.onUpdated({
      "bg_color": "${bgColorController.value.text}",
      'advancement_count': int.tryParse(advCountController.value.text) ?? 0,
      'animated_transition': animatedTransitionState,
      'notes': notesController.value.text,
      "content": currentContentState,
    });
  }
}
