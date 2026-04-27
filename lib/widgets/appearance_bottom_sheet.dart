import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import 'glass_container.dart';

class AppearanceBottomSheet extends StatelessWidget {
  const AppearanceBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

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
              _buildThemeCircle(context, Colors.white, 'Claro', 'claro', settings),
              _buildThemeCircle(context, const Color(0xFF2D2D3A), 'Escuro', 'escuro', settings),
              _buildThemeCircle(context, const Color(0xFFF4EAD5), 'Sepia', 'sepia', settings),
              _buildThemeCircle(context, Colors.black, 'Amoled', 'amoled', settings),
            ],
          ),
          const SizedBox(height: 24),
          
          const Text('Fonte', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFontBox(context, 'Lora', settings),
              _buildFontBox(context, 'Merriweather', settings),
              _buildFontBox(context, 'Inter', settings),
            ],
          ),
          const SizedBox(height: 24),
          
          const Text('Tamanho da fonte', style: TextStyle(color: Colors.white70)),
          Row(
            children: [
              const Text('A-', style: TextStyle(fontSize: 16)),
              Expanded(
                child: Slider(
                  value: settings.fontSize,
                  min: 12,
                  max: 32,
                  activeColor: Theme.of(context).colorScheme.primary,
                  inactiveColor: Colors.white24,
                  onChanged: (val) => settings.setFontSize(val),
                ),
              ),
              const Text('A+', style: TextStyle(fontSize: 20)),
            ],
          ),
          const SizedBox(height: 24),
          
          const Text('Modo de leitura', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          Row(
            children: [
              // MÁGICA: Conectamos os botões na função nova do provider!
              Expanded(child: _buildModeBtn('Página', Icons.menu_book, true, settings)),
              const SizedBox(width: 16),
              Expanded(child: _buildModeBtn('Rolagem', Icons.swap_vert, false, settings)),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildThemeCircle(BuildContext context, Color color, String label, String themeValue, SettingsProvider settings) {
    bool isSelected = settings.readerTheme == themeValue;
    return GestureDetector(
      onTap: () => settings.setTheme(themeValue),
      child: Column(
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
      ),
    );
  }

  Widget _buildFontBox(BuildContext context, String font, SettingsProvider settings) {
    bool isSelected = settings.fontFamily == font;
    return GestureDetector(
      onTap: () => settings.setFont(font),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurpleAccent.withOpacity(0.2) : Colors.transparent,
          border: Border.all(color: isSelected ? Colors.deepPurpleAccent : Colors.white24),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(font, style: TextStyle(fontFamily: font, color: isSelected ? Colors.deepPurpleAccent : Colors.white)),
      ),
    );
  }

  Widget _buildModeBtn(String label, IconData icon, bool isPageBtn, SettingsProvider settings) {
    bool isSelected = settings.isPageMode == isPageBtn;
    return GestureDetector(
      onTap: () => settings.setPageMode(isPageBtn),
      child: Container(
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
      ),
    );
  }
}
