import '../models/book.dart';

// Lista falsa de livros usando o modelo que acabamos de criar.
// O filePath está vazio por enquanto porque não temos os arquivos reais.
final List<Book> mockBooks = [
  Book(
    id: '1',
    title: 'O Hobbit',
    author: 'J.R.R. Tolkien',
    filePath: '',
    type: BookType.epub,
    progress: 0.68, // 68%
  ),
  Book(
    id: '2',
    title: '1984',
    author: 'George Orwell',
    filePath: '',
    type: BookType.pdf,
    progress: 0.42, // 42%
  ),
  Book(
    id: '3',
    title: 'Dom Casmurro',
    author: 'Machado de Assis',
    filePath: '',
    type: BookType.epub,
    progress: 0.23, // 23%
  ),
  Book(
    id: '4',
    title: 'Orgulho e Preconceito',
    author: 'Jane Austen',
    filePath: '',
    type: BookType.epub,
    progress: 1.0, // 100%
  ),
  Book(
    id: '5',
    title: 'Moby Dick',
    author: 'Herman Melville',
    filePath: '',
    type: BookType.pdf,
    progress: 0.17, // 17%
  ),
];
