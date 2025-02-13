import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/logo_widget.dart'; // Importa el nuevo widget

class VerifyTokenScreen extends StatefulWidget {
  const VerifyTokenScreen({super.key});

  @override
  _VerifyTokenScreenState createState() => _VerifyTokenScreenState();
}

class _VerifyTokenScreenState extends State<VerifyTokenScreen> {
  final TextEditingController tokenController = TextEditingController();
  bool isLoading = false;
  String message = '';
  String error = '';

  Future<void> _verifyToken() async {
    if (tokenController.text.isEmpty) {
      setState(() {
        error = 'Por favor ingrese el código de restablecimiento';
      });
      return;
    }

    setState(() {
      isLoading = true;
      message = '';
      error = '';
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.verifyToken(tokenController.text);
      setState(() {
        message = 'Código de restablecimiento válido. Ahora puedes cambiar tu contraseña.';
      });
      Navigator.pushReplacementNamed(
        context,
        '/resetPassword',
        arguments: {'token': tokenController.text},
      );
    } catch (err) {
      setState(() {
        error = err.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D4F02), Color(0xFF002401)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LogoWidget(), // Usa el nuevo widget aquí
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Verificar Código de Restablecimiento',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: tokenController,
                        decoration: const InputDecoration(
                          labelText: 'Código de Restablecimiento',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (message.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(message, style: const TextStyle(color: Colors.green)),
                        ),
                      if (error.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(error, style: const TextStyle(color: Colors.red)),
                        ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D4F02),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                        ),
                        onPressed: isLoading ? null : _verifyToken,
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Verificar Código', style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                        child: const Text('Volver al inicio de sesión', style: TextStyle(color: Color.fromARGB(255, 44, 103, 43))),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    tokenController.dispose();
    super.dispose();
  }
}