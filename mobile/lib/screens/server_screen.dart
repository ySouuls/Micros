import 'package:flutter/material.dart';

class ServerScreen extends StatefulWidget {
  const ServerScreen({super.key});

  @override
  State<ServerScreen> createState() => _ServerScreenState();
}

class _ServerScreenState extends State<ServerScreen> {
  final TextEditingController controller =
      TextEditingController(text: "http://127.0.0.1:8000");

  bool online = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Servidor"),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Endereço da API",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.cloud),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.wifi),
              label: const Text("Testar conexão"),
              onPressed: () {
                setState(() {
                  online = !online;
                });
              },
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Icon(
                  Icons.circle,
                  color: online ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 10),
                Text(
                  online ? "Servidor Online" : "Servidor Offline",
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}