import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

import '../../../core/components/message_widget.dart';
import '../../../core/routes/router.dart';
import '../../../core/static/stories.dart';
import '../../../providers/home/stories_provider.dart';
import '../components/shimmer_story_card_widget.dart';
import '../components/story_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? location = 1;
  final ScrollController scrollController = ScrollController();

  Future<void> _onRefresh() async {
    final storiesProvider = context.read<StoriesProvider>();
    storiesProvider.resetStories();
    await storiesProvider.getStories(
      location: location,
    );
  }

  @override
  void initState() {
    super.initState();
    final storiesProvider = context.read<StoriesProvider>();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        if (storiesProvider.pageItems != null) {
          storiesProvider.getStories(
            location: location,
          );
        }
      }
    });

    Future.microtask(
      () async => storiesProvider.getStories(
        location: location,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memoirly'),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/images/ic_profile.png',
              width: 28.0,
              height: 28.0,
            ),
            onPressed: () {
              context.push(Routes.account);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(Routes.addNewStory, extra: _onRefresh);
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Consumer<StoriesProvider>(
          builder: (context, provider, child) {
            return LiquidPullToRefresh(
              onRefresh: _onRefresh,
              showChildOpacityTransition: false,
              child: switch (provider.storiesState) {
                StoriesLoadingState() => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: 3, // Show 3 shimmer items while loading
                      itemBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: ShimmerStoryCard(), // Shimmer effect
                        );
                      },
                    ),
                  ),
                StoriesLoadedState(data: var stories) => stories.isNotEmpty
                    ? ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        itemCount: stories.length +
                            (provider.pageItems != null ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == stories.length &&
                              provider.pageItems != null) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final story = stories[index];

                          bool isFirstCard = index == 0;
                          bool isLastCard = index == stories.length - 1;

                          return Container(
                            margin: EdgeInsets.only(
                              top: isFirstCard ? 16.0 : 4.0,
                              bottom: isLastCard ? 16.0 : 4.0,
                              left: 16.0,
                              right: 16.0,
                            ),
                            child: StoryCard(
                              story: story,
                              onTap: (id) {
                                context.push('${Routes.detailStory}/$id');
                              },
                            ),
                          );
                        },
                      )
                    : const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Center(
                          child: Message(
                            title: 'No stories found',
                            subtitle: 'Start adding your stories now!',
                          ),
                        ),
                      ),
                StoriesErrorState() => const Center(
                    child: Message(
                      title: 'Oops! Something went wrong',
                      subtitle: 'Please check your internet connection.',
                    ),
                  ),
                _ => const SizedBox(),
              },
            );
          },
        ),
      ),
    );
  }
}
