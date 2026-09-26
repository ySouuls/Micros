import 'package:flutter/material.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {

  String qualidade = "Alta";

  bool comprimir = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Captura"),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          const Text(
            "Qualidade da imagem",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          RadioListTile(
            value: "Alta",
            groupValue: qualidade,
            title: const Text("Alta"),
            onChanged: (value){
              setState(() {
                qualidade=value!;
              });
            },
          ),

          RadioListTile(
            value: "Média",
            groupValue: qualidade,
            title: const Text("Média"),
            onChanged: (value){
              setState(() {
                qualidade=value!;
              });
            },
          ),

          RadioListTile(
            value: "Baixa",
            groupValue: qualidade,
            title: const Text("Baixa"),
            onChanged: (value){
              setState(() {
                qualidade=value!;
              });
            },
          ),

          const Divider(),

          SwitchListTile(
            title: const Text("Comprimir imagem"),
            value: comprimir,
            onChanged: (value){
              setState(() {
                comprimir=value;
              });
            },
          )

        ],
      ),
    );
  }
}