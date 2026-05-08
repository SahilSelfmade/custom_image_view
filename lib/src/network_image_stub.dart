import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  if (imageBuilder != null) {
    return Builder(
      builder: (context) {
        return imageBuilder(
          context,
          NetworkImage(url, headers: httpHeaders),
        );
      },
    );
  }

  return Image.network(
    url,
    headers: httpHeaders,
    height: height,
    width: width,
    fit: fit,
    color: color,
    colorBlendMode: colorBlendMode,
    alignment: alignment,
    loadingBuilder: progressIndicatorBuilder == null && placeholder == null
        ? null
        : (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            if (progressIndicatorBuilder == null) {
              return placeholder!(context, url);
            }
            return progressIndicatorBuilder(
              context,
              url,
              CustomImageDownloadProgress(
                url: url,
                downloaded: loadingProgress.cumulativeBytesLoaded,
                totalSize: loadingProgress.expectedTotalBytes,
              ),
            );
          },
    errorBuilder: errorWidget == null
        ? null
        : (context, error, stackTrace) => errorWidget(context, url, error),
  );
}

Future<bool> evictNetworkImageFromCache(
  String url, {
  String? cacheKey,
  Object? cacheManager,
  double scale = 1,
}) {
  return NetworkImage(url, scale: scale).evict();
}

http.Client? buildCachedSvgHttpClient({
  required Object? cacheManager,
  required String? cacheKey,
}) {
  return null;
}
