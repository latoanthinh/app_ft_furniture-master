import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture/src/business_logic/splash/bloc.dart';
import 'package:furniture/src/business_logic/splash/event.dart';
import 'package:furniture/src/constants/router.dart';
import 'package:furniture/src/presents/widgets/languages_builder.dart';
import 'package:furniture/src/presents/widgets/splash_builder.dart';

import 'firebase_options.dart';

Future<void> initDependency() async {
  await Future.wait([
    EasyLocalization.ensureInitialized(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependency();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LanguageBuilder(
      child: Builder(builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => SplashBloc()..add(SplashEvent.init())),
          ],
          child: MaterialApp.router(
            routerConfig: AppRouter.goRouter,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: ThemeData.light(),
            darkTheme: ThemeData.light(),
            title: 'Saver',
            builder: (context, child) => SplashBuilder(child: child ?? const SizedBox.shrink()),
          ),
        );
      }),
    );
  }
}
