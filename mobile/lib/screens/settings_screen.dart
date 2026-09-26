import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../main.dart';
import 'about_screen.dart';
import 'clear_history_screen.dart';
import 'language_screen.dart';
import 'privacy_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    bool dark = MicrosApp.theme.isDark;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context, 'settings')),
      ),

      body: Stack(
        children: [

          // LOGO COMO FUNDO
          Center(
            child: Opacity(
              opacity: 0.16,

              child: Image.asset(
                "assets/images/logo.png",
                width: 430,
              ),
            ),
          ),


          // CONTEÚDO
          ListView(
            padding: const EdgeInsets.all(20),

            children: [

              Text(
                tr(context, 'appearance'),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),


              const SizedBox(height: 15),


              // CAIXA TRANSPARENTE
              Card(
                color: Colors.transparent,
                elevation: 0,

                child: Column(
                  children: [

                    RadioListTile<bool>(
                      value: true,
                      groupValue: dark,

                      title: Text(
                        tr(context, 'dark_theme'),
                      ),

                      secondary: const Icon(
                        Icons.dark_mode,
                      ),

                      onChanged: (v) {
                        MicrosApp.theme.setDark();
                        setState(() {});
                      },
                    ),


                    RadioListTile<bool>(
                      value: false,
                      groupValue: dark,

                      title: Text(
                        tr(context, 'light_theme'),
                      ),

                      secondary: const Icon(
                        Icons.light_mode,
                      ),

                      onChanged: (v) {
                        MicrosApp.theme.setLight();
                        setState(() {});
                      },
                    ),

                  ],
                ),
              ),


              const SizedBox(height: 30),


              Text(
                tr(context, 'app'),

                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),


              const SizedBox(height: 15),


              ListTile(
                leading: const Icon(
                  Icons.language,
                ),

                title: Text(
                  tr(context, 'language'),
                ),

                trailing: const Icon(
                  Icons.arrow_forward_ios,
                ),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LanguageScreen(),
                    ),
                  );
                },
              ),


              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                ),

                title: Text(
                  tr(context, 'clear_history'),
                ),

                trailing: const Icon(
                  Icons.arrow_forward_ios,
                ),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ClearHistoryScreen(),
                    ),
                  );
                },
              ),


              ListTile(
                leading: const Icon(
                  Icons.info_outline,
                ),

                title: Text(
                  tr(context, 'about'),
                ),

                trailing: const Icon(
                  Icons.arrow_forward_ios,
                ),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AboutScreen(),
                    ),
                  );
                },
              ),


              ListTile(
                leading: const Icon(
                  Icons.privacy_tip,
                ),

                title: Text(
                  tr(context, 'privacy_policy'),
                ),

                trailing: const Icon(
                  Icons.arrow_forward_ios,
                ),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PrivacyScreen(),
                    ),
                  );
                },
              ),

            ],
          ),

        ],
      ),
    );
  }
}