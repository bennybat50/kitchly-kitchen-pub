// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';

import 'ui/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    runApp(StartApp());
  });
}

class StartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.grey[200], // navigation bar color
        systemNavigationBarIconBrightness: Brightness.dark));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppBloc>.value(value: AppBloc()),
      ],
      child: MaterialApp(
        title: 'Kitchly Chef',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: 'CeraPro',
            focusColor: Color(PublicVar.primaryColor),
            indicatorColor: Color(PublicVar.primaryColor),
            primaryColorLight: Color(PublicVar.primaryColor),
            primaryColorBrightness: Brightness.light,
            unselectedWidgetColor: Color(PublicVar.primaryColor),
            primaryColor: Color(PublicVar.primaryColor),
            primaryColorDark: Color(PublicVar.primaryColor),
            accentColor: Color(PublicVar.primaryColor),
            primarySwatch: KitchlyPalette.kToDark),

        // navigatorObservers: [observer],
        home: SplashScreen(), //Base InfoGraph
      ),
    );
  }
}

class KitchlyPalette {
  static const MaterialColor kToDark = const MaterialColor(
    0XFF34D186, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    const <int, Color>{
      50: const Color(0xffce5641), //10%
      100: const Color(0xffb74c3a), //20%
      200: const Color(0xffa04332), //30%
      300: const Color(0xff89392b), //40%
      400: const Color(0xff733024), //50%
      500: const Color(0xff5c261d), //60%
      600: const Color(0xff451c16), //70%
      700: const Color(0xff2e130e), //80%
      800: const Color(0xff170907), //90%
      900: const Color(0XFF34D186), //100%
    },
  );
}
