import '../config/api_config.dart';
import '../models/pet.dart';
import 'http_helper.dart';

class ApiService {
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
}