import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter_slides/models/slides.dart';
import 'package:flutter_slides/slides/slide_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slides/workspace/load_presentation_screen.dart';
import 'package:menubar/menubar.dart';
import 'package:scoped_model/scoped_model.dart';

class SlidePresentation extends StatefulWidget {
  @override
  _SlidePresentationState createState() => _SlidePresentationState();
}

class _SlidePresentationState extends State<SlidePresentation>
    with TickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  int _currentSlideIndex = 0;
  int _transitionStartIndex = 0;
  int _transitionEndIndex = 0;
  AnimationController _transitionController;
  AnimationController _slideListController;
  AnimationController _editorController;
  double _lastSlideListScrollOffset = 0.0;
  SlidePageController _slidePageController = SlidePageController();
  Timer _autoAdvanceTimer;

  @override
  void initState() {
    super.initState();

    _transitionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _slideListController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );

    _editorController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );

    loadRecentlyOpenedSlideData();

    // todo (kg) - Clean this up, there's a better way to launch this...
    // this was just quick and dirty way to get this screen presenting
    setApplicationMenu([
      Submenu(label: 'File', children: [
        MenuItem(
          label: 'Open',
          onClicked: () {
            Navigator.pushNamed(context, '/load_new_presentation');
          },
        ),
        MenuItem(
          label: 'Save',
          onClicked: () {
            saveCurrent();
          },
        ),
      ]),
    ]);
  }

  @override
  void dispose() {
    _slideListController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FocusScope.of(context).requestFocus(_focusNode);
  }

  @override
  Widget build(BuildContext context) {
    FlutterSlidesModel model =
        ScopedModel.of<FlutterSlidesModel>(context, rebuildOnChange: true);

    _autoAdvanceTimer?.cancel();
    if (model.debugOptions.autoAdvance) {
      _autoAdvanceTimer = Timer.periodic(
          Duration(milliseconds: model.debugOptions.autoAdvanceDurationMillis),
          (_) {
        _advancePresentation(model);
      });
    }

    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: (event) {
        if (_focusNode == FocusScope.of(context).focusedChild) {
          onKeyEvent(event, model);
        }
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _editorController,
          _slideListController,
        ]),
        builder: (context, child) {
          if (model.slides == null) {
            return LoadPresentationScreen();
          }
          if (_currentSlideIndex >= model.slides.length ||
              _currentSlideIndex < 0) {
            _currentSlideIndex = 0;
          }
          bool animatedTransition = false;
          if ((model.slides?.length ?? 0) != 0) {
            animatedTransition =
                model.slides[_currentSlideIndex].animatedTransition ||
                    model.presentationMetadata.animateSlideTransitions;
          }
          return Container(
            color: model.presentationMetadata.projectBGColor,
            constraints: BoxConstraints.expand(),
            child: Stack(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(width: _slideListController.value * 200.0),
                    Container(
                        width: max(_slideListController.value,
                                _editorController.value) *
                            15.0),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: animatedTransition
                            ? _animatedSlideTransition(model)
                            : _currentSlide(model),
                      ),
                    ),
                    Container(
                        width: max(_slideListController.value,
                                _editorController.value) *
                            15.0),
                    Container(width: _editorController.value * 300.0),
                  ],
                ),
                _slideListController.value <= 0.01
                    ? Container()
                    : _slideList(model),
                Align(
                  alignment: Alignment.topRight,
                  child: _editorController.value <= 0.01
                      ? Container()
                      : _editorWidget(model),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _animatedSlideTransition(FlutterSlidesModel model) {
    final startingSlide = SlidePage(
      slide: model.slides[_transitionStartIndex],
    );
    final endingSlide = SlidePage(
      key: GlobalObjectKey(model.slides[_transitionEndIndex]),
      slide: model.slides[_transitionEndIndex],
      controller: _slidePageController,
    );
    return FlutterSlidesTransition(
      animation: _transitionController,
      startingSlide: startingSlide,
      endingSlide: endingSlide,
      transitionBuilder: (context, start, end) {
        final firstScreen = Opacity(
          opacity: 1.0 - _transitionController.value,
          child: start,
        );
        final secondScreen = Opacity(
          opacity: _transitionController.value,
          child: end,
        );
        final stackLayout = Stack(
          children: <Widget>[
            firstScreen,
            secondScreen,
          ],
        );
        return stackLayout;
      },
    );
  }

  Widget _currentSlide(FlutterSlidesModel model) {
    if (model.slides.length == 0) {
      return Material(
        type: MaterialType.transparency,
        child: Text('Add a Slide'),
      );
    }
    return SlidePage(
      slide: model.slides[_currentSlideIndex],
      controller: _slidePageController,
      index: _currentSlideIndex,
    );
  }

  Widget _editorWidget(FlutterSlidesModel model) {
    return Transform.translate(
      offset: Offset(300.0 + _editorController.value * -300.0, 0.0),
      child: Container(
        width: 300.0,
        color: model.presentationMetadata.slidesListBGColor,
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: model.presentationMetadata.slidesListBGColor,
            appBar: AppBar(
              backgroundColor:
                  model.presentationMetadata.slidesListHighlightColor,
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.settings)),
                  Tab(icon: Icon(Icons.slideshow)),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                ListView(
                  children: <Widget>[
                    Text('Debug:'),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: model.debugOptions.showDebugContainers,
                          onChanged: (value) {
                            model.debugOptions = model.debugOptions.copyWith(
                              showDebugContainers: value,
                            );
                          },
                        ),
                        Text('Show Content Borders'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: model.debugOptions.autoAdvance,
                          onChanged: (value) {
                            model.debugOptions = model.debugOptions.copyWith(
                              autoAdvance: value,
                            );
                          },
                        ),
                        Text('Auto-Advance'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('A-A Duration'),
                        Expanded(
                          child: TextField(
                            onSubmitted: (value) {
                              model.debugOptions = model.debugOptions.copyWith(
                                autoAdvanceDurationMillis: int.tryParse(
                                      value,
                                    ) ??
                                    30000,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(height: 10.0),
                    Row(
                      children: <Widget>[
                        MaterialButton(
                          height: 60.0,
                          color: model
                              .presentationMetadata.slidesListHighlightColor,
                          onPressed: () {
                            model.undo();
                          },
                          child: Text(
                            'Undo',
                            style:
                                TextStyle(color: Colors.white, fontSize: 24.0),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        MaterialButton(
                          height: 60.0,
                          color: model
                              .presentationMetadata.slidesListHighlightColor,
                          onPressed: () {
                            model.redo();
                          },
                          child: Text(
                            'Redo',
                            style:
                                TextStyle(color: Colors.white, fontSize: 24.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Icon(Icons.slideshow),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _slideList(FlutterSlidesModel model) {
    return Transform.translate(
      offset: Offset(-200.0 + _slideListController.value * 200.0, 0.0),
      child: Container(
        width: 200.0,
        color: model.presentationMetadata.slidesListBGColor,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            _lastSlideListScrollOffset = notification.metrics.pixels;
            return true;
          },
          child: ReorderableListView(
//            controller: ScrollController(
//              initialScrollOffset: _lastSlideListScrollOffset,
//            ),
            onReorder: (indexA, indexB) {
              final indexBSafe = min(indexB, model.slides.length - 1);
              model.reorderSlides(indexA, indexBSafe);
              _currentSlideIndex = indexBSafe;
            },
            children: List<Widget>.generate(model.slides.length, (index) {
              return GestureDetector(
                key: Key('$index'),
                onTapDown: (details) {
                  setState(() {
                    _moveToSlideAtIndex(model, index);
                  });
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _currentSlideIndex != index
                              ? Colors.transparent
                              : model.presentationMetadata
                                  .slidesListHighlightColor,
                          width: 4.0,
                        ),
                      ),
                      child: SlidePage(
                        isPreview: true,
                        slide: model.slides[index],
                      ),
                    ),
                    Positioned(
                      bottom: 6.0,
                      left: 6.0,
                      child: Container(
                        height: 20.0,
                        child: Material(
                          color: model
                              .presentationMetadata.slidesListHighlightColor
                              .withOpacity(0.75),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                '$index',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.white,
                                    fontFamily: "RobotoMono"),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  onKeyEvent(RawKeyEvent event, FlutterSlidesModel model) {
    switch (event.runtimeType) {
      case RawKeyDownEvent:
        break;
      case RawKeyUpEvent:
        switch (event.data.runtimeType) {
          case RawKeyEventDataMacOs:
            break;
          default:
            throw new Exception('Unsupported platform');
        }
        return;
      default:
        throw new Exception('Unexpected runtimeType of RawKeyEvent');
    }

    int keyCode;
    switch (event.data.runtimeType) {
      case RawKeyEventDataMacOs:
        final RawKeyEventDataMacOs data = event.data;
        keyCode = data.keyCode;
        print(keyCode);
        if (keyCode == 33) {
          if (_slideListController?.status == AnimationStatus.forward ||
              _slideListController?.status == AnimationStatus.completed) {
            _slideListController?.reverse();
          } else {
            _slideListController?.forward();
          }
        } else if (keyCode == 49) {
          _advancePresentation(model);
        } else if (keyCode == 30) {
          if (_editorController?.status == AnimationStatus.forward ||
              _editorController?.status == AnimationStatus.completed) {
            _editorController?.reverse();
          } else {
            _editorController?.forward();
          }
        } else if (keyCode == 123) {
          // tapped left
          _reversePresentation(model);
        } else if (keyCode == 124) {
          _advancePresentation(model);
        } else if (keyCode == 51) {
          model.removeSlide(_currentSlideIndex);
          _currentSlideIndex = _currentSlideIndex - 1;
        } else if (keyCode == 0) {
          if (model.slides.length == 0) {
            _currentSlideIndex = 0;
          } else {
            _currentSlideIndex = _currentSlideIndex + 1;
          }
          model.addSlide(
            {"bg_color": "#FFFFFFFF", "content": []},
            index: _currentSlideIndex,
          );
        }
        break;
      default:
        throw new Exception('Unsupported platform');
    }
  }

  void _advancePresentation(FlutterSlidesModel model) {
    bool didAdvanceSlideContent = _slidePageController.advanceSlideContent();
    if (!didAdvanceSlideContent) {
      if (model.debugOptions.autoAdvance &&
          _currentSlideIndex == model.slides.length - 1) {
        _moveToSlideAtIndex(model, 0);
      } else {
        _moveToSlideAtIndex(model, _currentSlideIndex + 1);
      }
    }
  }

  void _reversePresentation(FlutterSlidesModel model) {
    bool didReverseSlideContent = _slidePageController.reverseSlideContent();
    if (!didReverseSlideContent) {
      _moveToSlideAtIndex(model, _currentSlideIndex - 1);
    }
  }

  void _moveToSlideAtIndex(FlutterSlidesModel model, int index) {
    int nextIndex = index.clamp(0, model.slides.length - 1);
    int prepIndex = (index + 1).clamp(0, model.slides.length - 1);
    if (_currentSlideIndex == nextIndex) {
      return;
    }

    // precaching next slide images.
    if (prepIndex != nextIndex) {
      for (Map content in model.slides[prepIndex].content) {
        if (content['type'] == 'image') {
          if (content['evict'] ?? false) continue;
          ImageProvider provider;
          if (content.containsKey('asset')) {
            provider = Image.asset(content['asset']).image;
          }
          if (content.containsKey('file')) {
            final root = model.presentationMetadata.externalFilesRoot;
            provider = FileImage(File('$root/${content['file']}'));
          }
          final config = createLocalImageConfiguration(context);
          provider?.resolve(config);
        }
      }
    }
    setState(() {
      _transitionController.forward(from: 0.0);
      _transitionStartIndex = _currentSlideIndex;
      _transitionEndIndex = nextIndex;
      _currentSlideIndex = nextIndex;
    });
  }
}

typedef FlutterSlidesTransitionBuilder = Widget Function(
    BuildContext context, SlidePage startingSlide, SlidePage endingSlide);

class FlutterSlidesTransition extends AnimatedWidget {
  final SlidePage startingSlide;
  final SlidePage endingSlide;
  final FlutterSlidesTransitionBuilder transitionBuilder;

  FlutterSlidesTransition({
    this.startingSlide,
    this.endingSlide,
    this.transitionBuilder,
    Listenable animation,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return transitionBuilder(context, startingSlide, endingSlide);
  }
}
