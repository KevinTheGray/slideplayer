import 'package:flutter/material.dart';

class ContentEditor extends StatefulWidget {
  final Map content;
  final void Function(Map) onUpdated;

  const ContentEditor({Key key, this.content, this.onUpdated})
      : super(key: key);

  @override
  _ContentEditorState createState() => _ContentEditorState();
}

class _ContentEditorState extends State<ContentEditor> {
  TextEditingController xPosController = TextEditingController();
  TextEditingController yPosController = TextEditingController();
  TextEditingController widthController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  Map currentContentState;
  @override
  Widget build(BuildContext context) {
    xPosController.text = widget.content['x'].toString();
    yPosController.text = widget.content['y'].toString();
    widthController.text = widget.content['width'].toString();
    heightController.text = widget.content['height'].toString();
    currentContentState = widget.content;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(widget.content['type']),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('X:'),
            Expanded(
              child: TextField(
                controller: xPosController,
                onSubmitted: (val) {
                  update();
                },
              ),
            ),
            Text('Y:'),
            Expanded(
              child: TextField(
                controller: yPosController,
                onSubmitted: (val) {
                  update();
                },
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('W:'),
            Expanded(
              child: TextField(
                controller: widthController,
                onSubmitted: (val) {
                  update();
                },
              ),
            ),
            Text('H:'),
            Expanded(
              child: TextField(
                controller: heightController,
                onSubmitted: (val) {
                  update();
                },
              ),
            ),
          ],
        ),
        Padding(padding: EdgeInsets.only(top: 20.0)),
      ],
    );
  }

  void update() {
    widget.onUpdated(
      {
        "type": "rect",
        "x": num.tryParse(xPosController.value.text) ?? 0.0,
        "y": num.tryParse(yPosController.value.text) ?? 0.0,
        "width": num.tryParse(widthController.value.text) ?? 0.0,
        "height": num.tryParse(heightController.value.text) ?? 0.0,
        "fill": currentContentState['fill']
      },
    );
  }
}
