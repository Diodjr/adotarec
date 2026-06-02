class Pet {
  const Pet({
    required this.name,
    required this.sex,
    required this.breed,
    required this.age,
    required this.neutered,
    required this.vaccinated,
    required this.location,
    required this.about,
    required this.imageUrls,
  });

  final String name;
  final String sex;
  final String breed;
  final String age;
  final String neutered;
  final String vaccinated;
  final String location;
  final String about;
  final List<String> imageUrls;

  factory Pet.fromJson(Map<String, dynamic> json) {
    final rawImages = json['imageUrls'] as List<dynamic>? ?? <dynamic>[];
    return Pet(
      name: json['name'] as String? ?? '',
      sex: json['sex'] as String? ?? '',
      breed: json['breed'] as String? ?? '',
      age: json['age'] as String? ?? '',
      neutered: json['neutered'] as String? ?? '',
      vaccinated: json['vaccinated'] as String? ?? '',
      location: json['location'] as String? ?? '',
      about: json['about'] as String? ?? '',
      imageUrls: rawImages.map((image) => image.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'sex': sex,
      'breed': breed,
      'age': age,
      'neutered': neutered,
      'vaccinated': vaccinated,
      'location': location,
      'about': about,
      'imageUrls': imageUrls,
    };
  }
}
