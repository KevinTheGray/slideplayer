import 'package:flutter/material.dart';

final hotKeys = [
  'Space: Advance Slide',
  'Forward Arrow: Advance Slide',
  'Back Arrow: Previous Slide',
  '[: Hide/Reveal the Slide List',
  ']: Hide/Reveal the Slide Editor',
  'CMD + A: Add a new Slide',
  'CMD + D: Duplicate Current Slide',
  'CMD + Delete: Delete Current Slide',
  'CMD + Z: Undo',
  'CMD + Shift + Z: Redo',
  'CMD + S: Save',
  'CMD + Enter: New line (on applicable text fields)',
  'Tap + Hold + Drag on Slide: Reorder Slides(on slide list)'
];

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: List<Widget>.generate(
        hotKeys.length,
        (index) {
          final split = hotKeys[index].split(':');
          return Container(
              color: index.isEven ? Color(0xFFF2F2F2) : Color(0xFFFFFFFF),
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text(
                    split[0],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Text(
                    split[1],
//                    style: TextStyle(),
                  )
                ],
              ));
        },
      ),
    );
  }
}
