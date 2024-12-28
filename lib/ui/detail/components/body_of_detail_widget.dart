import 'package:flutter/material.dart';

import '../../../core/components/avatar_name_widget.dart';
import '../../../data/models/responses/story_detail_response_model.dart';
import '../../home/components/image_story_widget.dart';

class BodyOfDetail extends StatelessWidget {
  final Story data;

  const BodyOfDetail({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(
          16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageStory(
              imageUrl: data.photoUrl ?? '',
            ),
            const SizedBox(
              height: 16.0,
            ),
            AvatarName(
              name: data.name ?? '',
            ),
            const SizedBox(
              height: 16.0,
            ),
            Text(
              data.description ?? '',
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
