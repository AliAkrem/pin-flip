import 'package:calendar_view/calendar_view.dart';
import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:pin_flip/utils/colors.dart';
import 'package:pin_flip/data/pin_flip_options.dart';
import 'package:pin_flip/home.dart';
import 'package:pin_flip/login.dart';
import 'package:pin_flip/utils/routes.dart' as routes;
import 'package:pin_flip/utils/theme.dart';

class PinFlipApp extends StatefulWidget {
  const PinFlipApp({super.key});

  static const String loginRoute = routes.loginRoute;
  static const String homeRoute = routes.homeRoute;

  @override
  State<PinFlipApp> createState() => _PinFlipAppState();
}

class _PinFlipAppState extends State<PinFlipApp> {
  final sharedZAxisTransitionBuilder = const SharedAxisPageTransitionsBuilder(
    fillColor: PinFlipColors.primaryBackground,
    transitionType: SharedAxisTransitionType.scaled,
  );

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: EventController(),
      child: MaterialApp(
        restorationScopeId: 'pinFlip_app',
        title: 'PinFlip',
        debugShowCheckedModeBanner: false,
        theme: buildPinFlipTheme().copyWith(
          platform: PinFlipOptions.of(context).platform,
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              for (var type in TargetPlatform.values)
                type: sharedZAxisTransitionBuilder,
            },
          ),
        ),
        localizationsDelegates: GalleryLocalizations.localizationsDelegates,
        supportedLocales: GalleryLocalizations.supportedLocales,
        localeResolutionCallback: (locale, supportedLocales) {
          return deviceLocale;
        },
        locale: PinFlipOptions.of(context).locale,
        initialRoute: PinFlipApp.loginRoute,
        routes: <String, WidgetBuilder>{
          PinFlipApp.homeRoute: (context) => const HomePage(),
          PinFlipApp.loginRoute: (context) => const LoginPage(),
        },
      ),
    );
  }
}
