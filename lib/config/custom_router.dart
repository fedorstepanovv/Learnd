import 'package:flutter/material.dart';
import 'package:learnd/screens/screens.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => Scaffold(),
            settings: const RouteSettings(name: '/'));
      case SigninScreen.routeName:
        return SigninScreen.route();
      case SignupScreen.routeName:
        return SignupScreen.route();
      case SplashScreen.routeName:
        return SplashScreen.route();
      case NavScreen.routeName:
        return NavScreen.route();
    
      default:
        return _errorRoute();
    }
  }

  static Route onGenerateNestedRoute(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      case ProfileScreen.routeName:
        return ProfileScreen.route(args: settings.arguments);
      case EditProfileScreen.routeName:
        return EditProfileScreen.route(args: settings.arguments);
      case UploadMeetingScreen.routeName:
        return UploadMeetingScreen.route();
      case LanguageScreen.routeName:
        return LanguageScreen.route(args: settings.arguments);
      case MeetingDetailScreen.routeName:
        return MeetingDetailScreen.route(args: settings.arguments,);
      case ContactScreen.routeName:
        return ContactScreen.route(args: settings.arguments);
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
        settings: const RouteSettings(
          name: '/error',
        ),
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text("Our Fault"),
              ),
              body: Center(
                  child: Text('Oopss...Sorry, but something went wrong')),
            ));
  }
}
