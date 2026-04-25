import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const EbookReaderApp());
}

// ==========================================
// TEMA E CONFIGURAÇÕES GERAIS
// ==========================================
class EbookReaderApp extends StatelessWidget {
  const EbookReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline Ebook Reader',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF9D7BFF), // Roxo moderno
          surface: const Color(0xFF16161E),
          background: const Color(0xFF0D0D12),
        ),
        scaffoldBackgroundColor: Colors.transparent, // Para o gradiente global funcionar
        fontFamily: 'Inter', // Assumindo uma fonte limpa padrão
      ),
      home: const MainNavigator(),
    );
  }
}

// ==========================================
// NAVEGAÇÃO PRINCIPAL (BOTTOM BAR)
// ==========================================
class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const LibraryScreen(),
    const ReaderScreen(isFromNav: true),
    const Center(child: Text('Marcadores - Em breve')),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Fundo global com gradiente suave
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E1533), // Roxo bem escuro
            Color(0xFF0A0A0F), // Quase preto
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: GlassBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}

// ==========================================
// COMPONENTES REUTILIZÁVEIS
// ==========================================
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class GlassBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const GlassBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0D0D12).withOpacity(0.8),
            border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.white54,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded), label: 'Biblioteca'),
              BottomNavigationBarItem(icon: Icon(Icons.auto_stories_rounded), label: 'Leitura'),
              BottomNavigationBarItem(icon: Icon(Icons.bookmark_border_rounded), label: 'Marcadores'),
              BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Configurações'),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// TELA 1: BIBLIOTECA
// ==========================================
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
                          const Text(
                            'Sua Biblioteca',
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Seus livros, do seu jeito.',
                            style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6)),
                          ),
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
                  // Barra de busca
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
                  // Filtros
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
                    return _buildImportCard(context); // Card especial de importar
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
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
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
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colors[index % colors.length], Colors.black87],
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(titles[index], textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: LinearProgressIndicator(
                      value: progresses[index] / 100,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                      minHeight: 4,
                    ),
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
          const Text("", style: TextStyle(fontSize: 13)), // Spacer
        ],
      ),
    );
  }
}

// ==========================================
// TELA 2: IMPORTAÇÃO
// ==========================================
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
          onTap: () => Navigator.pop(context),
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

// ==========================================
// TELA 3: LEITURA
// ==========================================
class ReaderScreen extends StatelessWidget {
  final bool isFromNav;
  const ReaderScreen({super.key, required this.isFromNav});

