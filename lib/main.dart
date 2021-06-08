import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:learnd/blocs/blocs.dart';
import 'package:learnd/blocs/simple_bloc_observer.dart';
import 'package:learnd/config/color_pallete.dart';
import 'package:learnd/config/custom_router.dart';

import 'repositories/repositories.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObserver();
  await precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/svg/lines.svg'),
      null);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (_) => AuthRepository()),
        RepositoryProvider<UserRepository>(create: (_) => UserRepository()),
        RepositoryProvider<StorageRepository>(
            create: (_) => StorageRepository()),
        RepositoryProvider<PostRepository>(create: (_) => PostRepository()),
        RepositoryProvider<LanguageRepository>(
            create: (_) => LanguageRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) =>
                AuthBloc(authRepository: context.read<AuthRepository>()),
          )
        ],
        child: MaterialApp(
          title: 'Learnd',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: "SF",
            brightness: Brightness.dark,
            scaffoldBackgroundColor: ColorPallete.backgroundColor,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          onGenerateRoute: CustomRouter.onGenerateRoute,
          initialRoute: '/splash',
        ),
      ),
    );
  }
}
