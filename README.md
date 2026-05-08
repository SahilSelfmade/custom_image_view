# CustomImageView

`CustomImageView` is a single Flutter widget for the image sources most apps use every day: cached raster network images, network SVGs, asset images, asset SVGs, local files, and `XFile` values from `image_picker`.

## Features

- Cached raster network images through `CachedNetworkImage`.
- Configurable cache keys, cache managers, HTTP headers, memory resize cache, and disk resize cache for network images.
- Network SVGs through `svgUrl`.
- Network SVGs are fetched through `flutter_cache_manager` so repeated SVG loads reuse the cache.
- Automatic `.svg` URL detection when using the existing `url` parameter.
- Asset SVGs through `svgPath`.
- Automatic `.svg` asset detection when using `imagePath`.
- Local `File` and `XFile` rendering, including `.svg` local paths.
- Web-safe public library: local file rendering is behind conditional imports, so web builds can still use network, asset, SVG, and `XFile` path sources.
- Shared controls for size, fit, alignment, color, color filter, blend mode, margin, radius, border, tap handling, placeholders, and error builders.

## Installation

```yaml
dependencies:
  custom_image_view: ^5.1.0
```

Then import it:

```dart
import 'package:custom_image_view/custom_image_view.dart';
```

## Source Priority

If more than one source is provided, the widget uses the first available source in this order:

| Priority | Parameter | Supports |
| --- | --- | --- |
| 1 | `svgUrl` | Network SVG |
| 2 | `svgPath` | Asset SVG, network SVG URL |
| 3 | `file` | Local raster file, local SVG file |
| 4 | `xFile` | Picked raster file, picked SVG file |
| 5 | `url` | Cached raster network image, network SVG URL |
| 6 | `imagePath` | Asset raster image, asset SVG |

## Caching

Raster network images use `CachedNetworkImage`. Network SVGs use `flutter_cache_manager` through the same `cacheManager`, `cacheKey`, and `httpHeaders` parameters.

```dart
CustomImageView(
  url: 'https://example.com/profile.png',
  cacheKey: 'user-42-profile',
  httpHeaders: const {
    'Authorization': 'Bearer token',
  },
  memCacheWidth: 300,
  memCacheHeight: 300,
  maxWidthDiskCache: 600,
  maxHeightDiskCache: 600,
  useOldImageOnUrlChange: true,
)
```

Use a custom cache manager when you need a different stale period or cache size:

```dart
CustomImageView(
  url: 'https://example.com/photo.png',
  cacheManager: customCacheManager,
)
```

Evict a URL from cache when the remote image changes:

```dart
await CustomImageView.evictFromCache(
  'https://example.com/profile.png',
  cacheKey: 'user-42-profile',
);
```

## Examples

### Cached Network Image

```dart
CustomImageView(
  url: 'https://example.com/photo.png',
  height: 120,
  width: 120,
  fit: BoxFit.cover,
  radius: BorderRadius.circular(12),
)
```

### Network SVG

```dart
CustomImageView(
  svgUrl: 'https://example.com/icon.svg',
  cacheKey: 'brand-icon',
  height: 48,
  width: 48,
  color: Colors.blue,
)
```

You can also pass a `.svg` URL through `url`:

```dart
CustomImageView(
  url: 'https://example.com/icon.svg',
  height: 48,
  width: 48,
)
```

### Asset Image

```dart
CustomImageView(
  imagePath: 'assets/images/avatar.png',
  height: 64,
  width: 64,
  fit: BoxFit.cover,
)
```

### Asset SVG

```dart
CustomImageView(
  svgPath: 'assets/icons/logo.svg',
  height: 48,
  width: 48,
  colorFilter: const ColorFilter.mode(
    Colors.black,
    BlendMode.srcIn,
  ),
)
```

You can also pass a `.svg` asset through `imagePath`:

```dart
CustomImageView(
  imagePath: 'assets/icons/logo.svg',
  height: 48,
  width: 48,
)
```

### Local File

For mobile and desktop apps:

```dart
import 'dart:io';

CustomImageView(
  file: File('/path/to/image.png'),
  height: 100,
  width: 100,
)
```

### XFile From Image Picker

```dart
CustomImageView(
  xFile: pickedFile,
  height: 100,
  width: 100,
  fit: BoxFit.cover,
)
```

### Placeholder And Errors

```dart
CustomImageView(
  url: 'https://example.com/photo.png',
  placeHolder: (context, url) {
    return const Center(child: CircularProgressIndicator());
  },
  errorWidget: (context, url, error) {
    return const Icon(Icons.broken_image);
  },
)
```

SVG failures can use `svgErrorBuilder`. If it is not provided, `errorBuilder` is used as the SVG fallback.

```dart
CustomImageView(
  svgUrl: 'https://example.com/icon.svg',
  svgErrorBuilder: (context, error, stackTrace) {
    return const Icon(Icons.error_outline);
  },
)
```

### Styling And Interaction

```dart
CustomImageView(
  url: 'https://example.com/photo.png',
  height: 96,
  width: 96,
  fit: BoxFit.cover,
  alignment: Alignment.center,
  margin: const EdgeInsets.all(8),
  radius: BorderRadius.circular(16),
  border: Border.all(color: Colors.black12),
  onTap: () {
    // Open preview, profile, gallery, etc.
  },
)
```

## Notes

- Use `url` for raster network images.
- Use `svgUrl` for explicit network SVGs.
- `.svg` detection ignores query strings, so `https://example.com/icon.svg?v=1` is treated as an SVG.
- `file` is intended for mobile and desktop. For web image picking, prefer `xFile`.
