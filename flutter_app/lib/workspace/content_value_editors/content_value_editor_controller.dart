class ContentValueEditorController {
  ContentValueEditorControllerListener listener;

  Map getContentValues() {
    return listener?.getContentValues() ?? {};
  }
}

abstract class ContentValueEditorControllerListener {
  Map getContentValues();
}