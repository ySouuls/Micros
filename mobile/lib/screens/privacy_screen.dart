import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../widgets/responsive.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context, 'privacy_policy')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: ResponsiveBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.privacy_tip_outlined,
                size: 60,
                color: Color(0xFF22C55E),
              ),
              const SizedBox(height: 20),
              Text(
                tr(context, 'privacy_intro'),
                style: const TextStyle(fontSize: 15, color: Colors.grey),
              ),
              const SizedBox(height: 25),
              _secao(context, 'privacy_data_collected_title',
                  'privacy_data_collected_body'),
              _secao(context, 'privacy_data_storage_title',
                  'privacy_data_storage_body'),
              _secao(context, 'privacy_third_party_title',
                  'privacy_third_party_body'),
              _secao(context, 'privacy_permissions_title',
                  'privacy_permissions_body'),
              _secao(
                  context, 'privacy_not_done_title', 'privacy_not_done_body'),
              _secao(context, 'privacy_rights_title', 'privacy_rights_body'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _secao(BuildContext context, String tituloKey, String corpoKey) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr(context, tituloKey),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 6),
          Text(
            tr(context, corpoKey),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
