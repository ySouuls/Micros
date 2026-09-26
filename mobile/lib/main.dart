import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/strings.dart';
import 'screens/splash_screen.dart';
import 'state/locale_provider.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MicrosApp.locale.carregar();

  runApp(const MicrosApp());
}

class MicrosApp extends StatefulWidget {
  const MicrosApp({super.key});

  static final ThemeProvider theme = ThemeProvider();
  static final LocaleProvider locale = LocaleProvider();

  @override
  State<MicrosApp> createState() => _MicrosAppState();
}

class _MicrosAppState extends State<MicrosApp> {
  @override
  void initState() {
    super.initState();

    MicrosApp.theme.addListener(() {
      setState(() {});
    });

    MicrosApp.locale.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MICROS",
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: MicrosApp.theme.themeMode,
      locale: MicrosApp.locale.locale,
      supportedLocales: const [Locale('pt'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => LocaleScope(
        notifier: MicrosApp.locale,
        child: child!,
      ),
      home: const SplashScreen(),
    );
  }
}