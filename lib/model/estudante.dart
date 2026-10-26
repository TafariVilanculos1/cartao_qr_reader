class Estudante {
  final String codigo;
  final String nome;
  final String delegacao;
  final String campus;
  final String faculdade;
  final String contacto;

  Estudante({
    required this.codigo,
    required this.nome,
    required this.delegacao,
    required this.campus,
    required this.faculdade,
    required this.contacto,
  });

  factory Estudante.fromJson(Map<String, dynamic> json) {
    return Estudante(
      codigo: json['id'] ?? '',
      nome: json['nomecompleto'] ?? '',
      delegacao: json['delegacao'] ?? '',
      campus: json['campus'] ?? '—',
      faculdade: json['faculdade'] ?? '—',
      contacto: json['contacto'] ?? '',
    );
  }
}
