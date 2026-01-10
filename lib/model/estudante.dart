class Estudante {
  final String codigo;
  final String nome;
  final String curso;
  final String faculdade;
  final String contacto;

  Estudante({
    required this.codigo,
    required this.nome,
    required this.curso,
    required this.faculdade,
    required this.contacto,
  });

  /// Construtor a partir do JSON da API
  factory Estudante.fromJson(Map<String, dynamic> json) {
    return Estudante(
      codigo: json['codigo'] as String,
      nome: json['nome'] as String,
      curso: json['curso'] as String,
      faculdade: json['faculdade'] as String,
      contacto: json['contacto']?.toString() ?? '',
    );
  }

  /// (Opcional) Para enviar para API futuramente
  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'nome': nome,
      'curso': curso,
      'faculdade': faculdade,
      'contacto': contacto,
    };
  }
}
