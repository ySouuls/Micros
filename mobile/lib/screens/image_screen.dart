import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  final ImagePicker picker = ImagePicker();

  XFile? imagem;

  Future<void> escolherImagem() async {
    final XFile? foto = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (foto != null) {
      setState(() {
        imagem = foto;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nova Análise"),
        backgroundColor: const Color(0xff2E7D32),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: imagem == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            size: 100,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 15),
                          Text(
                            "Nenhuma imagem selecionada",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    : kIsWeb
                        ? Image.network(
                            imagem!.path,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(imagem!.path),
                            fit: BoxFit.cover,
                          ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: 250,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: escolherImagem,
                  icon: const Icon(Icons.photo_library),
                  label: const Text(
                    "Escolher imagem",
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2E7D32),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: 250,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: imagem == null
                      ? null
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Aqui será iniciada a análise da IA.",
                              ),
                            ),
                          );
                        },
                  icon: const Icon(Icons.psychology),
                  label: const Text(
                    "Analisar",
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2E7D32),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}