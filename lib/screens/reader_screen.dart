import 'package:flutter/material.dart';
import '../widgets/appearance_bottom_sheet.dart';

class ReaderScreen extends StatelessWidget {
  final bool isFromNav;
  const ReaderScreen({super.key, required this.isFromNav});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4EAD5), // Cor de papel sepia
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        leading: isFromNav ? null : IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          children: [
            Text('O Hobbit', style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
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
                  'Em um buraco no chão vivia um hobbit. Não era um buraco nojento, sujo e úmido, cheio de pontas de minhoca e um cheiro de lodo, nem também seco, vazio e arenoso, sem nada para sentar ou para comer: era um buraco hobbit, e isso significa conforto.\n\nTinha uma porta perfeitamente redonda como uma vigia de navio, pintada de verde e com uma maçaneta brilhante bem no meio. A porta se abria para um túnel em forma de tubo como um corredor...',
                  style: TextStyle(color: Colors.black87, fontSize: 18, fontFamily: 'Lora', height: 1.6),
                ),
                SizedBox(height: 100), // Espaço pro bottom bar
              ],
            ),
          ),
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
          const Row(
            children: [
              Text('Página 24 de 310', style: TextStyle(color: Colors.white54, fontSize: 12)),
              Spacer(),
              Text('7%', style: TextStyle(color: Colors.white54, fontSize: 12)),
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