  @override
  Widget build(BuildContext context) {
    // Simulando o tema de leitura (Sépia/Creme)
    return Scaffold(
      backgroundColor: const Color(0xFFF4EAD5), // Cor de papel sepia
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        leading: isFromNav ? null : IconButton(
          icon: const Icon(Icons.arrow_back),
          onTap: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            const Text('O Hobbit', style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
            Text('J.R.R. Tolkien', style: TextStyle(color: Colors.black54, fontSize: 12)),
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
          // Área de texto
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ListView(
              children: const [
                SizedBox(height: 20),
                Text('Capítulo 1', style: TextStyle(color: Colors.black87, fontSize: 28, fontFamily: 'Lora', fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Uma festa inesperada', style: TextStyle(color: Colors.black54, fontSize: 20, fontFamily: 'Lora', fontStyle: FontStyle.italic)),
                SizedBox(height: 32),
                Text(
                  'Em um buraco no chão vivia um hobbit. Não era um buraco nojento, sujo e úmido, cheio de pontas de minhoca e um cheiro de lodo, nem também seco, vazio e arenoso, sem nada para sentar ou para comer: era um buraco hobbit, e isso significa conforto.\n\nTinha uma porta perfeitamente redonda como uma vigia de navio, pintada de verde e com uma maçaneta brilhante bem no meio. A porta se abria para um túnel em forma de tubo como um corredor: um túnel muito confortável, sem fumaça, com painéis nas paredes e pisos ladrilhados e atapetados, provido de cadeiras polidas, e montes e montes de cabides para chapéus e casacos – o hobbit gostava de visitas.',
                  style: TextStyle(color: Colors.black87, fontSize: 18, fontFamily: 'Lora', height: 1.6),
                ),
                SizedBox(height: 100), // Espaço pro bottom bar
              ],
            ),
          ),
          
          // Controles inferiores fixos na tela de leitura
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
}

class _ReaderBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: const BoxDecoration(
        color: Color(0xFF24243E), // Fundo escuro flutuante
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, -5))
        ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Barra de progresso
          Row(
            children: [
              const Text('Página 24 de 310', style: TextStyle(color: Colors.white54, fontSize: 12)),
              const Spacer(),
              const Text('7%', style: TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.07,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 24),
          // Botões
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

// ==========================================
// TELA 4: APARÊNCIA (BOTTOM SHEET)
// ==========================================
class AppearanceBottomSheet extends StatefulWidget {
  const AppearanceBottomSheet({super.key});

  @override
  State<AppearanceBottomSheet> createState() => _AppearanceBottomSheetState();
}

class _AppearanceBottomSheetState extends State<AppearanceBottomSheet> {
  double _fontSize = 18;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 30,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white30, borderRadius: BorderRadius.circular(2))),
          ),
          const SizedBox(height: 24),
          const Text('Aparência', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          
          const Text('Tema', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildThemeCircle(Colors.white, 'Claro', false),
              _buildThemeCircle(const Color(0xFF2D2D3A), 'Escuro', false),
              _buildThemeCircle(const Color(0xFFF4EAD5), 'Sepia', false),
              _buildThemeCircle(Colors.black, 'Amoled', true),
            ],
          ),
          const SizedBox(height: 24),
          
          const Text('Fonte', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFontBox('Lora', true),
              _buildFontBox('Merriweather', false),
              _buildFontBox('Inter', false),
            ],
          ),
          const SizedBox(height: 24),
          
          const Text('Tamanho da fonte', style: TextStyle(color: Colors.white70)),
          Row(
            children: [
              const Text('A-', style: TextStyle(fontSize: 16)),
              Expanded(
                child: Slider(
                  value: _fontSize,
                  min: 12,
                  max: 32,
                  activeColor: Theme.of(context).colorScheme.primary,
                  inactiveColor: Colors.white24,
                  onChanged: (val) => setState(() => _fontSize = val),
                ),
              ),
              const Text('A+', style: TextStyle(fontSize: 20)),
            ],
          ),
          const SizedBox(height: 16),
          
          const Text('Espaçamento entre linhas', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSpacingBox(Icons.format_line_spacing, false),
              _buildSpacingBox(Icons.format_line_spacing, true),
              _buildSpacingBox(Icons.format_line_spacing, false),
            ],
          ),
          const SizedBox(height: 24),
          
          const Text('Modo de leitura', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildModeBtn('Página', Icons.menu_book, true)),
              const SizedBox(width: 16),
              Expanded(child: _buildModeBtn('Rolagem', Icons.swap_vert, false)),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildThemeCircle(Color color, String label, bool isSelected) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: isSelected ? Colors.deepPurpleAccent : Colors.white24, width: 2),
          ),
          child: isSelected ? const Icon(Icons.check, color: Colors.deepPurpleAccent) : null,
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
      ],
    );
  }

  Widget _buildFontBox(String font, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.deepPurpleAccent.withOpacity(0.2) : Colors.transparent,
        border: Border.all(color: isSelected ? Colors.deepPurpleAccent : Colors.white24),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(font, style: TextStyle(fontFamily: font, color: isSelected ? Colors.deepPurpleAccent : Colors.white)),
    );
  }

  Widget _buildSpacingBox(IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.deepPurpleAccent.withOpacity(0.2) : Colors.transparent,
        border: Border.all(color: isSelected ? Colors.deepPurpleAccent : Colors.white24),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: isSelected ? Colors.deepPurpleAccent : Colors.white54),
    );
  }

  Widget _buildModeBtn(String label, IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: isSelected ? Colors.deepPurpleAccent.withOpacity(0.2) : Colors.transparent,
        border: Border.all(color: isSelected ? Colors.deepPurpleAccent : Colors.white24),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: isSelected ? Colors.deepPurpleAccent : Colors.white70),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: isSelected ? Colors.deepPurpleAccent : Colors.white70, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ==========================================
// TELA 5: CONFIGURAÇÕES
// ==========================================
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool animacao = true;
  bool mostrarControles = true;
  bool telaLigada = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Configurações', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            
            const Text('Leitura', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            GlassContainer(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Animação de virar página', style: TextStyle(fontSize: 14)),
                    value: animacao,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (val) => setState(() => animacao = val),
                  ),
                  Divider(color: Colors.white.withOpacity(0.05), height: 1),
                  SwitchListTile(
                    title: const Text('Tocar na tela para mostrar controles', style: TextStyle(fontSize: 14)),
                    value: mostrarControles,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (val) => setState(() => mostrarControles = val),
                  ),
                  Divider(color: Colors.white.withOpacity(0.05), height: 1),
                  SwitchListTile(
                    title: const Text('Manter tela sempre ligada', style: TextStyle(fontSize: 14)),
                    value: telaLigada,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (val) => setState(() => telaLigada = val),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            const Text('Aparência', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            GlassContainer(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Tema do aplicativo', style: TextStyle(fontSize: 14)),
                    trailing: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [Text('Escuro', style: TextStyle(color: Colors.white54)), Icon(Icons.chevron_right, color: Colors.white54)],
                    ),
                    onTap: () {},
                  ),
                  Divider(color: Colors.white.withOpacity(0.05), height: 1),
                  ListTile(
                    title: const Text('Cor de destaque', style: TextStyle(fontSize: 14)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 16, height: 16, decoration: const BoxDecoration(color: Colors.deepPurpleAccent, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right, color: Colors.white54)
                      ],
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            
            const Spacer(),
            Center(
              child: Text('Versão 1.0.0 (Offline)', style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12)),
            )
          ],
        ),
      ),
    );
  }
}
