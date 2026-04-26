import 'dart:io';
import 'package:flutter/material.dart';
import 'package:epub_view/epub_view.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../widgets/appearance_bottom_sheet.dart';
import '../providers/settings_provider.dart';

class ReaderScreen extends StatefulWidget {
  final bool isFromNav;
  final Book? book;

  const ReaderScreen({super.key, required this.isFromNav, this.book});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  EpubController? _epubController;
  
  // Variáveis para controlar o progresso
  double _progress = 0.0;
  String _progressText = 'Carregando...';

  @override
  void initState() {
    super.initState();
    if (widget.book != null && widget.book!.type == BookType.epub) {
      _epubController = EpubController(
        document: EpubDocument.openFile(File(widget.book!.filePath)),
      );
    }
  }

  @override
  void dispose() {
    _epubController?.dispose();
    super.dispose();
  }

  // Lógica para pegar a cor de fundo escolhida
  Color _getBackgroundColor(String theme) {
    switch (theme) {
      case 'claro': return Colors.white;
      case 'escuro': return const Color(0xFF2D2D3A);
      case 'amoled': return Colors.black;
      case 'sepia': default: return const Color(0xFFF4EAD5);
    }
  }

  // Lógica para pegar a cor do texto (escuro se o fundo for claro, claro se o fundo for escuro)
  Color _getTextColor(String theme) {
    switch (theme) {
      case 'claro': return Colors.black87;
      case 'escuro': return Colors.white70;
      case 'amoled': return Colors.white;
      case 'sepia': default: return const Color(0xFF3E2723);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.book == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0D0D12),
        body: Center(child: Text('Nenhum livro aberto.', style: TextStyle(color: Colors.white54))),
      );
    }

    final book = widget.book!;
    final settings = Provider.of<SettingsProvider>(context);

    Color bgColor = _getBackgroundColor(settings.readerTheme);
    Color textColor = _getTextColor(settings.readerTheme);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor), // Ícone escuro ou claro dependendo do tema
        leading: widget.isFromNav ? null : IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(book.title, style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
            Text(book.author, style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 12)),
          ],
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // AQUI ESTÁ O TRUQUE: Envolver o leitor em um DefaultTextStyle para forçar a cor e fonte!
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 90.0),
              child: DefaultTextStyle(
                style: TextStyle(
                  color: textColor,
                  fontSize: settings.fontSize,
                  fontFamily: settings.fontFamily,
                ),
                child: _buildReaderContent(book, bgColor),
              ),
            ),
          ),
          
          Positioned(bottom: 0, left: 0, right: 0, child: _ReaderBottomBar(progress: _progress, text: _progressText)),
        ],
      ),
    );
  }

  Widget _buildReaderContent(Book book, Color bgColor) {
    if (book.type == BookType.epub) {
      if (_epubController == null) return const Center(child: CircularProgressIndicator());
      
      return EpubView(
        controller: _epubController!,
        // Tenta capturar a mudança de capítulo no EPUB
        onDocumentLoaded: (doc) {
          setState(() { _progressText = 'Livro pronto!'; });
        },
        onChapterChanged: (chapter) {
          setState(() {
            _progressText = 'Capítulo atual'; // EPUBs não tem páginas exatas, eles são fluidos
          });
        },
      );
    } else if (book.type == BookType.pdf) {
      return PDFView(
        filePath: book.filePath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: true,
        backgroundColor: bgColor, // Usa a cor do tema
        // Captura a troca de páginas do PDF!
        onPageChanged: (int? page, int? total) {
          if (page != null && total != null && total > 0) {
            setState(() {
              _progressText = 'Página ${page + 1} de $total';
              _progress = page / total;
            });
          }
        },
      );
    } else {
      return const Center(child: Text('Formato não suportado', style: TextStyle(color: Colors.black)));
    }
  }
}

class _ReaderBottomBar extends StatelessWidget {
  final double progress;
  final String text;

  const _ReaderBottomBar({required this.progress, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: const BoxDecoration(
        color: Color(0xFF24243E),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, -5))]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(text, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              const Spacer(),
              Text('${(progress * 100).toStringAsFixed(0)}%', style: const TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildControlBtn(Icons.format_list_bulleted, 'Sumário', null),
              _buildControlBtn(Icons.text_format, 'Aparência', () => _showAppearanceSheet(context)),
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
