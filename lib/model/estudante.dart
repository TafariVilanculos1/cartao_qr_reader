class Estudante {
  final String codigo;
  final String nome;
  final String genero;
  final String curso;
  final String faculdade;
  final String contacto;

  Estudante({
    required this.codigo,
    required this.nome,
    required this.genero,
    required this.curso,
    required this.faculdade,
    required this.contacto,
  });

  factory Estudante.fromJson(Map<String, dynamic> json) {
    return Estudante(
      codigo: json['id'] ?? '',
      nome: json['nomecompleto'] ?? '',
      genero: json['genero'] ?? '',
      curso: json['curso'] ?? '—',
      faculdade: json['faculdade'] ?? '—',
      contacto: json['contacto'] ?? '',
    );
  }
}
