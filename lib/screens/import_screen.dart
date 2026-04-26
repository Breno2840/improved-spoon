import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/glass_container.dart';
import '../models/book.dart'; // Para sabermos se estamos buscando EPUB ou PDF

class ImportScreen extends StatefulWidget {
  const ImportScreen({super.key});

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  bool _isLoading = false;

  // Função que chama o gerenciador de arquivos do sistema
  Future<void> _pickBook(BookType type) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Define a extensão esperada baseada no tipo (epub ou pdf)
      final String extension = type == BookType.epub ? 'epub' : 'pdf';

      // Abre o seletor nativo do Android
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [extension],
      );

      // Se o usuário selecionou algo (não cancelou)
      if (result != null && result.files.single.path != null) {
        String filePath = result.files.single.path!;
        String fileName = result.files.single.name;

        // Por enquanto, apenas confirmamos que pegamos o arquivo certinho
        // Futuramente, aqui será onde salvaremos o livro no banco de dados
        debugPrint('Arquivo selecionado: $filePath');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$fileName pronto para leitura!'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
          // Volta para a tela da biblioteca após selecionar
          Navigator.pop(context);
        }
      }
    } catch (e) {
      debugPrint('Erro ao importar: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Ops! Algo deu errado ao tentar abrir os arquivos.'),
            backgroundColor: Colors.red.shade800,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Importar livro', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Selecione de onde deseja importar', style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.6))),
                  const SizedBox(height: 32),
                  
                  // Botão de Importar EPUB
                  _buildImportOption(
                    context, 
                    title: 'Importar EPUB', 
                    subtitle: 'Arquivo .epub', 
                    icon: Icons.menu_book_rounded, 
                    color: Colors.purpleAccent,
                    onTap: () => _pickBook(BookType.epub),
                  ),
                  const SizedBox(height: 16),
                  
                  // Botão de Importar PDF
                  _buildImportOption(
                    context, 
                    title: 'Importar PDF', 
                    subtitle: 'Arquivo .pdf', 
                    icon: Icons.picture_as_pdf_rounded, 
                    color: Colors.redAccent,
                    onTap: () => _pickBook(BookType.pdf),
                  ),
                  
                  const SizedBox(height: 40),
                  Text('Outras formas de importar', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6))),
                  const SizedBox(height: 16),
                  
                  GlassContainer(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.share_rounded, color: Theme.of(context).colorScheme.primary),
                          title: const Text('Abrir de outro aplicativo'),
                          subtitle: const Text('Importe arquivos compartilhados', style: TextStyle(fontSize: 12)),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Em breve!')));
                          },
                        ),
                        Divider(color: Colors.white.withOpacity(0.05), height: 1),
                        ListTile(
                          leading: Icon(Icons.folder_rounded, color: Theme.of(context).colorScheme.primary),
                          title: const Text('Selecionar da pasta'),
                          subtitle: const Text('Navegue pelas pastas do aparelho', style: TextStyle(fontSize: 12)),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Em breve!')));
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),
                  GlassContainer(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.lock_outline_rounded, color: Colors.white.withOpacity(0.5), size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Seus livros ficam apenas no seu dispositivo. 100% offline e privado.',
                            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Camada de Loading (Feedback visual se o celular demorar para abrir os arquivos)
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // O componente agora recebe a função onTap
  Widget _buildImportOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.3)),
          ],
        ),
      ),
    );
  }
}
