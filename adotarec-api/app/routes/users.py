from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app.services.user_service import UserService
from app.services.pet_service import PetService

users_bp = Blueprint('users', __name__, url_prefix='/api/v1/users')


@users_bp.route('/me', methods=['PUT'])
@jwt_required()
def update_profile():
    """Atualiza perfil do usuário logado"""
    user_id = get_jwt_identity()
    data = request.get_json()
    
    if not data:
        return jsonify({'message': 'Dados inválidos'}), 400
    
    user, error = UserService.update_profile(user_id, data)
    
    if error:
        return jsonify({'message': error}), 404
    
    return jsonify({
        'message': 'Perfil atualizado',
        'user': user.to_dict()
    }), 200


@users_bp.route('/me', methods=['DELETE'])
@jwt_required()
def deactivate_account():
    """Desativa conta do usuário"""
    user_id = get_jwt_identity()
    
    user, error = UserService.deactivate_account(user_id)
    
    if error:
        return jsonify({'message': error}), 404
    
    return jsonify({'message': 'Conta desativada'}), 200


@users_bp.route('/me/pets', methods=['GET'])
@jwt_required()
def list_user_pets():
    """Lista pets do usuário logado (apenas ONG)"""
    user_id = get_jwt_identity()
    
    pets, error = PetService.list_user_pets(user_id)
    
    if error:
        return jsonify({'message': error}), 403
    
    return jsonify([pet.to_dict() for pet in pets]), 200
