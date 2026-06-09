import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import '../models/pet.dart';
import 'http_helper.dart';

class PetService {
  /// Obtém token do armazenamento
  Future<String?> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Cria novo pet (apenas ONG)
  Future<void> createPet({
    required String nome,
    required String especie,
    required String raca,
    required String idade,
    required String sexo,
    required String porte,
    required bool castrado,
    required bool vacinado,
    required String localizacao,
    required String descricao,
    required String imagemUrl,
    required String whatsapp,
  }) async {
    try {
      final token = await _token();
      if (token == null) {
        throw HttpException('Token não encontrado. Faça login novamente.');
      }

      await HttpHelper.post(
        '${ApiConfig.baseUrl}/pets',
        body: {
          'nome': nome,
          'especie': especie,
          'raca': raca,
          'idade': idade,
          'sexo': sexo,
          'porte': porte,
          'castrado': castrado,
          'vacinado': vacinado,
          'localizacao': localizacao,
          'descricao': descricao,
          'imagem_url': imagemUrl,
          'whatsapp_contato': whatsapp,
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('✅ Pet cadastrado com sucesso');
    } catch (e) {
      print('❌ Erro ao cadastrar pet: $e');
      rethrow;
    }
  }

  /// Lista todos os pets disponíveis
  Future<List<Pet>> getPets({
    String? sexo,
    String? porte,
    String? especie,
  }) async {
    try {
      String url = '${ApiConfig.baseUrl}/pets';
      
      // Adiciona filtros se fornecidos
      final queryParams = <String>[];
      if (sexo != null && sexo.isNotEmpty) queryParams.add('sexo=$sexo');
      if (porte != null && porte.isNotEmpty) queryParams.add('porte=$porte');
      if (especie != null && especie.isNotEmpty) queryParams.add('especie=$especie');
      
      if (queryParams.isNotEmpty) {
        url = '$url?${queryParams.join('&')}';
      }

      final response = await HttpHelper.get(url);

      // Trata resposta como lista
      final List<dynamic> jsonList;
      if (response is List) {
        jsonList = response;
      } else if (response is Map && response.containsKey('pets')) {
        jsonList = response['pets'] ?? [];
      } else {
        throw Exception('Formato de resposta inesperado');
      }

      print('✅ Carregados ${jsonList.length} pets');
      return jsonList.map((e) => Pet.fromJson(e)).toList();
    } catch (e) {
      print('❌ Erro ao buscar pets: $e');
      rethrow;
    }
  }

  /// Obtém detalhes de um pet específico
  Future<Pet> getPet(int id) async {
    try {
      final response = await HttpHelper.get(
        '${ApiConfig.baseUrl}/pets/$id',
      );

      print('✅ Pet $id carregado');
      return Pet.fromJson(response);
    } catch (e) {
      print('❌ Erro ao buscar pet $id: $e');
      rethrow;
    }
  }

  /// Lista pets do usuário logado (ONG)
  Future<List<Pet>> getMyPets() async {
    try {
      final token = await _token();
      if (token == null) {
        throw HttpException('Token não encontrado. Faça login novamente.');
      }

      final response = await HttpHelper.get(
        '${ApiConfig.baseUrl}/users/me/pets',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      // Trata resposta como lista
      final List<dynamic> jsonList;
      if (response is List) {
        jsonList = response;
      } else if (response is Map && response.containsKey('pets')) {
        jsonList = response['pets'] ?? [];
      } else {
        throw Exception('Formato de resposta inesperado');
      }

      print('✅ Carregados ${jsonList.length} pets próprios');
      return jsonList.map((e) => Pet.fromJson(e)).toList();
    } catch (e) {
      print('❌ Erro ao buscar meus pets: $e');
      rethrow;
    }
  }

  /// Atualiza informações de um pet
  Future<void> updatePet(
    int id, {
    required String nome,
    required String especie,
    required String raca,
    required String idade,
    required String sexo,
    required String porte,
    required bool castrado,
    required bool vacinado,
    required String localizacao,
    required String descricao,
    required String imagemUrl,
    required String whatsapp,
  }) async {
    try {
      final token = await _token();
      if (token == null) {
        throw HttpException('Token não encontrado. Faça login novamente.');
      }

      await HttpHelper.put(
        '${ApiConfig.baseUrl}/pets/$id',
        body: {
          'nome': nome,
          'especie': especie,
          'raca': raca,
          'idade': idade,
          'sexo': sexo,
          'porte': porte,
          'castrado': castrado,
          'vacinado': vacinado,
          'localizacao': localizacao,
          'descricao': descricao,
          'imagem_url': imagemUrl,
          'whatsapp_contato': whatsapp,
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('✅ Pet $id atualizado');
    } catch (e) {
      print('❌ Erro ao atualizar pet $id: $e');
      rethrow;
    }
  }

  /// Deleta um pet
  Future<void> deletePet(int id) async {
    try {
      final token = await _token();
      if (token == null) {
        throw HttpException('Token não encontrado. Faça login novamente.');
      }

      await HttpHelper.delete(
        '${ApiConfig.baseUrl}/pets/$id',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('✅ Pet $id deletado');
    } catch (e) {
      print('❌ Erro ao deletar pet $id: $e');
      rethrow;
    }
  }

  /// Altera status de um pet
  Future<void> updatePetStatus(int id, String status) async {
    try {
      final token = await _token();
      if (token == null) {
        throw HttpException('Token não encontrado. Faça login novamente.');
      }

      await HttpHelper.patch(
        '${ApiConfig.baseUrl}/pets/$id/status',
        body: {
          'status': status,
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('✅ Status do pet $id atualizado para $status');
    } catch (e) {
      print('❌ Erro ao atualizar status do pet $id: $e');
      rethrow;
    }
  }
}