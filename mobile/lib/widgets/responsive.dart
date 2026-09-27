import 'package:flutter/material.dart';

/// Largura a partir da qual consideramos a tela "grande" (navegador
/// desktop). Abaixo disso (celular, app nativo, navegador estreito) o
/// layout continua exatamente igual ao do app.
const double kLargeScreenBreakpoint = 700;

bool isLargeScreen(BuildContext context) =>
    MediaQuery.of(context).size.width >= kLargeScreenBreakpoint;

/// Centraliza o conteúdo e limita a largura em telas grandes, sem
/// afetar em nada o layout em telas estreitas (celular).
class ResponsiveBody extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveBody({super.key, required this.child, this.maxWidth = 640});

  @override
  Widget build(BuildContext context) {
    if (!isLargeScreen(context)) return child;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
