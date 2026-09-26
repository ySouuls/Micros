import 'package:flutter/material.dart';

import '../l10n/strings.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = LocaleScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context, 'language')),
      ),
      body: ListView(
        children: [
          RadioListTile<String>(
            value: 'pt',
            groupValue: locale.languageCode,
            title: Text(tr(context, 'portuguese')),
            secondary: const Text("🇧🇷", style: TextStyle(fontSize: 22)),
            onChanged: (_) => locale.setPortuguese(),
          ),
          RadioListTile<String>(
            value: 'en',
            groupValue: locale.languageCode,
            title: Text(tr(context, 'english')),
            secondary: const Text("🇺🇸", style: TextStyle(fontSize: 22)),
            onChanged: (_) => locale.setEnglish(),
          ),
        ],
      ),
    );
  }
}
