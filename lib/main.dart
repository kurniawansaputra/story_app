import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/routes/router.dart';
import 'core/themes/theme.dart';
import 'core/themes/util.dart';
import 'data/api/api_service.dart';
import 'data/prefs/prefs.dart';
import 'providers/auth/login_provider.dart';
import 'providers/auth/register_provider.dart';
import 'providers/home/stories_provider.dart';
import 'providers/storyDetail/story_detail.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (context) => ApiService(),
        ),
        Provider(
          create: (context) => Prefs(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginProvider(
            context.read<ApiService>(),
            context.read<Prefs>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => RegisterProvider(
            context.read<ApiService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => StoriesProvider(
            context.read<ApiService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => StoryDetailProvider(
            context.read<ApiService>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Retrieves the default theme for the platform
    //TextTheme textTheme = Theme.of(context).textTheme;

    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "Poppins", "Poppins");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: theme.light(),
      routerConfig: router,
    );
  }
}
