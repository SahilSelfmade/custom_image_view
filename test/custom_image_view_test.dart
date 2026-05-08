import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_image_view/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders a cached network image for raster urls', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CustomImageView(
          url: 'https://example.com/image.png',
          height: 48,
          width: 48,
        ),
      ),
    );

    expect(find.byType(CachedNetworkImage), findsOneWidget);
    expect(find.byType(SvgPicture), findsNothing);
  });

  test('accepts an explicit SVG network url', () {
    const image = CustomImageView(
      svgUrl: 'https://example.com/icon.svg',
      height: 48,
      width: 48,
    );

    expect(image.svgUrl, 'https://example.com/icon.svg');
  });

  test('accepts an SVG network url through the existing url field', () {
    const image = CustomImageView(
      url: 'https://example.com/icon.svg?version=1',
      height: 48,
      width: 48,
    );

    expect(image.url, 'https://example.com/icon.svg?version=1');
  });

  testWidgets('renders an asset SVG from svgPath', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CustomImageView(
          svgPath: 'assets/icon.svg',
          height: 48,
          width: 48,
        ),
      ),
    );

    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets('auto-renders asset SVG from imagePath', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CustomImageView(
          imagePath: 'assets/icon.svg',
          height: 48,
          width: 48,
        ),
      ),
    );

    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets('renders an asset image from imagePath', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CustomImageView(
          imagePath: 'assets/photo.png',
          height: 48,
          width: 48,
          errorBuilder: _emptyImageErrorBuilder,
        ),
      ),
    );

    final image = tester.widget<Image>(find.byType(Image));
    expect(image.width, 48);
    expect(image.height, 48);
    expect(image.fit, BoxFit.cover);
  });

  testWidgets('prefers explicit svgPath over raster url', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CustomImageView(
          svgPath: 'assets/icon.svg',
          url: 'https://example.com/image.png',
        ),
      ),
    );

    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsNothing);
  });

  testWidgets('applies margin, radius, border, and tap callback',
      (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: CustomImageView(
          imagePath: 'assets/photo.png',
          margin: const EdgeInsets.all(12),
          radius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red),
          errorBuilder: _emptyImageErrorBuilder,
          onTap: () => tapped = true,
        ),
      ),
    );

    expect(find.byType(Padding), findsAtLeastNWidgets(1));
    expect(find.byType(GestureDetector), findsOneWidget);
    expect(find.byType(ClipRRect), findsOneWidget);
    expect(find.byType(Container), findsOneWidget);

    await tester.tap(find.byType(GestureDetector));

    expect(tapped, isTrue);
  });

  testWidgets('uses custom placeholder for raster network images',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CustomImageView(
          url: 'https://example.com/image.png',
          placeHolder: (context, url) => Text('loading $url'),
        ),
      ),
    );

    final cachedImage =
        tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
    final placeholder = cachedImage.placeholder;

    expect(placeholder, isNotNull);
    expect(
      placeholder!(tester.element(find.byType(CachedNetworkImage)),
          'https://example.com/image.png'),
      isA<Text>(),
    );
  });

  testWidgets('passes cache controls to raster network images', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CustomImageView(
          url: 'https://example.com/image.png',
          cacheKey: 'profile-photo',
          httpHeaders: {'Authorization': 'Bearer token'},
          memCacheWidth: 200,
          memCacheHeight: 100,
          maxWidthDiskCache: 400,
          maxHeightDiskCache: 300,
          useOldImageOnUrlChange: true,
        ),
      ),
    );

    final cachedImage =
        tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));

    expect(cachedImage.cacheKey, 'profile-photo');
    expect(cachedImage.httpHeaders, {'Authorization': 'Bearer token'});
    expect(cachedImage.memCacheWidth, 200);
    expect(cachedImage.memCacheHeight, 100);
    expect(cachedImage.maxWidthDiskCache, 400);
    expect(cachedImage.maxHeightDiskCache, 300);
    expect(cachedImage.useOldImageOnUrlChange, isTrue);
  });

  testWidgets('falls back to errorBuilder for SVG failures', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CustomImageView(
          svgPath: 'assets/icon.svg',
          errorBuilder: (context, error, stackTrace) {
            return const Text('svg error');
          },
        ),
      ),
    );

    final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));

    expect(svg.errorBuilder, isNotNull);
    expect(
      svg.errorBuilder!(
        tester.element(find.byType(SvgPicture)),
        StateError('bad svg'),
        StackTrace.empty,
      ),
      isA<Text>(),
    );
  });

  testWidgets('renders an empty box when no source is provided',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CustomImageView(),
      ),
    );

    expect(find.byType(SizedBox), findsOneWidget);
  });
}

Widget _emptyImageErrorBuilder(
  BuildContext context,
  Object error,
  StackTrace? stackTrace,
) {
  return const SizedBox.shrink();
}
