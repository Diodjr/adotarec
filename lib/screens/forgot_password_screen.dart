import 'package:flutter/material.dart';
import 'package:adotarec/widgets/app_menu_drawer.dart';

import '../widgets/custom_app_bar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool _isSending = false;
  bool _emailSent = false;
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendLink() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Informe o e-mail cadastrado.',
            style: TextStyle(fontFamily: 'Nunito'),
          ),
        ),
      );
      return;
    }

    setState(() => _isSending = true);
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _isSending = false;
      _emailSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const AppMenuDrawer(),
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Esqueci minha senha',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF003366),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _emailSent
                    ? 'Enviamos um link de recuperação para o e-mail informado. '
                        'Verifique sua caixa de entrada e o spam.'
                    : 'Informe o e-mail da sua conta. Enviaremos um link para '
                        'você criar uma nova senha.',
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 15,
                  height: 1.45,
                  color: Color(0xFF5F6C7B),
                ),
              ),
              if (!_emailSent) ...[
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isSending ? null : _handleSendLink,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006DA6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: _isSending
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Enviar link de recuperação'),
                ),
              ],
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  _emailSent ? 'Voltar ao login' : 'Lembrou a senha? Entrar',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
