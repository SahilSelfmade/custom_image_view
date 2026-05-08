import 'dart:convert';
import 'dart:typed_data';

import 'package:custom_image_view/custom_image_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CustomImageView Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  static const _networkImage =
      'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=900';
  static const _networkSvg =
      'https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/android.svg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomImageView'),
        actions: [
          IconButton(
            tooltip: 'Clear demo cache',
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              await CustomImageView.evictFromCache(
                _networkImage,
                cacheKey: 'example-landscape',
              );
              await CustomImageView.evictFromCache(
                _networkSvg,
                cacheKey: 'example-svg',
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache cleared')),
                );
              }
            },
          ),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: MediaQuery.sizeOf(context).width > 720 ? 3 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _ExampleTile(
            title: 'Cached Network',
            child: CustomImageView(
              url: _networkImage,
              cacheKey: 'example-landscape',
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              radius: BorderRadius.circular(12),
              semanticsLabel: 'Cached mountain landscape image',
              progressIndicatorBuilder: (context, url, progress) {
                return Center(
                  child: CircularProgressIndicator(
                    value: progress.progress,
                  ),
                );
              },
            ),
          ),
          _ExampleTile(
            title: 'Network SVG',
            child: CustomImageView(
              svgUrl: _networkSvg,
              cacheKey: 'example-svg',
              height: 140,
              width: double.infinity,
              fit: BoxFit.contain,
              semanticsLabel: 'Cached Android SVG logo',
            ),
          ),
          _ExampleTile(
            title: 'Asset SVG',
            child: CustomImageView(
              svgPath: 'assets/logo.svg',
              height: 140,
              width: double.infinity,
              fit: BoxFit.contain,
              semanticsLabel: 'Package example SVG logo',
            ),
          ),
          _ExampleTile(
            title: 'Memory Image',
            child: CustomImageView(
              bytes: _transparentPngBytes,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              color: Colors.indigo,
              blendMode: BlendMode.srcATop,
              semanticsLabel: 'In-memory raster image',
            ),
          ),
          _ExampleTile(
            title: 'Memory SVG',
            child: CustomImageView(
              svgBytes: Uint8List.fromList(utf8.encode(_inlineSvg)),
              height: 140,
              width: double.infinity,
              fit: BoxFit.contain,
              semanticsLabel: 'In-memory SVG badge',
            ),
          ),
          _ExampleTile(
            title: 'Error State',
            child: CustomImageView(
              url: 'https://example.invalid/missing.png',
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) {
                return const Center(
                  child: Icon(Icons.broken_image_outlined, size: 48),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleTile extends StatelessWidget {
  const _ExampleTile({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Expanded(child: Center(child: child)),
          ],
        ),
      ),
    );
  }
}

const _inlineSvg = '''
<svg width="160" height="120" viewBox="0 0 160 120" xmlns="http://www.w3.org/2000/svg">
  <rect width="160" height="120" rx="18" fill="#EEF2FF"/>
  <circle cx="58" cy="60" r="28" fill="#4F46E5"/>
  <path d="M84 42H120L102 78H66L84 42Z" fill="#22C55E"/>
</svg>
''';

final Uint8List _transparentPngBytes = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+/p9sAAAAASUVORK5CYII=',
);
