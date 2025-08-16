import 'package:flutter/material.dart';
import 'pages/login_page.dart';


void main() {
  runApp(const InventarioApp());
}


class InventarioApp extends StatelessWidget {
  const InventarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventario Olla Común',
      debugShowCheckedModeBanner: false, 
      

      theme: ThemeData(

        primarySwatch: Colors.green,
        primaryColor: Colors.green[600],
        

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green[600]!,
          brightness: Brightness.light,
        ),
        

        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green[600],
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[600],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        

        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
                  focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.green[600]!, width: 2),
        ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        

        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
        ),
        

        iconTheme: IconThemeData(
          color: Colors.green[600],
        ),
        

        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.grey[800],
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        

        scaffoldBackgroundColor: Colors.green[50],
        

        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      

      home: LoginPage(),
      

      routes: {
        '/login': (context) => LoginPage(),

      },
    );
  }
}
