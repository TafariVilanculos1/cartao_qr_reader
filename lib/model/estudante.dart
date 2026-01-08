class Estudante {
  final int codigo;
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

  factory Estudante.fromJson(Map<String, dynamic> json) {
    return Estudante(
      codigo: json['codigo'] is int
          ? json['codigo']
          : int.tryParse(json['codigo']?.toString() ?? '0') ?? 0,
      nome: json['nome'] ?? '',
      curso: json['curso'] ?? '',
      faculdade: json['faculdade'] ?? '',
      contacto: json['contacto'] ?? '',
    );
  }
}
