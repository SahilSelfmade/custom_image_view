// ignore_for_file: public_member_api_docs, sort_constructors_first
library custom_image_view;

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:svg_flutter/svg_flutter.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}

class CustomImageView extends StatelessWidget {
  ///[url] is required parameter for fetching network image
  final String? url;

  ///[imagePath] is required parameter for showing png,jpg,etc image
  final String? imagePath;

  ///[svgPath] is required parameter for showing svg image
  final String? svgPath;

  ///[file] is required parameter for fetching image file
  final File? file;

  final double? height;
  final double? width;
  final Color? color;

  final Widget Function(BuildContext, String, Object)? errorWidget;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  final BoxFit? fit;
  final Widget Function(BuildContext, String)? placeholder;
  final Alignment? alignment;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? radius;
  final BoxBorder? border;
  final BlendMode? blendMode;

  ///a [CustomImageView] it can be used for showing any type of images
  /// it will shows the placeholder image if image is not found on network image
  const CustomImageView({
    Key? key,
    this.url,
    this.imagePath,
    this.svgPath,
    this.file,
    this.height,
    this.width,
    this.color,
    this.errorWidget,
    this.errorBuilder,
    this.fit,
    this.placeholder,
    this.alignment,
    this.onTap,
    this.margin,
    this.radius,
    this.border,
    this.blendMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment!,
            child: _buildWidget(),
          )
        : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: _buildCircleImage(),
      ),
    );
  }

  ///build the image with border radius
  _buildCircleImage() {
    if (radius != null) {
      return ClipRRect(
        borderRadius: radius!,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

  ///build the image with border and border radius style
  _buildImageWithBorder() {
    if (border != null) {
      return Container(
        decoration: BoxDecoration(
          border: border,
          borderRadius: radius,
        ),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
    if (svgPath != null && svgPath!.isNotEmpty) {
      return SizedBox(
        height: height,
        width: width,
        child: SvgPicture.asset(
          svgPath!,
          height: height,
          width: width,
          fit: fit ?? BoxFit.contain,
          colorFilter: color != null
              ? ColorFilter.mode(color!, blendMode ?? BlendMode.srcIn)
              : null,
        ),
      );
    } else if (file != null && file!.path.isNotEmpty) {
      return Image.file(
        file!,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        color: color,
      );
    } else if (url != null && url!.isNotEmpty) {
      return CachedNetworkImage(
        height: height,
        width: width,
        fit: fit,
        imageUrl: url!,
        color: color,
        placeholder: placeholder ??
            (context, url) => SizedBox(
                  height: 30,
                  width: 30,
                  child: LinearProgressIndicator(
                    color: Colors.grey.shade200,
                    backgroundColor: Colors.grey.shade100,
                  ),
                ),
        errorWidget: errorWidget,
      );
    } else if (imagePath != null && imagePath!.isNotEmpty) {
      return Image.asset(imagePath!,
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          color: color,
          errorBuilder: errorBuilder);
    }
    return const SizedBox();
  }
}
