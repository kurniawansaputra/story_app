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
  int page = 1;
  int size = 10;
  int location = 1;

  Future<void> _onRefresh() async {
    await context.read<StoriesProvider>().getStories(
          page: page,
          size: size,
          location: location,
        );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        _onRefresh();
      },
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
          context.push(Routes.addNewStory);
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Consumer<StoriesProvider>(
          builder: (context, provider, child) {
            return LiquidPullToRefresh(
              onRefresh: _onRefresh,
              showChildOpacityTransition: false,
              child: switch (provider.resultState) {
                StoriesLoadingState() => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          child: ShimmerStoryCard(),
                        );
                      },
                    ),
                  ),
                StoriesLoadedState(data: var stories) => stories.isNotEmpty
                    ? ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        itemCount: stories.length,
                        itemBuilder: (context, index) {
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
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
