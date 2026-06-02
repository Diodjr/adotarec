import 'package:flutter/material.dart';
import 'package:adotarec/widgets/app_menu_drawer.dart';

import '../models/pet.dart';
import '../services/api_service.dart';
import '../widgets/custom_app_bar.dart';

class PetListScreen extends StatefulWidget {
  const PetListScreen({super.key});

  @override
  State<PetListScreen> createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  late final Future<List<Pet>> _petsFuture;

  @override
  void initState() {
    super.initState();
    _petsFuture = ApiService.getPets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: const AppMenuDrawer(),
      appBar: const CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'PETS DISPONÍVEIS PARA ADOÇÃO',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003366),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Pet>>(
              future: _petsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Não foi possível carregar os pets.',
                      style: TextStyle(fontFamily: 'Nunito'),
                    ),
                  );
                }

                final pets = snapshot.data ?? <Pet>[];
                if (pets.isEmpty) {
                  return const Center(
                    child: Text(
                      'Nenhum pet disponível no momento.',
                      style: TextStyle(fontFamily: 'Nunito'),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: pets.length,
                  itemBuilder: (context, index) {
                    final pet = pets[index];
                    return Card(
                      color: Colors.white,
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                pet.imageUrls.first,
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => _showPetDetailsDialog(pet),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF006DA6),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                textStyle: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              child: Text('Conheça o ${pet.name}'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showPetDetailsDialog(Pet pet) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            width: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: PageView.builder(
                      itemCount: pet.imageUrls.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          pet.imageUrls[index],
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  color: const Color(0xFF006DA6),
                  child: Text(
                    pet.name,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _detailLine('Sexo:', pet.sex),
                        _detailLine('Porte:', pet.size),
                        _detailLine('Raça:', pet.breed),
                        _detailLine('Idade:', pet.age),
                        _detailLine('Castrado:', pet.neutered),
                        _detailLine('Responsável:', pet.guardian),
                        _detailLine('Vacinado:', pet.vaccinated),
                        _detailLine('Localização:', pet.location),
                        const SizedBox(height: 14),
                        const Text(
                          'Sobre o pet',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF003366),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          pet.about,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 15,
                            height: 1.45,
                            color: Color(0xFF5F6C7B),
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF751F),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              textStyle: const TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            child: const Text('Quero adotar!'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label ',
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF7C9BB4),
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 15,
                color: Color(0xFF2F3945),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
