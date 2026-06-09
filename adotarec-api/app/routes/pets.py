from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app.services.pet_service import PetService
from app.repositories.user_repository import UserRepository

pets_bp = Blueprint('pets', __name__, url_prefix='/api/v1/pets')


@pets_bp.route('', methods=['GET'])
def list_pets():
    """Lista pets disponíveis com filtros opcionais"""
    filters = {}
    
    if request.args.get('sexo'):
        filters['sexo'] = request.args.get('sexo').upper()
    if request.args.get('porte'):
        filters['porte'] = request.args.get('porte').upper()
    if request.args.get('especie'):
        filters['especie'] = request.args.get('especie').upper()
    if request.args.get('status'):
        filters['status'] = request.args.get('status').upper()
    
    pets = PetService.list_available(filters if filters else None)
    
    return jsonify([pet.to_dict() for pet in pets]), 200


@pets_bp.route('/<int:pet_id>', methods=['GET'])
def get_pet(pet_id):
    """Obtém detalhes de um pet"""
    pet, error = PetService.get_pet(pet_id)
    
    if error:
        return jsonify({'message': error}), 404
    
    return jsonify(pet.to_dict(include_owner=True)), 200


@pets_bp.route('', methods=['POST'])
@jwt_required()
def create_pet():
    """Cria novo pet (apenas ONG)"""
    user_id = get_jwt_identity()
    user = UserRepository.find_by_id(user_id)
    
    if not user or user.tipo != 'ONG':
        return jsonify({'message': 'Apenas ONGs podem cadastrar pets'}), 403
    
    data = request.get_json()
    
    if not data:
        return jsonify({'message': 'Dados inválidos'}), 400
    
    pet, error = PetService.create_pet(user_id, data)
    
    if error:
        return jsonify({'message': error}), 400
    
    return jsonify({
        'message': 'Pet criado com sucesso',
        'pet': pet.to_dict()
    }), 201


@pets_bp.route('/<int:pet_id>', methods=['PUT'])
@jwt_required()
def update_pet(pet_id):
    """Atualiza dados do pet (apenas dono)"""
    user_id = get_jwt_identity()
    data = request.get_json()
    
    if not data:
        return jsonify({'message': 'Dados inválidos'}), 400
    
    pet, error = PetService.update_pet(user_id, pet_id, data)
    
    if error:
        return jsonify({'message': error}), 403 if 'permissão' in error else 404
    
    return jsonify({
        'message': 'Pet atualizado',
        'pet': pet.to_dict()
    }), 200


@pets_bp.route('/<int:pet_id>', methods=['DELETE'])
@jwt_required()
def delete_pet(pet_id):
    """Deleta um pet (apenas dono)"""
    user_id = get_jwt_identity()
    
    success, error = PetService.delete_pet(user_id, pet_id)
    
    if error:
        return jsonify({'message': error}), 403 if 'permissão' in error else 404
    
    return jsonify({'message': 'Pet deletado'}), 200


@pets_bp.route('/<int:pet_id>/status', methods=['PATCH'])
@jwt_required()
def update_pet_status(pet_id):
    """Altera status do pet (apenas dono)"""
    user_id = get_jwt_identity()
    data = request.get_json()
    
    if not data or not data.get('status'):
        return jsonify({'message': 'Status é obrigatório'}), 400
    
    pet, error = PetService.update_status(user_id, pet_id, data['status'])
    
    if error:
        return jsonify({'message': error}), 403 if 'permissão' in error else 400
    
    return jsonify({
        'message': 'Status atualizado',
        'pet': pet.to_dict()
    }), 200
