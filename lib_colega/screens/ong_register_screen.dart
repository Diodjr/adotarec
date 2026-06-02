import 'package:flutter/material.dart';
import 'package:adotarec/widgets/app_menu_drawer.dart';

import 'add_pet_screen.dart';
import '../widgets/custom_app_bar.dart';

class OngRegisterScreen extends StatefulWidget {
  const OngRegisterScreen({super.key});

  @override
  State<OngRegisterScreen> createState() => _OngRegisterScreenState();
}

class _OngRegisterScreenState extends State<OngRegisterScreen> {
  bool _isSaving = false;

  Future<void> _handleSubmit() async {
    setState(() {
      _isSaving = true;
    });

    await Future<void>.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _isSaving = false);
    await _showPostRegisterOptions();
  }

  Future<void> _showPostRegisterOptions() async {
    final addPet = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Cadastro concluído!',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF003366),
            ),
          ),
          content: const Text(
            'Sua ONG foi cadastrada com sucesso. Deseja adicionar um pet '
            'para adoção agora?',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 15,
              height: 1.45,
              color: Color(0xFF5F6C7B),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Depois',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF006DA6),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF751F),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: const Text('Adicionar pet'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;
    Navigator.popUntil(context, (route) => route.isFirst);

    if (addPet == true && mounted) {
      await Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (_) => const AddPetScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const AppMenuDrawer(),
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Dados da ONG',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF003366),
                ),
              ),
              const SizedBox(height: 20),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Nome da ONG',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.corporate_fare),
                ),
              ),
              const SizedBox(height: 12),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'CNPJ',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
              ),
              const SizedBox(height: 12),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Telefone / WhatsApp',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 12),
              const TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirmar senha',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSaving ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF751F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.4,
                        ),
                      )
                    : const Text('Concluir Cadastro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

