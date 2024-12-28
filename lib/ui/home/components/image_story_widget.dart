import 'package:flutter/material.dart';

class ImageStory extends StatelessWidget {
  final String imageUrl;

  const ImageStory({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(16.0),
      ),
      child: Image.network(
        imageUrl,
        width: double.infinity,
        height: 160.0,
        fit: BoxFit.cover,
      ),
    );
  }
}
