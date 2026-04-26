import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:epubx/epubx.dart' as epub;
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
      notifyListeners();
    }
  }

  // Adiciona um novo livro, extrai a capa real e os metadados
  Future<void> addBook(Book book) async {
    if (book.type == BookType.epub) {
      try {
        final file = File(book.filePath);
        final bytes = await file.readAsBytes();
        
        // Abre o livro em memória usando o epubx
        final epubBook = await epub.EpubReader.readBook(bytes);

        // 1. Extrai o Título e o Autor reais de dentro do arquivo!
        String realTitle = (epubBook.Title != null && epubBook.Title!.isNotEmpty) 
            ? epubBook.Title! 
            : book.title;
            
        String realAuthor = (epubBook.Author != null && epubBook.Author!.isNotEmpty) 
            ? epubBook.Author! 
            : book.author;

        // 2. Lógica avançada para achar a capa real
        String? extractedCoverPath;
        
        if (epubBook.Content?.Images != null && epubBook.Content!.Images!.isNotEmpty) {
          epub.EpubByteContentFile? coverFileContent;

          // Tentativa A: Procurar pelo nome (cover, capa, front)
          for (var image in epubBook.Content!.Images!.values) {
            final fileName = image.FileName?.toLowerCase() ?? '';
            if (fileName.contains('cover') || fileName.contains('capa') || fileName.contains('front')) {
              coverFileContent = image;
              break;
            }
          }

          // Tentativa B: O truque da imagem mais pesada!
          // Se não achou pelo nome, a capa com certeza é o arquivo de imagem com mais bytes no livro.
          if (coverFileContent == null) {
            var largestImage = epubBook.Content!.Images!.values.first;
            
            for (var image in epubBook.Content!.Images!.values) {
              if (image.Content != null && largestImage.Content != null) {
                if (image.Content!.length > largestImage.Content!.length) {
                  largestImage = image; // Atualiza se achar uma imagem mais pesada
                }
              }
            }
            coverFileContent = largestImage;
          }

          // Salva a imagem encontrada na pasta do app
          if (coverFileContent.Content != null) {
            final directory = await getApplicationDocumentsDirectory();
            final coverPath = '${directory.path}/cover_${book.id}.jpg';
            final coverFile = File(coverPath);
            await coverFile.writeAsBytes(coverFileContent.Content!);
            extractedCoverPath = coverPath;
          }
        }

        // Atualizamos o objeto Book com os dados de verdade que encontramos
        book = Book(
          id: book.id,
          title: realTitle,
          author: realAuthor,
          filePath: book.filePath,
          type: book.type,
          progress: book.progress,
          lastPageRead: book.lastPageRead,
          coverPath: extractedCoverPath,
        );

      } catch (e) {
        debugPrint('Erro ao ler os metadados do EPUB: $e');
      }
    }

    _books.add(book);
    notifyListeners(); 
    await _saveToStorage();
  }

  // Deleta um livro da biblioteca (Útil para você apagar esse livro bugado)
  Future<void> removeBook(String id) async {
    _books.removeWhere((book) => book.id == id);
    notifyListeners();
    await _saveToStorage();
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = jsonEncode(_books.map((book) => book.toMap()).toList());
    await prefs.setString('saved_books', encodedList);
  }
}
