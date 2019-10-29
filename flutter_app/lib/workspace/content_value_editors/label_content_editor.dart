import 'package:flutter/material.dart';
import 'package:flutter_slides/workspace/content_value_editors/content_value_editor_controller.dart';


//font_color
//font_size
//line_height
//letter_spacing
//text_align
//font_family
//strike_through
//italic
//align

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
  @override
  Widget build(BuildContext context) {
    widget.controller.listener = this;
    textController.text = widget.content['text'].toString();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text('Text:'),
        Expanded(
          child: TextField(
            controller: textController,
            onSubmitted: (val) {
              widget.onUpdated();
            },
          ),
        ),
      ],
    );
  }

  @override
  Map getContentValues() {
    return {
      'text': textController.text,
    };
  }
}
