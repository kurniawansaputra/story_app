import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/components/avatar_name_widget.dart';
import '../../../core/routes/router.dart';
import '../../../data/models/responses/stories/list_story.dart';
import 'image_story_widget.dart';

class StoryCard extends StatelessWidget {
  final ListStory story;
  final void Function(String) onTap;

  const StoryCard({
    super.key,
    required this.story,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('${Routes.detailStory}/${story.id}');
      },
      child: Card.filled(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          children: [
            ImageStory(
              imageUrl: story.photoUrl ?? '',
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: AvatarName(
                name: story.name ?? '',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
