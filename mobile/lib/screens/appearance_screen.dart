import 'package:flutter/material.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {

  String tema = "Sistema";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aparência"),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [

          RadioListTile(
            title: const Text("Claro"),
            value: "Claro",
            groupValue: tema,
            onChanged: (value){
              setState(() {
                tema=value!;
              });
            },
          ),

          RadioListTile(
            title: const Text("Escuro"),
            value: "Escuro",
            groupValue: tema,
            onChanged: (value){
              setState(() {
                tema=value!;
              });
            },
          ),

          RadioListTile(
            title: const Text("Usar tema do sistema"),
            value: "Sistema",
            groupValue: tema,
            onChanged: (value){
              setState(() {
                tema=value!;
              });
            },
          ),

        ],
      ),
    );
  }
}