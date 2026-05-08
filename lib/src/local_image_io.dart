import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef LocalImageFile = io.File;

String localImagePath(LocalImageFile file) => file.path;

Widget buildLocalRasterImage({
  required LocalImageFile file,
  required double? height,
  required double? width,
  required BoxFit? fit,
  required Color? color,
  required BlendMode? blendMode,
  required Alignment alignment,
  required String? semanticLabel,
  required bool excludeFromSemantics,
  required ImageErrorWidgetBuilder? errorBuilder,
}) {
  return Image.file(
    file,
    height: height,
    width: width,
    fit: fit ?? BoxFit.cover,
    color: color,
    colorBlendMode: blendMode,
    alignment: alignment,
    semanticLabel: semanticLabel,
    excludeFromSemantics: excludeFromSemantics,
    errorBuilder: errorBuilder,
  );
}

Widget buildLocalRasterPathImage({
  required String path,
  required double? height,
  required double? width,
  required BoxFit? fit,
  required Color? color,
  required BlendMode? blendMode,
  required Alignment alignment,
  required String? semanticLabel,
  required bool excludeFromSemantics,
  required ImageErrorWidgetBuilder? errorBuilder,
}) {
  return buildLocalRasterImage(
    file: io.File(path),
    height: height,
    width: width,
    fit: fit,
    color: color,
    blendMode: blendMode,
    alignment: alignment,
    semanticLabel: semanticLabel,
    excludeFromSemantics: excludeFromSemantics,
    errorBuilder: errorBuilder,
  );
}

Widget buildLocalSvgImage({
  required LocalImageFile file,
  required double? height,
  required double? width,
  required BoxFit? fit,
  required Alignment alignment,
  required String? semanticsLabel,
  required bool excludeFromSemantics,
  required ColorFilter? colorFilter,
  required Widget Function(BuildContext, Object, StackTrace?)? errorBuilder,
}) {
  return SvgPicture.file(
    file,
    height: height,
    width: width,
    fit: fit ?? BoxFit.contain,
    alignment: alignment,
    semanticsLabel: semanticsLabel,
    excludeFromSemantics: excludeFromSemantics,
    colorFilter: colorFilter,
    errorBuilder: errorBuilder,
  );
}

Widget buildLocalSvgPathImage({
  required String path,
  required double? height,
  required double? width,
  required BoxFit? fit,
  required Alignment alignment,
  required String? semanticsLabel,
  required bool excludeFromSemantics,
  required ColorFilter? colorFilter,
  required Widget Function(BuildContext, Object, StackTrace?)? errorBuilder,
}) {
  return buildLocalSvgImage(
    file: io.File(path),
    height: height,
    width: width,
    fit: fit,
    alignment: alignment,
    semanticsLabel: semanticsLabel,
    excludeFromSemantics: excludeFromSemantics,
    colorFilter: colorFilter,
    errorBuilder: errorBuilder,
  );
}
