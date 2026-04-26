import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/main_navigator.dart';
import 'providers/book_provider.dart';
import 'providers/settings_provider.dart'; // NOVO IMPORT

void main() {
  runApp(
    // Agora usamos MultiProvider para ter vários "cérebros" no app
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BookProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
      ],
      child: const EbookReaderApp(),
    ),
  );
}

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
          primary: const Color(0xFF9D7BFF), 
          surface: const Color(0xFF16161E),
          background: const Color(0xFF0D0D12),
        ),
        scaffoldBackgroundColor: Colors.transparent, 
        fontFamily: 'Inter', 
      ),
      home: const MainNavigator(),
    );
  }
}
