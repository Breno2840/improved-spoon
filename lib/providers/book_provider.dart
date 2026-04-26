import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:epubx/epubx.dart' as epub; // Pacote para ler as entranhas do EPUB
import '../models/book.dart';

class BookProvider extends ChangeNotifier {
  List<Book> _books = [];

  List<Book> get books => _books;

  BookProvider() {
    _loadBooks(); // Carrega os livros salvos assim que o app abrir
  }

  // Busca os livros na memória do celular
  Future<void> _loadBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? booksJson = prefs.getString('saved_books');

    if (booksJson != null) {
      final List<dynamic> decodedList = jsonDecode(booksJson);
      _books = decodedList.map((item) => Book.fromMap(item)).toList();
      notifyListeners(); // Avisa a interface para se atualizar
    }
  }

  // Adiciona um novo livro e salva na memória
  Future<void> addBook(Book book) async {
    // Tenta extrair a capa do arquivo antes de salvar
    String? extractedCoverPath = await _extractAndSaveCover(book.filePath, book.id, book.type);

    // Se conseguiu achar uma capa, atualizamos o objeto Book
    if (extractedCoverPath != null) {
      book = Book(
        id: book.id,
        title: book.title,
        author: book.author,
        filePath: book.filePath,
        type: book.type,
        progress: book.progress,
        lastPageRead: book.lastPageRead,
        coverPath: extractedCoverPath, // <--- Salvando o caminho da imagem real
      );
    }

    _books.add(book);
    notifyListeners(); // Atualiza a tela imediatamente
    await _saveToStorage();
  }

  // Função mágica que vasculha o arquivo atrás da capa
  Future<String?> _extractAndSaveCover(String filePath, String bookId, BookType type) async {
    try {
      if (type == BookType.epub) {
        final file = File(filePath);
        final bytes = await file.readAsBytes();
        
        // Abre o livro em memória usando o epubx
        final epubBook = await epub.EpubReader.readBook(bytes);

        // Verifica se o livro tem imagens dentro dele
        if (epubBook.Content?.Images != null && epubBook.Content!.Images!.isNotEmpty) {
          epub.EpubByteContentFile? coverFileContent;

          // Procura por alguma imagem que tenha "cover" no nome (padrão da maioria dos EPUBs)
          for (var image in epubBook.Content!.Images!.values) {
            if (image.FileName != null && image.FileName!.toLowerCase().contains('cover')) {
              coverFileContent = image;
              break;
            }
          }

          // Se não achou com o nome 'cover', chuta a primeira imagem que tiver no livro
          coverFileContent ??= epubBook.Content!.Images!.values.first;

          if (coverFileContent.Content != null) {
            // Descobre a pasta secreta do seu aplicativo no celular
            final directory = await getApplicationDocumentsDirectory();
            final coverPath = '${directory.path}/cover_$bookId.jpg';
            final coverFile = File(coverPath);

            // Escreve a imagem lá dentro
            await coverFile.writeAsBytes(coverFileContent.Content!);
            return coverPath; // Retorna onde a imagem foi parar
          }
        }
      }
      // Nota: Extrair capa de PDF exige renderizar a primeira página. 
      // Por enquanto, o PDF vai usar a cor sólida.
    } catch (e) {
      debugPrint('Erro ao extrair capa: $e');
    }
    return null;
  }

  // Salva a lista atualizada no armazenamento do celular
  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = jsonEncode(_books.map((book) => book.toMap()).toList());
    await prefs.setString('saved_books', encodedList);
  }
}
