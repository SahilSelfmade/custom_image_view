# Change Log for CustomImageView

## [Version 5.2.0] - 2026-05-08

### Added

- Added `bytes` for in-memory raster image rendering.
- Added `svgBytes` for in-memory SVG rendering.
- Added `progressIndicatorBuilder` for raster network download progress UI.
- Added accessibility support with `semanticsLabel` and `excludeFromSemantics`.
- Added a complete `example/` Flutter app for pub.dev package previews.
- Added pub.dev metadata for repository, issue tracker, documentation, and topics.

## [Version 5.1.0] - 2026-05-08

### Added

- Added network SVG support with the new `svgUrl` parameter.
- Added cache controls with `cacheManager`, `cacheKey`, `httpHeaders`, memory cache sizing, disk cache sizing, and `useOldImageOnUrlChange`.
- Added `CustomImageView.evictFromCache(...)` for network raster and SVG cache eviction.
- Added cache-backed network SVG loading through `flutter_cache_manager`.
- Added automatic `.svg` URL detection for the existing `url` parameter.
- Added automatic `.svg` asset detection for the existing `imagePath` parameter.
- Added SVG rendering support for local `File` and `XFile` paths ending in `.svg`.
- Added `svgErrorBuilder` for SVG-specific load failures.
- Added conditional local-file rendering so the public library can compile for Flutter web.
- Added widget tests for source routing, wrappers, placeholders, tap behavior, and error fallback.

### Changed

- Replaced `svg_flutter` with the maintained `flutter_svg` package.
- Updated `cached_network_image` to `^3.4.1`.
- Added direct `flutter_cache_manager` and `http` dependencies for explicit cache-backed SVG network loading.
- Updated `image_picker` to `^1.2.2`.
- Updated `flutter_lints` to `^6.0.0`.
- Updated the Flutter lower bound to `>=3.10.0` to match the Dart 3 package baseline.
- Improved network image sizing, fitting, alignment, and color filter consistency.
- Expanded README docs with source priority, platform notes, and examples.

## [Version 5.0.2] - 2024-01-10

### Fixed

- color related issue.

## [Version 5.0.1] - 2024-01-10

### Added

- Added `imageBuilder` parameter to `CustomImageView` widget that creates a widget when the image have some decorations.
- Added `colorFilter` parameter to `CustomImageView` widget that added colorfilter the [SVG_ASSETS].

### Fixed

- Addressed potential issues related to Alignment.

## [Version 5.0.0] - 2024-01-09

### Added

- Support for `XFile` type in the `CustomImageView` widget.
  - You can now directly use an `XFile` to display images from local files.
  - Example usage:

    ```dart
    CustomImageView(
      xfile: xfile,
      height: 100,
      width: 100,
      fit: BoxFit.cover,
      color: Colors.red,
    );
    ```

    This will display the image from the specified `XFile`.

### Changed

- Updated the widget to version 4.1.0.

### Fixed

- Addressed potential issues related to displaying images from `XFile` types.

## [Version 4.0.0] - 2024-01-08

### Added

- Custom error widget with `errorWidget` parameter.
- Error builder function with `errorBuilder` parameter.

### Changed

- Updated the widget to version 4.0.0.

### Fixed

- Fixed potential issues related to error handling.

## [Version 3.0.0] - 2024-01-08

### Added

- Downgraded dart version.

## [Version 2.0.0] - 2024-01-08

### Added

- Added license and some other fixes.

## [Version 1.0.0] - 2024-01-08

### Added

- Initial implementation of the `CustomImageView` widget.
- Supports displaying images from various sources, including network, local file, SVG, etc.
- Allows customization of image properties such as height, width, color, fit, etc.
- Supports onTap callback for interaction.
- Provides options for margin, border radius, and border styles.
- Offers blend mode for applying color filters to SVG images.
- Utilizes the `CachedNetworkImage` widget for efficient network image loading.
