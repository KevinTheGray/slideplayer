import 'package:flutter/services.dart';

void updateNotes(String notes) async {
  await MethodChannel('FlutterSlides:NotesUpdater')
      .invokeMethod('update', notes);
}

void showNoteWindow() async {
  await MethodChannel('FlutterSlides:NotesUpdater').invokeMethod('show');
}
