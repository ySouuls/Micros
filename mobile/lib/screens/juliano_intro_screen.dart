import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../l10n/strings.dart';
import 'ai_chat_screen.dart';

class JulianoIntroScreen extends StatefulWidget {
  const JulianoIntroScreen({super.key});

  @override
  State<JulianoIntroScreen> createState() => _JulianoIntroScreenState();
}

class _JulianoIntroScreenState extends State<JulianoIntroScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/videos/intro_juliano.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    _controller.addListener(() {
      if (_controller.value.isInitialized &&
          _controller.value.position >= _controller.value.duration) {
        _irParaChat();
      }
    });
  }

  void _irParaChat() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AIChatScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const CircularProgressIndicator(
                    color: Color(0xFF22C55E),
                  ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: _irParaChat,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black54,
              ),
              child: Text(tr(context, 'skip')),
            ),
          ),
        ],
      ),
    );
  }
}