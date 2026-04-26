import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    _books.add(book);
    notifyListeners(); // Atualiza a tela imediatamente
    await _saveToStorage();
  }

  // Salva a lista atualizada no armazenamento do celular
  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = jsonEncode(_books.map((book) => book.toMap()).toList());
    await prefs.setString('saved_books', encodedList);
  }
}
