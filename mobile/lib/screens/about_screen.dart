import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../widgets/responsive.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context, 'about')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: ResponsiveBody(
          child: Column(
            children: [
              const Icon(
                Icons.science,
                size: 90,
                color: Color(0xFF22C55E),
              ),
              const SizedBox(height: 20),
              const Text(
                "MICROS",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr(context, 'version'),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text("1.2.0 beta"),
                      const SizedBox(height: 20),
                      Text(
                        tr(context, 'developer'),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text("Gabriel Carvalho da Rocha Neves"),
                      const Text("Yuri de Brito Paiva"),
                      const SizedBox(height: 20),
                      Text(
                        tr(context, 'collaboration'),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text("Dra. Juliana Silva Rodrigues Cabral"),
                      const Text("Vanessa Priscila Higino Mussy"),
                      const Text("Maria Luiza Terra Vieira"),
                      const Text("Renan Ramos Rosa"),
                      const SizedBox(height: 20),
                      Text(
                        tr(context, 'description'),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        tr(context, 'about_description'),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "© 2026",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
