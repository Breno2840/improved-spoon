enum BookType {
  epub,
  pdf,
}

class Book {
  final String id;
  final String title;
  final String author;
  final String filePath; // Onde o arquivo físico está salvo no celular
  final BookType type;
  final double progress; // Porcentagem de leitura (ex: 0.42 para 42%)
  final String? coverPath; // Caminho para a imagem da capa (opcional)
  final int lastPageRead; // Última página acessada

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.filePath,
    required this.type,
    this.progress = 0.0,
    this.coverPath,
    this.lastPageRead = 0,
  });

  // Transforma o objeto em um Map para podermos salvar no banco de dados local (SQLite, Hive, etc) depois
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'filePath': filePath,
      'type': type.name,
      'progress': progress,
      'coverPath': coverPath,
      'lastPageRead': lastPageRead,
    };
  }

  // Cria um objeto Book a partir de um Map lido do banco de dados
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as String,
      title: map['title'] as String,
      author: map['author'] as String,
      filePath: map['filePath'] as String,
      type: BookType.values.firstWhere((e) => e.name == map['type']),
      progress: (map['progress'] as num).toDouble(),
      coverPath: map['coverPath'] as String?,
      lastPageRead: map['lastPageRead'] as int? ?? 0,
    );
  }
}
