import 'package:flutter/material.dart';
import 'package:flutter_slides/workspace/content_value_editors/content_value_editor_controller.dart';

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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text('Fill:'),
        Expanded(
          child: TextField(
            controller: fillController,
            onSubmitted: (val) {
              if (widget.onUpdated != null) {
                widget.onUpdated();
              }
            },
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
