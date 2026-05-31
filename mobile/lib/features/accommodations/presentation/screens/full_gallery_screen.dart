import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FullGalleryScreen extends StatelessWidget {
  final List<String> images;

  const FullGalleryScreen({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${images.length} Photos'),
      ),
      body: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return InteractiveViewer(
            panEnabled: true,
            minScale: 1,
            maxScale: 4,
            child: CachedNetworkImage(
              imageUrl: images[index],
              fit: BoxFit.contain,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.white)),
              errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
