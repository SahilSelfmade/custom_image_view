// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'src/cached_svg_http_client.dart';
import 'src/local_image_stub.dart'
    if (dart.library.io) 'src/local_image_io.dart';

class CustomImageView extends StatelessWidget {
  /// Network image URL.
  ///
  /// Raster URLs are rendered with [CachedNetworkImage]. URLs ending in `.svg`
  /// are rendered with [SvgPicture.network].
  final String? url;

  /// Asset image path.
  ///
  /// Raster assets are rendered with [Image.asset]. Asset paths ending in
  /// `.svg` are rendered with [SvgPicture.asset].
  final String? imagePath;

  /// SVG asset path, or an SVG network URL.
  final String? svgPath;

  /// SVG network URL.
  final String? svgUrl;

  /// Local image file for mobile and desktop apps.
  final LocalImageFile? file;

  /// The [XFile] which contains the image to be displayed.
  final XFile? xFile;

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// The color to filter the image with.
  final Color? color;

  /// The color filter applied to SVGs and decorated network images.
  final ColorFilter? colorFilter;

  /// Cache manager used for raster network images and network SVGs.
  final BaseCacheManager? cacheManager;

  /// Cache key used for raster network images and network SVGs.
  final String? cacheKey;

  /// HTTP headers used for raster network images and network SVGs.
  final Map<String, String>? httpHeaders;

  /// In-memory cache width for raster network images.
  final int? memCacheWidth;

  /// In-memory cache height for raster network images.
  final int? memCacheHeight;

  /// Disk cache resize width for raster network images.
  final int? maxWidthDiskCache;

  /// Disk cache resize height for raster network images.
  final int? maxHeightDiskCache;

  /// Keeps the old raster network image visible while [url] changes.
  final bool useOldImageOnUrlChange;

  /// A widget to display when the image fails to load.
  final Widget Function(BuildContext, String, Object)? errorWidget;

  /// A builder function that creates a widget when the image fails to load.
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  /// A builder function that creates a widget when SVG fails to load.
  final Widget Function(BuildContext, Object, StackTrace?)? svgErrorBuilder;

  /// Builds decorated network images from their resolved [ImageProvider].
  final Widget Function(BuildContext, ImageProvider<Object>)? imageBuilder;

  /// How the image should be inscribed into the space allocated during layout.
  final BoxFit? fit;

  /// A placeholder widget to display while the image is being loaded.
  final Widget Function(BuildContext, String)? placeHolder;

  /// The alignment of the image within its frame.
  final Alignment? alignment;

  /// The callback that is called when the image is tapped.
  final VoidCallback? onTap;

  /// The margin around the image.
  final EdgeInsetsGeometry? margin;

  /// The border radius of the image.
  final BorderRadiusGeometry? radius;

  /// The border of the image.
  final BoxBorder? border;

  /// The blend mode applied to the image.
  final BlendMode? blendMode;

  /// Creates a widget that displays one image source with shared styling.
  const CustomImageView({
    super.key,
    this.url,
    this.imagePath,
    this.svgPath,
    this.svgUrl,
    this.file,
    this.xFile,
    this.height,
    this.width,
    this.color,
    this.colorFilter,
    this.cacheManager,
    this.cacheKey,
    this.httpHeaders,
    this.memCacheWidth,
    this.memCacheHeight,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
    this.useOldImageOnUrlChange = false,
    this.errorWidget,
    this.errorBuilder,
    this.svgErrorBuilder,
    this.imageBuilder,
    this.fit,
    this.placeHolder,
    this.alignment,
    this.onTap,
    this.margin,
    this.radius,
    this.border,
    this.blendMode,
  });

