import 'package:flutter/material.dart';
import 'package:flutter_slides/utils/color_utils.dart';
import 'package:flutter_slides/workspace/content_value_editors/content_value_editor_controller.dart';
import 'package:flutter_slides/workspace/select_color_screen.dart';

class RectContentEditor extends StatefulWidget {
  final Map content;
  final void Function() onUpdated;
  final ContentValueEditorController controller;

  const RectContentEditor({
    Key key,
    this.content,
    this.onUpdated,
    this.controller,
  }) : super(key: key);

  @override
  _RectContentEditorState createState() => _RectContentEditorState();
}

class _RectContentEditorState extends State<RectContentEditor>
    implements ContentValueEditorControllerListener {
  TextEditingController fillController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    widget.controller.listener = this;
    Map content = widget.content ?? {};
    fillController.text = (content['fill'] ?? '0xFFFFFFFF').toString();
    return Row(
      children: <Widget>[
        Text('Fill: '),
        Expanded(
          child: TextField(
            controller: fillController,
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
                fillController.value =
                    TextEditingValue(text: result);
                widget.onUpdated();
              }
            },
            child: Container(
              width: 48.0,
              height: 48.0,
              child: Icon(
                Icons.palette,
                color: colorFromString(fillController.text),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Map getContentValues() {
    return {
      'fill': fillController.text,
    };
  }
}
