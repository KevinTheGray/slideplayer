import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slides/utils/align_utils.dart';
import 'package:flutter_slides/utils/color_utils.dart';
import 'package:flutter_slides/workspace/content_value_editors/content_value_editor_controller.dart';
import 'package:flutter_slides/workspace/select_color_screen.dart';
import 'package:flutter_slides/workspace/select_fixed_values_screen.dart';

class LabelContentEditor extends StatefulWidget {
  final Map content;
  final void Function() onUpdated;
  final ContentValueEditorController controller;

  const LabelContentEditor({
    Key key,
    this.content,
    this.onUpdated,
    this.controller,
  }) : super(key: key);

  @override
  _LabelContentEditorState createState() => _LabelContentEditorState();
}

class _LabelContentEditorState extends State<LabelContentEditor>
    implements ContentValueEditorControllerListener {
  TextEditingController textController = TextEditingController();
  TextEditingController fontColorController = TextEditingController();
  TextEditingController fontSizeController = TextEditingController();
  TextEditingController lineHeightController = TextEditingController();
  TextEditingController letterSpacingController = TextEditingController();
  TextEditingController textAlignController = TextEditingController();
  TextEditingController fontFamilyController = TextEditingController();
  TextEditingController alignController = TextEditingController();
  bool italic;
  bool strikeThrough;

  @override
  Widget build(BuildContext context) {
    widget.controller.listener = this;
    textController.text = widget.content['text'].toString();
    fontColorController.text = widget.content['font_color'] ?? '';
    fontSizeController.text = widget.content['font_size'].toString();
    alignController.text = widget.content['align'] ?? 'center';
    textAlignController.text = widget.content['text_align'] ?? 'start';
    fontFamilyController.text = widget.content['font_family'] ?? '';
    letterSpacingController.text =
        (widget.content['letter_spacing'] ?? 0.0).toString();
    lineHeightController.text =
        (widget.content['line_height'] ?? 0.0).toString();
    italic = widget.content['italic'] ?? false;
    strikeThrough = widget.content['strike_through'] ?? false;
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('Text: '),
            Expanded(
              child: TextField(
                focusNode: FocusNode(onKey: (node, event) {
                  if (event.data is RawKeyEventDataMacOs) {
                    final data = event.data as RawKeyEventDataMacOs;
                    if (event.isMetaPressed && data.keyCode == 36) {
                      node.unfocus();
                      widget.onUpdated();
                    }
                  }
                  return true;
                }),
                controller: textController,
                maxLines: null,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text('Font Color: '),
            Expanded(
              child: TextField(
                controller: fontColorController,
                onSubmitted: (val) {
                  widget.onUpdated();
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
                    fontColorController.value =
                        TextEditingValue(text: result);
                    widget.onUpdated();
                  }
                },
                child: Container(
                  width: 48.0,
                  height: 48.0,
                  child: Icon(
                    Icons.palette,
                    color: colorFromString(fontColorController.text),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text('Font Size: '),
            Expanded(
              child: TextField(
                controller: fontSizeController,
                onSubmitted: (value) {
                  widget.onUpdated();
                },
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text('Letter Spacing: '),
            Expanded(
              child: TextField(
                controller: letterSpacingController,
                onSubmitted: (value) {
                  widget.onUpdated();
                },
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text('Line Height: '),
            Expanded(
              child: TextField(
                controller: lineHeightController,
                onSubmitted: (value) {
                  widget.onUpdated();
                },
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text('Text Align: '),
            Expanded(
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  child: Text(textAlignController.text),
                  onTap: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: SelectFixedValuesScreen(
                            data: {
                              'start': null,
                              'center': null,
                              'end': null,
                            },
                          ),
                        );
                      },
                    );
                    if (result != null) {
                      textAlignController.value =
                          TextEditingValue(text: result);
                      widget.onUpdated();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text('Align: '),
            Expanded(
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  child: Text(alignController.text),
                  onTap: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: SelectFixedValuesScreen(
                            data: alignMap,
                          ),
                        );
                      },
                    );
                    if (result != null) {
                      alignController.value = TextEditingValue(text: result);
                      widget.onUpdated();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text('Font Family: '),
            Expanded(
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  child: Text(fontFamilyController.text),
                  onTap: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: SelectFixedValuesScreen(
                            data: {
                              'GoogleSans': null,
                              'RobotoMono': null,
                            },
                          ),
                        );
                      },
                    );
                    if (result != null) {
                      fontFamilyController.value =
                          TextEditingValue(text: result);
                      widget.onUpdated();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text('Italic: '),
            Checkbox(
              value: italic,
              onChanged: (value) {
                italic = value;
                widget.onUpdated();
              },
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text('Strike Through: '),
            Checkbox(
              value: strikeThrough,
              onChanged: (value) {
                strikeThrough = value;
                widget.onUpdated();
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Map getContentValues() {
    return {
      'text': textController.text,
      'font_color': fontColorController.text,
      'font_size': num.tryParse(fontSizeController.text) ?? 60.0,
      'text_align': textAlignController.text,
      'font_family': fontFamilyController.text,
      'line_height': num.tryParse(lineHeightController.text) ?? 0.0,
      'letter_spacing': num.tryParse(letterSpacingController.text) ?? 1.0,
      'align': alignController.text,
      'italic': italic,
      'strike_through': strikeThrough,
    };
  }
}
