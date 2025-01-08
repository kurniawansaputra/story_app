import 'package:go_router/go_router.dart';

import '../../ui/account/pages/account_page.dart';
import '../../ui/addNewStory/pages/add_new_story_page.dart';
import '../../ui/auth/pages/login_page.dart';
import '../../ui/auth/pages/register_page.dart';
import '../../ui/detail/pages/detail_page.dart';
import '../../ui/home/pages/home_page.dart';
import '../../ui/selectLocation/pages/select_location_page.dart';

part 'route_name.dart';

final GoRouter router = GoRouter(
  initialLocation: Routes.login,
  routes: [
    GoRoute(
      path: Routes.login,
      name: Routes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: Routes.register,
      name: Routes.register,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: Routes.home,
      name: Routes.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: Routes.addNewStory,
      name: Routes.addNewStory,
      builder: (context, state) => AddNewStoryPage(
        onRefresh: state.extra as void Function(),
      ),
    ),
    GoRoute(
      path: Routes.selectLocation,
      name: Routes.selectLocation,
      builder: (context, state) => SelectLocationPage(
        onLocationSelected: (latLng) {},
      ),
    ),
    GoRoute(
      path: Routes.account,
      name: Routes.account,
      builder: (context, state) => const AccountPage(),
    ),
    GoRoute(
      path: '${Routes.detailStory}/:id',
      name: Routes.detailStory,
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return DetailPage(id: id!);
      },
    ),
  ],
);
