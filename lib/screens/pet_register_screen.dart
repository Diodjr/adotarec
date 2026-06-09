import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/http_helper.dart';
import '../services/pet_service.dart';

class PetRegisterScreen extends StatefulWidget {
  const PetRegisterScreen({super.key});

  @override
  State<PetRegisterScreen> createState() => _PetRegisterScreenState();
}

class _PetRegisterScreenState extends State<PetRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _petService = PetService();
  final _authService = AuthService();

  final _nomeController = TextEditingController();
  final _racaController = TextEditingController();
  final _idadeController = TextEditingController();
  final _localizacaoController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _imagemUrlController = TextEditingController();
  final _whatsappController = TextEditingController();

  String _especie = 'CACHORRO';
  String _sexo = 'MACHO';
  String _porte = 'MEDIO';
  bool _castrado = false;
  bool _vacinado = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _racaController.dispose();
    _idadeController.dispose();
    _localizacaoController.dispose();
    _descricaoController.dispose();
    _imagemUrlController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final isLoggedIn = await _authService.isLoggedIn();
    if (!isLoggedIn) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Faça login como ONG para cadastrar um pet.'),
        ),
      );
      return;
    }

    final tipo = await _authService.getUserTipo();
    if (tipo != 'ONG') {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Apenas ONGs podem cadastrar pets.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _petService.createPet(
        nome: _nomeController.text.trim(),
        especie: _especie,
        raca: _racaController.text.trim(),
        idade: _idadeController.text.trim(),
        sexo: _sexo,
        porte: _porte,
        castrado: _castrado,
        vacinado: _vacinado,
        localizacao: _localizacaoController.text.trim(),
        descricao: _descricaoController.text.trim(),
        imagemUrl: _imagemUrlController.text.trim(),
        whatsapp: _whatsappController.text.replaceAll(RegExp(r'\D'), ''),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pet cadastrado com sucesso!'),
        ),
      );

      Navigator.pop(context);
    } on HttpException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar pet: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Pet'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do pet',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nome é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _especie,
                decoration: const InputDecoration(
                  labelText: 'Espécie',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'CACHORRO', child: Text('Cachorro')),
                  DropdownMenuItem(value: 'GATO', child: Text('Gato')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _especie = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _racaController,
                decoration: const InputDecoration(
                  labelText: 'Raça',
                  border: OutlineInputBorder(),
                  hintText: 'SRD',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _idadeController,
                decoration: const InputDecoration(
                  labelText: 'Idade',
                  border: OutlineInputBorder(),
                  hintText: '2 anos',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _sexo,
                decoration: const InputDecoration(
                  labelText: 'Sexo',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'MACHO', child: Text('Macho')),
                  DropdownMenuItem(value: 'FEMEA', child: Text('Fêmea')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _sexo = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _porte,
                decoration: const InputDecoration(
                  labelText: 'Porte',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'PEQUENO', child: Text('Pequeno')),
                  DropdownMenuItem(value: 'MEDIO', child: Text('Médio')),
                  DropdownMenuItem(value: 'GRANDE', child: Text('Grande')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _porte = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Castrado'),
                value: _castrado,
                onChanged: (value) => setState(() => _castrado = value),
              ),
              SwitchListTile(
                title: const Text('Vacinado'),
                value: _vacinado,
                onChanged: (value) => setState(() => _vacinado = value),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _localizacaoController,
                decoration: const InputDecoration(
                  labelText: 'Localização',
                  border: OutlineInputBorder(),
                  hintText: 'Recife - PE',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imagemUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL da imagem',
                  border: OutlineInputBorder(),
                  hintText: 'https://example.com/pet.jpg',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _whatsappController,
                decoration: const InputDecoration(
                  labelText: 'WhatsApp de contato',
                  border: OutlineInputBorder(),
                  hintText: '5581999999999',
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  final digits = value?.replaceAll(RegExp(r'\D'), '') ?? '';
                  if (digits.isEmpty) {
                    return 'WhatsApp é obrigatório';
                  }
                  if (digits.length < 10) {
                    return 'Informe o número com código do país';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _cadastrar,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Cadastrar Pet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
