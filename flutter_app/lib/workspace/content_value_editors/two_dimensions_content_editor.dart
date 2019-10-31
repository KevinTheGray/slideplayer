import 'package:flutter/material.dart';
import 'package:flutter_slides/workspace/content_value_editors/content_value_editor_controller.dart';

class TwoDimensionsContentEditor extends StatefulWidget {
  final Map content;
  final void Function() onUpdated;
  final ContentValueEditorController controller;

  const TwoDimensionsContentEditor({
    Key key,
    this.content,
    this.onUpdated,
    this.controller,
  }) : super(key: key);

  @override
  _TwoDimensionsContentEditorState createState() => _TwoDimensionsContentEditorState();
}

class _TwoDimensionsContentEditorState extends State<TwoDimensionsContentEditor>
    implements ContentValueEditorControllerListener {
  TextEditingController assetController = TextEditingController();
  TextEditingController animationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    widget.controller.listener = this;
    assetController.text = widget.content['asset'].toString();
    animationController.text = widget.content['animation_name'].toString();
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('Asset:'),
            Expanded(
              child: TextField(
                controller: assetController,
                onSubmitted: (val) {
                  widget.onUpdated();
                },
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text('Animation:'),
            Expanded(
              child: TextField(
                controller: animationController,
                onSubmitted: (val) {
                  widget.onUpdated();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Map getContentValues() {
    return {
      'asset': assetController.text,
      'animation_name': animationController.text,
    };
  }
}
