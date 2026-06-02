import '../models/pet.dart';

class ApiService {
  static Future<List<Pet>> getPets() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return List<Pet>.unmodifiable(_pets);
  }

  static Future<void> addPet(Pet pet) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    _pets.insert(0, pet);
  }

  static final List<Pet> _pets = <Pet>[
    const Pet(
      name: 'Oreo',
      sex: 'Macho',
      size: 'Porte médio',
      breed: 'SRD (vira-lata)',
      age: '2 anos',
      neutered: 'Sim',
      guardian: 'ONG Patinhas do Recife',
      vaccinated: 'Sim (V10 e antirrábica)',
      location: 'Recife - PE',
      about:
          'O Oreo é dócil, brincalhão e se adapta bem a famílias com crianças. '
          'Ele já está acostumado a passeios com guia e convive bem com outros cães.',
      imageUrls: <String>[
        'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1517849845537-4d257902454a?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=1200&q=80',
      ],
    ),
    const Pet(
      name: 'Luna',
      sex: 'Fêmea',
      size: 'Porte pequeno',
      breed: 'Poodle',
      age: '1 ano e 4 meses',
      neutered: 'Sim',
      guardian: 'Abrigo Lar Animal',
      vaccinated: 'Sim',
      location: 'Jaboatão dos Guararapes - PE',
      about:
          'A Luna é carinhosa e cheia de energia. Ideal para quem gosta de passeios '
          'diários e brincadeiras dentro de casa.',
      imageUrls: <String>[
        'https://images.unsplash.com/photo-1596492784531-6e6eb5ea9993?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1537151625747-768eb6cf92b2?auto=format&fit=crop&w=1200&q=80',
      ],
    ),
    const Pet(
      name: 'Mingau',
      sex: 'Macho',
      size: 'Porte pequeno',
      breed: 'Gato SRD',
      age: '8 meses',
      neutered: 'Não',
      guardian: 'Projeto Adota Gato',
      vaccinated: 'Primeira dose aplicada',
      location: 'Olinda - PE',
      about:
          'Mingau é tranquilo e curioso. Está em fase de socialização e procura um lar '
          'com muito carinho e paciência.',
      imageUrls: <String>[
        'https://images.unsplash.com/photo-1519052537078-e6302a4968d4?auto=format&fit=crop&w=1200&q=80',
      ],
    ),
  ];
}

