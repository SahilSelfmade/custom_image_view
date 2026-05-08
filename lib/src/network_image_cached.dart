import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

import 'cached_svg_http_client.dart';
import 'network_image_types.dart';

Widget buildNetworkRasterImage({
  required String url,
  required double? height,
  required double? width,
  required BoxFit? fit,
  required Object? cacheManager,
  required String? cacheKey,
  required Map<String, String>? httpHeaders,
  required int? memCacheWidth,
  required int? memCacheHeight,
  required int? maxWidthDiskCache,
  required int? maxHeightDiskCache,
  required bool useOldImageOnUrlChange,
  required CustomImageProgressBuilder? progressIndicatorBuilder,
  required Color? color,
  required BlendMode? colorBlendMode,
  required Widget Function(BuildContext, ImageProvider<Object>)? imageBuilder,
  required Widget Function(BuildContext, String)? placeholder,
  required Alignment alignment,
  required Widget Function(BuildContext, String, Object)? errorWidget,
}) {
  return CachedNetworkImage(
    height: height,
    width: width,
    fit: fit,
    imageUrl: url,
    cacheManager: cacheManager as BaseCacheManager?,
    cacheKey: cacheKey,
    httpHeaders: httpHeaders,
    memCacheWidth: memCacheWidth,
    memCacheHeight: memCacheHeight,
    maxWidthDiskCache: maxWidthDiskCache,
    maxHeightDiskCache: maxHeightDiskCache,
    useOldImageOnUrlChange: useOldImageOnUrlChange,
    progressIndicatorBuilder: progressIndicatorBuilder == null
        ? null
        : (context, imageUrl, progress) {
            return progressIndicatorBuilder(
              context,
              imageUrl,
              CustomImageDownloadProgress(
                url: imageUrl,
                downloaded: progress.downloaded,
                totalSize: progress.totalSize,
              ),
            );
          },
    color: color,
    colorBlendMode: colorBlendMode,
    imageBuilder: imageBuilder,
    placeholder: placeholder,
    alignment: alignment,
    errorWidget: errorWidget,
  );
}

Future<bool> evictNetworkImageFromCache(
  String url, {
  String? cacheKey,
  Object? cacheManager,
  double scale = 1,
}) async {
  final effectiveCacheManager =
      cacheManager as BaseCacheManager? ?? DefaultCacheManager();
  await effectiveCacheManager.removeFile(cacheKey ?? url);
  return CachedNetworkImage.evictFromCache(
    url,
    cacheKey: cacheKey,
    cacheManager: effectiveCacheManager,
    scale: scale,
  );
}

http.Client? buildCachedSvgHttpClient({
  required Object? cacheManager,
  required String? cacheKey,
}) {
  return CachedSvgHttpClient(
    cacheManager: cacheManager as BaseCacheManager? ?? DefaultCacheManager(),
    cacheKey: cacheKey,
  );
}
