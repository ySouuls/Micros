import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/strings.dart';
import '../state/app_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nome = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? _fotoPath;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  // Carrega o nome e a foto salva do SharedPreferences
  Future<void> _carregarPerfil() async {
    final prefs = await SharedPreferences.getInstance();

    final nomeSalvo = prefs.getString("nome") ?? "";
    final pathFoto = prefs.getString("foto_path");

    // No mobile/desktop confirmamos que o arquivo ainda existe; no Web
    // dart:io não está disponível, então confiamos direto no caminho salvo.
    final fotoValida = pathFoto != null &&
        pathFoto.isNotEmpty &&
        (kIsWeb || File(pathFoto).existsSync());

    if (mounted) {
      setState(() {
        nome.text = nomeSalvo;
        if (fotoValida) {
          _fotoPath = pathFoto;
          profileImagePathNotifier.value = pathFoto; // Atualiza o notificador global
        }
      });
    }
  }

  // Salva o caminho da nova foto selecionada
  Future<void> _salvarFoto(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("foto_path", path);

    setState(() {
      _fotoPath = path;
      profileImagePathNotifier.value = path; // Atualiza o notificador global instantaneamente
    });
  }

  // Remove a foto de perfil atual
  Future<void> _removerFoto() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("foto_path"); // Remove do armazenamento

    setState(() {
      _fotoPath = null;
      profileImagePathNotifier.value = null; // Reseta o notificador global
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(tr(context, 'photo_removed'))),
    );
  }

  // Abre a câmera ou galeria para trocar a foto
  Future<void> _selecionarFoto(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image != null) {
      await _salvarFoto(image.path);
    }
  }

  // Modal de opções (Câmera / Galeria / Remover)
  void _exibirOpcoesSelecao() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(tr(context, 'take_photo')),
                onTap: () {
                  Navigator.pop(context);
                  _selecionarFoto(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(tr(context, 'open_gallery')),
                onTap: () {
                  Navigator.pop(context);
                  _selecionarFoto(ImageSource.gallery);
                },
              ),
              // Exibe a opção de remover apenas se houver uma foto definida
              if (_fotoPath != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: Text(
                    tr(context, 'remove_photo'),
                    style: const TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _removerFoto();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> salvarNome() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("nome", nome.text);
  }

  @override
  void dispose() {
    nome.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context, 'profile')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const SizedBox(height: 10),
            
            // Avatar com o botão de câmera embutido (Stack)
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 65,
                    backgroundColor: const Color(0xFF22C55E),
                    backgroundImage: profileImageProvider(_fotoPath),
                    child: _fotoPath == null
                        ? const Icon(
                            Icons.person,
                            size: 70,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _exibirOpcoesSelecao,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 3,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            Wrap(
              alignment: WrapAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: _exibirOpcoesSelecao,
                  icon: const Icon(Icons.photo_camera, color: Color(0xFF22C55E)),
                  label: Text(
                    tr(context, 'change_photo'),
                    style: const TextStyle(color: Color(0xFF22C55E), fontWeight: FontWeight.bold),
                  ),
                ),
                if (_fotoPath != null)
                  TextButton.icon(
                    onPressed: _removerFoto,
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: Text(
                      tr(context, 'remove_photo'),
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 30),

            TextField(
              controller: nome,
              decoration: InputDecoration(
                labelText: tr(context, 'name'),
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                icon: const Icon(Icons.save, color: Colors.white),
                label: Text(
                  tr(context, 'save'),
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  await salvarNome();

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(tr(context, 'profile_updated')),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}