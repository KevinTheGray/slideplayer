import 'package:flutter/material.dart';
import 'package:flutter_slides/workspace/slide_editor.dart';

class SelectColorScreen extends StatelessWidget {
  final List<Color> presentationMainColors = [
    Color(0xFF041e3c),
    Color(0xFF241e30),
    Color(0xFFa7ffeb),
    Color(0xFFf8bbd0),
  ];

  final List<Color> presentationSecondaryColors = [
    Color(0xFF13b9fd),
    Color(0xFFff8383),
    Color(0xFF1cdec9),
    Color(0xFF6200ee),
    Color(0xFF451b6f),
  ];

  final List<Color> hotColors = [
    Color(0xFFFFFFFF),
    Color(0xFF000000),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      children: [
        Container(
          height: 12.0,
        ),
        Wrap(
          spacing: 12.0,
          children:
              List<Widget>.generate(presentationMainColors.length, (index) {
            final color = presentationMainColors[index];
            return Column(
              children: <Widget>[
                Container(
                  height: 120.0,
                  width: 120.0,
                  child: Material(
                    elevation: 4.0,
                    type: MaterialType.circle,
                    color: color,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop(color.toHexString());
                      },
                    ),
                  ),
                ),
                Text(color.toHexString()),
              ],
            );
          }),
        ),
        Container(
          height: 12.0,
        ),
        Wrap(
          spacing: 12.0,
          children: List<Widget>.generate(presentationSecondaryColors.length,
              (index) {
            final color = presentationSecondaryColors[index];
            return Column(
              children: <Widget>[
                Container(
                  height: 120.0,
                  width: 120.0,
                  child: Material(
                    type: MaterialType.circle,
                    elevation: 4.0,
                    color: color,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop(color.toHexString());
                      },
                    ),
                  ),
                ),
                Text(color.toPrettyHexString()),
              ],
            );
          }),
        ),
        Container(
          height: 48.0,
        ),
        Wrap(
          spacing: 12.0,
          children: List<Widget>.generate(hotColors.length,
                  (index) {
                final color = hotColors[index];
                return Column(
                  children: <Widget>[
                    Container(
                      height: 120.0,
                      width: 120.0,
                      child: Material(
                        type: MaterialType.circle,
                        elevation: 4.0,
                        color: color,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop(color.toHexString());
                          },
                        ),
                      ),
                    ),
                    Text(color.toPrettyHexString()),
                  ],
                );
              }),
        )
      ],
    );
  }
}
