from flask import Blueprint, request, jsonify
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity
from app.services.auth_service import AuthService
from app.services.user_service import UserService

auth_bp = Blueprint('auth', __name__, url_prefix='/api/v1/auth')


@auth_bp.route('/register', methods=['POST'])
def register():
    """Registra novo usuário"""
    data = request.get_json()
    
    if not data:
        return jsonify({'message': 'Dados inválidos'}), 400
    
    user, errors = AuthService.register(data)
    
    if errors:
        return jsonify({'message': 'Erro ao registrar', 'errors': errors}), 400
    
    return jsonify({'message': 'Usuário criado com sucesso'}), 201


@auth_bp.route('/login', methods=['POST'])
def login():
    """Realiza login do usuário"""
    data = request.get_json()
    
    if not data or not data.get('login') or not data.get('senha'):
        return jsonify({'message': 'Login e senha são obrigatórios'}), 400
    
    user, error = AuthService.login(data['login'], data['senha'])
    
    if error:
        return jsonify({'message': error}), 401
    
    access_token = create_access_token(identity=str(user.id))
    
    return jsonify({
        'access_token': access_token,
        'user': {
            'id': user.id,
            'nome': user.nome,
            'tipo': user.tipo
        }
    }), 200


@auth_bp.route('/me', methods=['GET'])
@jwt_required()
def get_profile():
    """Obtém perfil do usuário logado"""
    user_id = get_jwt_identity()
    user, error = UserService.get_profile(user_id)
    
    if error:
        return jsonify({'message': error}), 404
    
    return jsonify({
        'id': user.id,
        'nome': user.nome,
        'tipo': user.tipo,
        'email': user.email,
        'telefone': user.telefone
    }), 200
