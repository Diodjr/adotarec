import 'package:flutter/material.dart';

import '../models/pet.dart';
import '../services/pet_service.dart';

class MyPetsScreen extends StatefulWidget {

  const MyPetsScreen({
    super.key,
  });

  @override
  State<MyPetsScreen> createState() =>
      _MyPetsScreenState();
}

class _MyPetsScreenState
    extends State<MyPetsScreen> {

  final PetService _service =
      PetService();

  late Future<List<Pet>> _future;

  @override
  void initState() {
    super.initState();

    _future =
        _service.getMyPets();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Meus Pets'),
      ),
      body: FutureBuilder<List<Pet>>(
        future: _future,
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final pets =
              snapshot.data!;

          return ListView.builder(
            itemCount: pets.length,
            itemBuilder: (_, index) {

              final pet =
                  pets[index];

              return ListTile(
                title:
                    Text(pet.name),
                subtitle:
                    Text(pet.status),
              );
            },
          );
        },
      ),
    );
  }
}