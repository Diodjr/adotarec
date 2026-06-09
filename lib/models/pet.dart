class Pet {
  final int id;
  final String name;
  final String especie;
  final String breed;
  final String age;
  final String sex;
  final String size;
  final bool neutered;
  final bool vaccinated;
  final String location;
  final String about;
  final List<String> imageUrls;
  final String status;
  final String guardian;
  final String whatsappContato;

  const Pet({
    required this.id,
    required this.name,
    required this.especie,
    required this.breed,
    required this.age,
    required this.sex,
    required this.size,
    required this.neutered,
    required this.vaccinated,
    required this.location,
    required this.about,
    required this.imageUrls,
    this.status = 'ativo',
    this.guardian = 'ONG responsável',
    this.whatsappContato = '',
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    // Extrai URL de imagem, suportando tanto string única quanto lista
    List<String> getImageUrls() {
      final imagemUrl = json['imagem_url'];
      final imagensUrl = json['imagens_url'];
      
      if (imagensUrl is List) {
        return imagensUrl
            .cast<String>()
            .where((url) => url.isNotEmpty)
            .toList();
      } else if (imagemUrl is String && imagemUrl.isNotEmpty) {
        return [imagemUrl];
      }
      return ['https://via.placeholder.com/500x300'];
    }

    // Extrai nome do guardião/ONG
    String getGuardian() {
      // Tenta acessar owner.nome
      final owner = json['owner'];
      if (owner is Map && owner.containsKey('nome')) {
        return owner['nome'] ?? 'ONG responsável';
      }
      
      // Tenta acessar ong.nome
      final ong = json['ong'];
      if (ong is Map && ong.containsKey('nome')) {
        return ong['nome'] ?? 'ONG responsável';
      }
      
      return 'ONG responsável';
    }

    return Pet(
      id: json['id'] ?? 0,
      name: json['nome'] ?? 'Pet sem nome',
      especie: json['especie'] ?? '',
      breed: json['raca'] ?? '',
      age: json['idade'] ?? '',
      sex: json['sexo'] ?? '',
      size: json['porte'] ?? '',
      neutered: json['castrado'] ?? false,
      vaccinated: json['vacinado'] ?? false,
      location: json['localizacao'] ?? '',
      about: json['descricao'] ?? '',
      imageUrls: getImageUrls(),
      status: json['status'] ?? 'ativo',
      guardian: getGuardian(),
      whatsappContato: json['whatsapp_contato'] ?? '',
    );
  }

  // Método para debug
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': name,
      'especie': especie,
      'raca': breed,
      'idade': age,
      'sexo': sex,
      'porte': size,
      'castrado': neutered,
      'vacinado': vaccinated,
      'localizacao': location,
      'descricao': about,
      'imagem_url': imageUrls.isNotEmpty ? imageUrls.first : '',
      'status': status,
      'whatsapp_contato': whatsappContato,
    };
  }
}