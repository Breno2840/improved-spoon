import 'package:flutter/material.dart';
import 'glass_container.dart';

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
