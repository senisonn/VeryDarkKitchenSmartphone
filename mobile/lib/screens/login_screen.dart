import 'package:flutter/material.dart';
import '../services/mock_api_service.dart';
import '../services/debug_service.dart';
import '../models/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiService = MockApiService();
  bool _isLoading = false;
  bool _debugEnabled = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    DebugService.isDebugEnabled().then((v) {
      if (mounted) setState(() => _debugEnabled = v);
    });
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final request = LoginRequest(
        username: _usernameController.text,
        password: _passwordController.text,
      );

      await _apiService.login(request);

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/menu');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.restaurant,
                size: 80,
                color: Colors.deepOrange,
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Nom d\'utilisateur',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom d\'utilisateur';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Se connecter',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Mode debug - voir pages authentifiées'),
                value: _debugEnabled,
                onChanged: (v) async {
                  await DebugService.setDebugEnabled(v);
                  if (mounted) setState(() => _debugEnabled = v);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mode debug ${v ? 'activé' : 'désactivé'}')),
                  );
                  // If enabling debug, navigate to menu so developer can inspect auth pages.
                  if (v) {
                    if (mounted) Navigator.pushReplacementNamed(context, '/menu');
                  }
                },
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: const Text('Pas de compte? Inscrivez-vous'),
              ),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/menu'),
                child: const Text('Continuer sans connexion'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
