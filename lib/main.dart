import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AfghanGhazaliApp());
}

class AfghanGhazaliApp extends StatelessWidget {
  const AfghanGhazaliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'افغان غزالي کلنډر',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF145A42),
          primary: const Color(0xFF145A42),
          secondary: const Color(0xFFD4AF37),
          surface: const Color(0xFFF8FAF7),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAF7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF145A42),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      supportedLocales: const [
        Locale('ps'),
        Locale('fa'),
        Locale('en'),
      ],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      locale: const Locale('ps'),
      home: const HomeScreen(),
    );
  }
}
