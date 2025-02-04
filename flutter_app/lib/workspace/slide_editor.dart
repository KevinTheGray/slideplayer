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
  List<TextEditingController> notesControllers = [];
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
    notesControllers.clear();
    final List notes = widget.slide.notes;
    for (int i = 0; i < widget.slide.notes.length; i++) {
      notesControllers.add(TextEditingController(text: notes[i]));
    }

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
        ExpansionTile(title: Text('Notes:'), children: [
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
                      notesControllers.add(TextEditingController());
                      update();
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.add,
                          color: Colors.lightBlueAccent,
                        ),
                        Text('Add'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...List<Widget>.generate(
            notesControllers.length,
            (i) {
              return buildNotesField(notesControllers[i], onDelete: () {
                notesControllers.removeAt(i);
                update();
              });
            },
          ),
        ]),
      ],
    );
  }

  Widget buildNotesField(
    TextEditingController notesController, {
    @required VoidCallback onDelete,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 30.0),
      child: Row(
        children: <Widget>[
          Expanded(
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
                  } else if (data.keyCode == 9) {
                    if (event.isMetaPressed) {
                      (Clipboard.getData('text/plain')).then((val) {
                        if (val != null && val.text != null) {
                          print(val.text);
                          notesController.value = TextEditingValue(
                              text: notesController.value.text + val.text);
                          notesController.selection = TextSelection.collapsed(
                              offset: notesController.text.length);
                        }
                      });
                    }
                  } else if (data.keyCode == 8) {
                    if (event.isMetaPressed) {
                      final String text = notesController.selection
                          .textInside(notesController.text);
                      if (text.length > 0) {
                        Clipboard.setData(ClipboardData(text: text));
                      }
                    }
                  }
                }
                return true;
              }),
              controller: notesController,
              maxLines: null,
            ),
          ),
          Container(
            height: 40.0,
            width: 40.0,
            child: MaterialButton(
              onPressed: () async {
                onDelete();
              },
              child: Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void update() {
    widget.onUpdated({
      "bg_color": "${bgColorController.value.text}",
      'advancement_count': int.tryParse(advCountController.value.text) ?? 0,
      'animated_transition': animatedTransitionState,
      'notes': List<String>.generate(
          notesControllers.length, (i) => notesControllers[i].text),
      "content": currentContentState,
    });
  }
}
