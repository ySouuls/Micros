import 'package:flutter/material.dart';

class DeveloperScreen extends StatefulWidget {
  const DeveloperScreen({super.key});

  @override
  State<DeveloperScreen> createState() =>
      _DeveloperScreenState();
}

class _DeveloperScreenState
    extends State<DeveloperScreen> {

  bool confianca = true;
  bool tempo = true;
  bool api = false;
  bool caixas = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modo Desenvolvedor"),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [

          SwitchListTile(
            title: const Text("Mostrar confiança"),
            value: confianca,
            onChanged: (v){
              setState(() {
                confianca=v;
              });
            },
          ),

          SwitchListTile(
            title: const Text("Mostrar tempo"),
            value: tempo,
            onChanged: (v){
              setState(() {
                tempo=v;
              });
            },
          ),

          SwitchListTile(
            title: const Text("Mostrar resposta da API"),
            value: api,
            onChanged: (v){
              setState(() {
                api=v;
              });
            },
          ),

          SwitchListTile(
            title: const Text("Mostrar caixas de detecção"),
            value: caixas,
            onChanged: (v){
              setState(() {
                caixas=v;
              });
            },
          ),

        ],
      ),
    );
  }
}