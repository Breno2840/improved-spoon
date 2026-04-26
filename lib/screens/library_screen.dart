import 'package:flutter/material.dart';
import '../widgets/glass_container.dart';
import 'import_screen.dart';
import 'reader_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              ),
            ),
          ),
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
                  if (index == 5) {
                    return _buildImportCard(context);
                  }
                  return _buildBookCard(context, index);
                },
                childCount: 6,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
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

  Widget _buildBookCard(BuildContext context, int index) {
    final titles = ["O Hobbit", "1984", "Dom Casmurro", "Orgulho e Preconceito", "Moby Dick"];
    final authors = ["J.R.R. Tolkien", "George Orwell", "Machado de Assis", "Jane Austen", "Herman Melville"];
    final progresses = [68, 42, 23, 100, 17];
    final colors = [Colors.green.shade900, Colors.red.shade900, Colors.brown.shade800, Colors.blueGrey.shade800, Colors.indigo.shade900];

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ReaderScreen(isFromNav: false)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [colors[index % colors.length], Colors.black87]),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: Stack(
                children: [
                  Center(child: Text(titles[index], textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: LinearProgressIndicator(value: progresses[index] / 100, backgroundColor: Colors.white.withOpacity(0.2), valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary), minHeight: 4),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(titles[index], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Text(authors[index], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11)),
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
