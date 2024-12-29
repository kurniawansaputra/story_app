import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/components/message_widget.dart';
import '../../../core/static/story_detail.dart';
import '../../../providers/storyDetail/story_detail_provider.dart';
import '../components/body_of_detail_widget.dart';
import '../components/shimmer_detail_widget.dart';

class DetailPage extends StatefulWidget {
  final String id;

  const DetailPage({
    super.key,
    required this.id,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<StoryDetailProvider>().getStoryDetail(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<StoryDetailProvider>(
        builder: (context, value, child) {
          return switch (value.resultState) {
            StoryDetailLoadingState() => const Center(
                child: ShimmerStoryDetail(),
              ),
            StoryDetailLoadedState(data: var storyDetail) =>
              storyDetail.story != null
                  ? BodyOfDetail(data: storyDetail.story!)
                  : const Center(
                      child: Message(
                        title: 'Oops! Something went wrong',
                        subtitle: 'Story data is missing.',
                      ),
                    ),
            StoryDetailErrorState() => const Center(
                child: Message(
                  title: 'Oops! Something went wrong',
                  subtitle: 'Please check your internet connection.',
                ),
              ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}
