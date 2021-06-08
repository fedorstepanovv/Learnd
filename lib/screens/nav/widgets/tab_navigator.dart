import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnd/blocs/blocs.dart';
import 'package:learnd/config/custom_router.dart';
import 'package:learnd/enums/enums.dart';
import 'package:learnd/repositories/repositories.dart';
import 'package:learnd/repositories/user/user_repository.dart';
import 'package:learnd/screens/profile/bloc/profile_bloc.dart';
import 'package:learnd/screens/screens.dart';
import 'package:learnd/screens/search/cubit/search_cubit.dart';
import 'package:learnd/screens/upload_post/cubit/upload_post_cubit.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = '/';
  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;

  TabNavigator({Key key, @required this.navigatorKey, @required this.item})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders();

    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatorRoot,
      onGenerateInitialRoutes: (_, initialRoute) {
        return [
          MaterialPageRoute(
            settings: RouteSettings(name: tabNavigatorRoot),
            builder: (context) => routeBuilders[initialRoute](context),
          )
        ];
      },
      onGenerateRoute: CustomRouter.onGenerateNestedRoute,
    );
  }

  Map<String, WidgetBuilder> _routeBuilders() {
    return {tabNavigatorRoot: (context) => _getScreen(context, item)};
  }

  Widget _getScreen(BuildContext context, BottomNavItem item) {
    switch (item) {
      case BottomNavItem.search:
        return BlocProvider(
          create: (context) => SearchCubit(
            languageRepository: context.read<LanguageRepository>(),
          ),
          child: SearchScreen(),
        );
      case BottomNavItem.add:
        return BlocProvider(
          create: (context) => UploadPostCubit(
              storageRepository: context.read<StorageRepository>(),
              authBloc: context.read<AuthBloc>(),
              postRepository: context.read<PostRepository>()),
          child: UploadMeetingScreen(),
        );

      case BottomNavItem.profile:
        return BlocProvider(
          create: (context) => ProfileBloc(
            postRepository: context.read<PostRepository>(),
            authBloc: context.read<AuthBloc>(),
            userRepository: context.read<UserRepository>(),
          )..add(
              ProfileLoadUser(userId: context.read<AuthBloc>().state.user.uid)),
          child: ProfileScreen(),
        );
      default:
        return Scaffold();
    }
  
  }
}
