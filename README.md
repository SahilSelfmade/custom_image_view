# CustomImageView

CustomImageView is a Flutter package that provides a versatile widget for displaying various types of images, including network images, local files, SVGs, etc. It offers customization options for image properties and interaction, making it easy to integrate into your Flutter projects.

## Features

- Display images from different sources: network, local files, SVGs, etc.
- Customization options for image properties such as height, width, color, fit, etc.
- Placeholder image support for cases where the image is not available.
- Support for onTap callback for user interaction.
- Additional features like margin, border radius, and border styles.
- Blend mode for applying color filters to SVG images.
- Efficient network image loading using `CachedNetworkImage` widget.

## Getting Started

To use this package, add `custom_image_view` as a dependency in your `pubspec.yaml` file.


``` dart
class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: CustomImageView(
      url: 'Network url',
      file: File('File path'),
      imagePath: 'Image path',
      svgPath: 'Svg path',
      height: 100,
      width: 100,
      color: Colors.red,
      fit: BoxFit.contain,
      alignment: Alignment.center,
      onTap: () {},
      radius: BorderRadius.circular(10),
      margin: const EdgeInsets.all(1),
      placeHolder: 'Error asset image path',
    )));
  }
}
```

```yaml
dependencies:
  custom_image_view: ^1.0.0
