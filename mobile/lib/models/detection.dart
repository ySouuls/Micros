class Detection {
  final String classe;
  final double confianca;
  final double x1;
  final double y1;
  final double x2;
  final double y2;

  Detection({
    required this.classe,
    required this.confianca,
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
  });

  factory Detection.fromJson(Map<String, dynamic> json) {
    return Detection(
      classe: json["classe"],
      confianca: (json["confianca"] as num).toDouble(),
      x1: (json["x1"] as num).toDouble(),
      y1: (json["y1"] as num).toDouble(),
      x2: (json["x2"] as num).toDouble(),
      y2: (json["y2"] as num).toDouble(),
    );
  }
}