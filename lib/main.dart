import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';

// Tus pantallas
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/recovery_screen.dart';
import 'screens/reset_password_screen.dart';
import 'screens/admin_panel.dart';
import 'screens/report_screen.dart';
import 'screens/notario_table.dart';
import 'screens/public_screen.dart';
import 'screens/voting_screen.dart';
import 'screens/verify_token_screen.dart';
import 'screens/gala_screen.dart'; // Asegúrate de crear esta pantalla
import 'screens/super_admin_panel_screen.dart'; // <--- AÑADIR ESTO
import 'screens/notario_panel.dart'; // Nueva ruta
import 'screens/base_screen.dart';
import 'screens/carousel_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', ''), // Español
        Locale('en', ''), // Inglés
      ],
      locale: const Locale('es', ''), // Forzar español como idioma predeterminado
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/recovery': (context) => const RecoveryScreen(),
        '/admin': (context) => const AdminPanelScreen(),
        '/report': (context) => const ReportScreen(),
        '/TablaNotario': (context) => const NotarioTableScreen(),
        '/CRG_Publica': (context) => const PublicScreen(),
        '/voting': (context) => const VotingScreen(),
        '/verifyToken': (context) => const VerifyTokenScreen(),
        '/CRG_Gala': (context) => const GalaScreen(),
        '/superadmin': (context) => const SuperAdminPanelScreen(), // <--- AÑADIR ESTO
        '/notario': (context) => const NotarioPanelScreen(), // Nueva ruta
        '/base': (context) => const BaseScreen(),
        '/carousel': (context) => const CarouselScreen(),
        // No defines '/resetPassword' aquí
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/resetPassword') {
          final args = settings.arguments as Map<String, dynamic>;
          final token = args['token'] as String;
          return MaterialPageRoute(
            builder: (context) {
              return ResetPasswordScreen(token);
            },
          );
        }
        // Puedes agregar más rutas con argumentos aquí si es necesario
        return null; // Retorna null para rutas no definidas
      },
    );
  }
}
