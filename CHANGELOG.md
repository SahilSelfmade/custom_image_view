# Change Log for CustomImageView

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
