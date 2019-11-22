import 'dart:io';

import 'package:flutter_slides/models/slides.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slides/utils/color_utils.dart';
import 'package:flutter_slides/utils/image_utils.dart' as ImageUtils;

class ImageContent extends StatelessWidget {
  final String assetPath;
  final String filePath;
  final BoxFit fit;
  final bool evict;
  final Color tint;

  ImageContent({Key key, Map contentMap})
      : this.assetPath = contentMap['asset'],
        this.filePath = contentMap['file'],
        this.fit = ImageUtils.boxFitFromString(contentMap['fit']),
        this.evict = contentMap['evict'] ?? false,
        this.tint = contentMap['tint']   != null
            ? colorFromString(contentMap['tint'], errorColor: null)
            : null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    print(tint);
    Image image;
    if (filePath != null) {
      final root = loadedSlides.presentationMetadata.externalFilesRoot;
      if (evict) {
        FileImage(File('$root/$filePath')).evict();
      }
      image = Image.file(
        File('$root/$filePath'),
        fit: fit,
        color: tint,
      );
    } else {
      if (evict) {
        Image.asset(assetPath).image.evict();
      }
      image = Image.asset(
        assetPath,
        fit: fit,
        color: tint,
      );
    }
    return image;
  }
}
