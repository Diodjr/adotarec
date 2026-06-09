import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import 'http_helper.dart';

class AuthService {
  /// Registra novo usuário
  Future<Map<String, dynamic>> register({
    required String tipo,
    required String nome,
    required String email,
    required String telefone,
    String? cpf,
    String? cnpj,
    required String senha,
  }) async {
    try {
      final body = <String, dynamic>{
        'tipo': tipo,
        'nome': nome,
        'email': email,
        'telefone': telefone,
        'senha': senha,
      };

      if (tipo == 'ONG') {
        final cnpjDigits = _onlyDigits(cnpj);
        if (cnpjDigits.isEmpty) {
          throw HttpException('CNPJ é obrigatório para registro de ONG');
        }
        body['cnpj'] = cnpjDigits;
      } else if (tipo == 'PROTETOR') {
        final cpfDigits = _onlyDigits(cpf);
        if (cpfDigits.isEmpty) {
          throw HttpException('CPF é obrigatório para registro de Protetor');
        }
        body['cpf'] = cpfDigits;
      }

      final response = await HttpHelper.post(
        '${ApiConfig.baseUrl}/auth/register',
        body: body,
      );

      print('✅ Registro bem-sucedido');
      return response;
    } catch (e) {
      print('❌ Erro ao registrar: $e');
      rethrow;
    }
  }

  /// Faz login e salva token
  Future<bool> login({
    required String login,
    required String senha,
  }) async {
    try {
      final response = await HttpHelper.post(
        '${ApiConfig.baseUrl}/auth/login',
        body: {
          'login': login,
          'senha': senha,
        },
      );

      final accessToken = response['access_token'];
      if (accessToken == null) {
        throw HttpException('Token não recebido da API');
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', accessToken);
      await prefs.setBool('isLoggedIn', true);

      // Salva informações do usuário se disponível
      if (response['user'] != null) {
        await prefs.setString(
          'user_id',
          response['user']['id']?.toString() ?? '',
        );
        await prefs.setString(
          'user_tipo',
          response['user']['tipo'] ?? '',
        );
        await prefs.setString(
          'user_nome',
          response['user']['nome'] ?? '',
        );
      }

      print('✅ Login bem-sucedido');
      return true;
    } on HttpException catch (e) {
      print('❌ Erro de autenticação: $e');
      return false;
    } catch (e) {
      print('❌ Erro ao fazer login: $e');
      return false;
    }
  }

  /// Obter perfil do usuário logado
  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final token = await getToken();
      if (token == null) {
        return null;
      }

      final response = await HttpHelper.get(
        '${ApiConfig.baseUrl}/auth/me',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('✅ Perfil carregado');
      return response;
    } catch (e) {
      print('❌ Erro ao carregar perfil: $e');
      return null;
    }
  }

  /// Obtém tipo do usuário logado (ONG ou PROTETOR)
  Future<String?> getUserTipo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_tipo');
  }

  /// Obtém token salvo
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Verifica se está logado
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Faz logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('✅ Logout realizado');
  }

  static String _onlyDigits(String? value) {
    if (value == null) {
      return '';
    }
    return value.replaceAll(RegExp(r'\D'), '');
  }
}