  /// Removes a network image or SVG from disk cache and Flutter image cache.
  static Future<bool> evictFromCache(
    String url, {
    String? cacheKey,
    BaseCacheManager? cacheManager,
    double scale = 1,
  }) async {
    final effectiveCacheManager = cacheManager ?? DefaultCacheManager();
    await effectiveCacheManager.removeFile(cacheKey ?? url);
    return CachedNetworkImage.evictFromCache(
      url,
      cacheKey: cacheKey,
      cacheManager: effectiveCacheManager,
      scale: scale,
    );
  }

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
      child: GestureDetector(
        onTap: onTap,
        child: _buildCircleImage(),
      ),
    );
  }

  ///build the image with border radius
  Widget _buildCircleImage() {
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
  Widget _buildImageWithBorder() {
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
    if (_hasValue(svgUrl)) {
      return _buildNetworkSvg(svgUrl!);
    } else if (_hasValue(svgPath)) {
      return _isNetworkSvg(svgPath!)
          ? _buildNetworkSvg(svgPath!)
          : _buildAssetSvg(svgPath!);
    } else if (file != null && _hasValue(localImagePath(file!))) {
      final path = localImagePath(file!);
      return _isSvg(path) ? _buildFileSvg(file!) : _buildFileImage(file!);
    } else if (xFile != null && xFile!.path.isNotEmpty) {
      return _isSvg(xFile!.path)
          ? _buildXFileSvg(xFile!)
          : _buildXFileImage(xFile!);
    } else if (_hasValue(url)) {
      return _isNetworkSvg(url!)
          ? _buildNetworkSvg(url!)
          : _buildNetworkImage();
    } else if (_hasValue(imagePath)) {
      return _isSvg(imagePath!)
          ? _buildAssetSvg(imagePath!)
          : _buildAssetImage(imagePath!);
    }
    return const SizedBox();
  }

  Widget _buildAssetSvg(String assetName) {
    return SvgPicture.asset(
      assetName,
      alignment: alignment ?? Alignment.center,
      height: height,
      width: width,
      fit: fit ?? BoxFit.contain,
      colorFilter: _resolvedColorFilter,
      errorBuilder: _resolvedSvgErrorBuilder,
    );
  }

  Widget _buildNetworkSvg(String imageUrl) {
    return SvgPicture.network(
      imageUrl,
      alignment: alignment ?? Alignment.center,
      height: height,
      width: width,
      fit: fit ?? BoxFit.contain,
      colorFilter: _resolvedColorFilter,
      placeholderBuilder: placeHolder == null
          ? null
          : (context) => placeHolder!(context, imageUrl),
      errorBuilder: _resolvedSvgErrorBuilder,
      headers: httpHeaders,
      httpClient: CachedSvgHttpClient(
        cacheManager: cacheManager ?? DefaultCacheManager(),
        cacheKey: cacheKey,
      ),
    );
  }

  Widget _buildFileSvg(LocalImageFile imageFile) {
    return buildLocalSvgImage(
      file: imageFile,
      alignment: alignment ?? Alignment.center,
      height: height,
      width: width,
      fit: fit ?? BoxFit.contain,
      colorFilter: _resolvedColorFilter,
      errorBuilder: _resolvedSvgErrorBuilder,
    );
  }

  Widget _buildFileImage(LocalImageFile imageFile) {
    return buildLocalRasterImage(
      file: imageFile,
      height: height,
      width: width,
      fit: fit ?? BoxFit.cover,
      color: color,
      blendMode: blendMode,
      errorBuilder: errorBuilder,
      alignment: alignment ?? Alignment.center,
    );
  }

  Widget _buildXFileSvg(XFile imageFile) {
    return buildLocalSvgPathImage(
      path: imageFile.path,
      alignment: alignment ?? Alignment.center,
      height: height,
      width: width,
      fit: fit ?? BoxFit.contain,
      colorFilter: _resolvedColorFilter,
      errorBuilder: _resolvedSvgErrorBuilder,
    );
  }

  Widget _buildXFileImage(XFile imageFile) {
    return buildLocalRasterPathImage(
      path: imageFile.path,
      height: height,
      width: width,
      fit: fit ?? BoxFit.cover,
      color: color,
      blendMode: blendMode,
      errorBuilder: errorBuilder,
      alignment: alignment ?? Alignment.center,
    );
  }

  Widget _buildAssetImage(String assetName) {
    return Image.asset(
      assetName,
      height: height,
      width: width,
      fit: fit ?? BoxFit.cover,
      color: color,
      colorBlendMode: blendMode,
      errorBuilder: errorBuilder,
      alignment: alignment ?? Alignment.center,
    );
  }

  Widget _buildNetworkImage() {
    return CachedNetworkImage(
      height: height,
      width: width,
      fit: fit,
      imageUrl: url!,
      cacheManager: cacheManager,
      cacheKey: cacheKey,
      httpHeaders: httpHeaders,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      maxWidthDiskCache: maxWidthDiskCache,
      maxHeightDiskCache: maxHeightDiskCache,
      useOldImageOnUrlChange: useOldImageOnUrlChange,
      imageBuilder: imageBuilder ??
          (context, imageProvider) => Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: fit ?? BoxFit.cover,
                    colorFilter: _resolvedColorFilter,
                    alignment: alignment ?? Alignment.center,
                  ),
                ),
              ),
      placeholder: placeHolder ??
          (context, url) => SizedBox(
                height: height ?? 30,
                width: width ?? 30,
                child: LinearProgressIndicator(
                  color: Colors.grey.shade200,
                  backgroundColor: Colors.grey.shade100,
                ),
              ),
      alignment: alignment ?? Alignment.center,
      errorWidget: errorWidget,
    );
  }

  ColorFilter? get _resolvedColorFilter {
    return color != null
        ? ColorFilter.mode(color!, blendMode ?? BlendMode.srcIn)
        : colorFilter;
  }

  Widget Function(BuildContext, Object, StackTrace?)?
      get _resolvedSvgErrorBuilder {
    if (svgErrorBuilder != null) {
      return svgErrorBuilder;
    }
    if (errorBuilder != null) {
      return (context, error, stackTrace) {
        return errorBuilder!(context, error, stackTrace);
      };
    }
    return null;
  }

  bool _hasValue(String? value) => value != null && value.trim().isNotEmpty;

  bool _isNetworkSvg(String value) {
    final uri = Uri.tryParse(value);
    return _isSvg(value) && (uri?.scheme == 'http' || uri?.scheme == 'https');
  }

  bool _isSvg(String value) {
    final uri = Uri.tryParse(value);
    final path = uri?.path.isNotEmpty == true ? uri!.path : value;
    return path.toLowerCase().endsWith('.svg');
  }
}
