import 'package:flutter/widgets.dart';

typedef CustomImageProgressBuilder = Widget Function(
  BuildContext context,
  String url,
  CustomImageDownloadProgress progress,
);

class CustomImageDownloadProgress {
  const CustomImageDownloadProgress({
    required this.url,
    required this.downloaded,
    this.totalSize,
  });

  final String url;
  final int downloaded;
  final int? totalSize;

  double? get progress {
    final total = totalSize;
    if (total == null || total <= 0) {
      return null;
    }
    return downloaded / total;
  }
}
