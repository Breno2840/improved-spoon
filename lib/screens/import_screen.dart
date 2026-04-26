import 'package:flutter/material.dart';
import '../widgets/glass_container.dart';

class ImportScreen extends StatelessWidget {
  const ImportScreen({super.key});

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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Importar livro', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Selecione de onde deseja importar', style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.6))),
              const SizedBox(height: 32),
              
              _buildImportOption(context, 'Importar EPUB', 'Arquivo .epub', Icons.menu_book_rounded, Colors.purpleAccent),
              const SizedBox(height: 16),
              _buildImportOption(context, 'Importar PDF', 'Arquivo .pdf', Icons.picture_as_pdf_rounded, Colors.redAccent),
              
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
                    ),
                    Divider(color: Colors.white.withOpacity(0.05), height: 1),
                    ListTile(
                      leading: Icon(Icons.folder_rounded, color: Theme.of(context).colorScheme.primary),
                      title: const Text('Selecionar da pasta'),
                      subtitle: const Text('Navegue pelas pastas do aparelho', style: TextStyle(fontSize: 12)),
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
      ),
    );
  }

  Widget _buildImportOption(BuildContext context, String title, String subtitle, IconData icon, Color color) {
    return GlassContainer(
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
    );
  }
}
