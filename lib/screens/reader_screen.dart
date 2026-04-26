import 'dart:io';
import 'package:flutter/material.dart';
import 'package:epub_view/epub_view.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import '../models/book.dart';
import '../widgets/appearance_bottom_sheet.dart';

class ReaderScreen extends StatefulWidget {
  final bool isFromNav;
  final Book? book; // Agora a tela pode receber um livro de verdade!

  const ReaderScreen({super.key, required this.isFromNav, this.book});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  EpubController? _epubController;

  @override
  void initState() {
    super.initState();
    // Se o livro for um EPUB, preparamos o controlador para abrir o arquivo
    if (widget.book != null && widget.book!.type == BookType.epub) {
      _epubController = EpubController(
        document: EpubDocument.openFile(File(widget.book!.filePath)),
      );
    }
  }

  @override
  void dispose() {
    _epubController?.dispose(); // Limpa a memória quando fechamos o livro
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Se não tiver livro (ex: o usuário clicou na aba Leitura mas não abriu nada)
    if (widget.book == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0D0D12),
        body: Center(
          child: Text('Nenhum livro aberto no momento.\nAbra um livro na sua Biblioteca.', 
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 16)
          ),
        ),
      );
    }

    final book = widget.book!;

    return Scaffold(
      backgroundColor: const Color(0xFFF4EAD5), // Cor de papel sepia
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        leading: widget.isFromNav ? null : IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            // Agora usa o título e o autor reais no topo da tela!
            Text(book.title, style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
            Text(book.author, style: const TextStyle(color: Colors.black54, fontSize: 12)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.bookmark_border), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          // ÁREA DO LIVRO REAL
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100.0), // Deixa espaço para a barra de menu
              child: _buildReaderContent(book),
            ),
          ),
          
          // Barra de Menu Inferior
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _ReaderBottomBar(),
          )
        ],
      ),
    );
  }

  // Função que decide como renderizar a página (EPUB ou PDF)
  Widget _buildReaderContent(Book book) {
    if (book.type == BookType.epub) {
      if (_epubController == null) return const Center(child: CircularProgressIndicator());
      
      // MÁGICA: O leitor oficial de EPUB
      return EpubView(
        controller: _epubController!,
      );
    } else if (book.type == BookType.pdf) {
      // MÁGICA: O leitor oficial de PDF
      return PDFView(
        filePath: book.filePath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: true,
        backgroundColor: const [244, 234, 213], // Fundo Sépia em RGB
      );
    } else {
      return const Center(child: Text('Formato não suportado', style: TextStyle(color: Colors.black)));
    }
  }
}

// O MENU INFERIOR CONTINUA IGUAL (Design)
class _ReaderBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: const BoxDecoration(
        color: Color(0xFF24243E),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, -5))
        ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text('Lendo...', style: TextStyle(color: Colors.white54, fontSize: 12)),
              const Spacer(),
              const Text('--%', style: TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.0,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildControlBtn(Icons.format_list_bulleted, 'Sumário', null),
              _buildControlBtn(Icons.text_format, 'Aparência', () {
                _showAppearanceSheet(context);
              }),
              _buildControlBtn(Icons.light_mode_outlined, 'Tema', null),
              _buildControlBtn(Icons.more_horiz, 'Mais', null),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildControlBtn(IconData icon, String label, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  void _showAppearanceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const AppearanceBottomSheet(),
    );
  }
}
