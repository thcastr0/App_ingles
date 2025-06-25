class Palavra {
  final int? id;
  final String palavra;
  final String significado;
  final bool aprendida;

  Palavra({
    this.id,
    required this.palavra,
    required this.significado,
    this.aprendida = false,
  });

  factory Palavra.fromMap(Map<String, dynamic> map) {
    return Palavra(
      id: map['id'],
      palavra: map['palavra'],
      significado: map['significado'],
      aprendida: map['aprendida'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'palavra': palavra,
      'significado': significado,
      'aprendida': aprendida ? 1 : 0,
    };
  }
}
