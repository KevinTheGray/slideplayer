import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slides/models/presentation_loaders/file_system_presentation_loader.dart';
import 'package:flutter_slides/models/presentation_loaders/firebase_database_presentation_loader.dart';
import 'package:flutter_slides/models/slides.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:file_chooser/file_chooser.dart' as file_chooser;

class LoadPresentationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterSlidesModel model =
        ScopedModel.of<FlutterSlidesModel>(context, rebuildOnChange: true);
    return Material(
      color: model.presentationMetadata.projectBGColor,
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                "Flutter Slides",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32.0),
              ),
              Divider(
                height: 34.0,
                thickness: 4.0,
                color: Color(0xFFAAAAAA),
              ),
              MaterialButton(
                minWidth: 200.0,
                height: 60.0,
                color: model.presentationMetadata.slidesListHighlightColor,
                onPressed: () {
                  file_chooser.showOpenPanel((result, paths) {
                    if (paths != null) {
                      loadPresentation(
                          FileSystemPresentationLoader(paths.first));
                      Navigator.of(context).popUntil(ModalRoute.withName('/'));
                    }
                  }, allowsMultipleSelection: false);
                },
                child: Text(
                  'Load Presentation from Disk',
                  style: TextStyle(color: Colors.white, fontSize: 24.0),
                ),
              ),
              Divider(
                height: 34.0,
                thickness: 4.0,
                color: Color(0xFFAAAAAA),
              ),
              Text(
                "Firebase Projects",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0),
              ),
              StreamBuilder<Event>(
                stream: FirebaseDatabase.instance
                    .reference()
                    .child('presentations')
                    .onValue,
                builder: (_, snapshot) {
                  if (snapshot.data == null) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(model
                            .presentationMetadata.slidesListHighlightColor),
                      ),
                    );
                  }
                  Map data = snapshot.data.snapshot.value;
                  List<Map> cells = data.entries.map((e) {
                    Map presData = e.value['presentation_metadata'];
                    return {
                      'title': presData['title'],
                      'description': presData['description'],
                      'id': e.key,
                    };
                  }).toList();
                  return Expanded(
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 800.0),
                      child: ListView.separated(
                        itemCount: cells.length,
                        separatorBuilder: (_, __) {
                          return Padding(padding: EdgeInsets.only(top: 8.0));
                        },
                        itemBuilder: (_, index) {
                          return Container(
                            padding: EdgeInsets.all(15.0),
                            constraints: BoxConstraints(minHeight: 60.0),
                            color: Colors.white,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cells[index]['title'] ?? 'No Title',
                                        style: TextStyle(fontSize: 32.0),
                                      ),
                                      Text(
                                        cells[index]['description'] ??
                                            'No Description',
                                        style: TextStyle(fontSize: 24.0),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(left: 15.0)),
                                MaterialButton(
                                  height: 40.0,
                                  color: model.presentationMetadata
                                      .slidesListHighlightColor,
                                  onPressed: () {
                                    loadPresentation(
                                        FirebaseDatabasePresentationLoader(
                                            cells[index]['id']));
                                    Navigator.of(context)
                                        .popUntil(ModalRoute.withName('/'));
                                  },
                                  child: Text(
                                    'Load ',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 24.0),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
