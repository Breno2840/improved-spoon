import 'package:flutter/material.dart';
import '../widgets/glass_container.dart';

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
