import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/glass_container.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';
import 'import_screen.dart';
import 'reader_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        final List<Book> myBooks = bookProvider.books;

        return SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Sua Biblioteca', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('Seus livros, do seu jeito.', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6))),
                            ],
                          ),
                          if (myBooks.isNotEmpty)
                            InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const ImportScreen()));
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.add, color: Theme.of(context).colorScheme.primary, size: 20),
                                    const SizedBox(width: 8),
                                    Text('Importar', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            )
                        ],
                      ),
                      
                      if (myBooks.length >= 2) ...[
                        const SizedBox(height: 24),
                        GlassContainer(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          borderRadius: 16,
                          child: TextField(
                            decoration: InputDecoration(
                              icon: Icon(Icons.search, color: Colors.white.withOpacity(0.5)),
                              hintText: 'Buscar livro',
                              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],

                      if (myBooks.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            _buildFilterChip(context, 'Todos', true),
                            const SizedBox(width: 12),
                            _buildFilterChip(context, 'EPUB', false),
                            const SizedBox(width: 12),
                            _buildFilterChip(context, 'PDF', false),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              if (myBooks.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyState(context),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.55,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 24,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == myBooks.length) {
                          return _buildImportCard(context);
                        }
                        return _buildBookCard(context, myBooks[index], index);
                      },
                      childCount: myBooks.length + 1,
                    ),
                  ),
                ),
                
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_stories_rounded, 
              size: 80, 
              color: Theme.of(context).colorScheme.primary.withOpacity(0.6)
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Sua estante está vazia', 
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 12),
          Text(
            'Importe seus arquivos EPUB ou PDF para começar a sua leitura offline e privada.', 
            textAlign: TextAlign.center, 
            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14, height: 1.5)
          ),
          const SizedBox(height: 40),
          
          ElevatedButton.icon(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ImportScreen())),
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Importar meu primeiro livro', style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              elevation: 8,
              shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.1)),
      ),
      child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.white.withOpacity(0.7), fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
    );
  }

  Widget _buildBookCard(BuildContext context, Book book, int index) {
    Widget coverWidget;

    if (book.coverPath != null && File(book.coverPath!).existsSync()) {
      coverWidget = Image.file(
        File(book.coverPath!),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else {
      final colors = [Colors.green.shade900, Colors.red.shade900, Colors.brown.shade800, Colors.blueGrey.shade800, Colors.indigo.shade900];
      final color = colors[index % colors.length];

      coverWidget = Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color, Colors.black87]),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              book.title, 
              textAlign: TextAlign.center, 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        // A MÁGICA: Aqui enviamos o "book" clicado para a ReaderScreen ler!
        Navigator.push(context, MaterialPageRoute(builder: (_) => ReaderScreen(isFromNav: false, book: book)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    coverWidget,
                    
                    Positioned(
                      top: 8, right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)),
                        child: Text(book.type.name.toUpperCase(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white70)),
                      ),
                    ),
                    
                    Positioned(
                      bottom: 0, left: 0, right: 0,
                      child: LinearProgressIndicator(
                        value: book.progress, 
                        backgroundColor: Colors.white.withOpacity(0.2), 
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary), 
                        minHeight: 4
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(book.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Text(book.author, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildImportCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ImportScreen())),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withOpacity(0.2), style: BorderStyle.solid, width: 1),
                color: Colors.white.withOpacity(0.02),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.folder_open_rounded, color: Colors.white.withOpacity(0.5), size: 32),
                    const SizedBox(height: 8),
                    Text('Importar\nlivro', textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text("", style: TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
