import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pin_flip/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/constants.dart';
import 'data/pin_flip_options.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    this.isTestMode = false,
  });

  final bool isTestMode;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String? localeString = prefs.getString(localeKey);
    if (localeString != null) {
      setState(() {
        _locale = Locale(localeString);
        deviceLocale = _locale;
      });
    } else {
      prefs.setString(localeKey, 'en');
      setState(() {
        _locale = const Locale('en');
        deviceLocale = _locale;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModelBinding(
      initialModel: PinFlipOptions(
        themeMode: ThemeMode.system,
        textScaleFactor: systemTextScaleFactorOption,
        customTextDirection: CustomTextDirection.localeBased,
        locale: _locale,
        timeDilation: timeDilation,
        platform: defaultTargetPlatform,
        isTestMode: widget.isTestMode,
      ),
      child: Builder(builder: (context) {
        return const PinFlipApp();
      }),
    );
  }
}
