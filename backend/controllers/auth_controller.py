from flask import Blueprint, jsonify, request
from flask_jwt_extended import create_access_token
from werkzeug.security import check_password_hash, generate_password_hash

from extensions import db
from models import Usuario

auth_bp = Blueprint('auth', __name__)


@auth_bp.route('/registro', methods=['POST'])
def registro():
    data = request.get_json(silent=True) or {}

    nome = (data.get('nome') or '').strip()
    email = (data.get('email') or '').strip().lower()
    senha = data.get('senha') or ''
    tipo = (data.get('tipo') or '').strip().lower()
    cnpj = (data.get('cnpj') or '').strip() or None

    if not nome or not email or not senha or not tipo:
        return jsonify({'erro': 'nome, email, senha e tipo são obrigatórios'}), 400

    if tipo not in ('protetor', 'ong'):
        return jsonify({'erro': "tipo deve ser 'protetor' ou 'ong'"}), 400

    if tipo == 'ong' and not cnpj:
        return jsonify({'erro': 'cnpj é obrigatório para ONGs'}), 400

    if Usuario.query.filter_by(email=email).first():
        return jsonify({'erro': 'e-mail já cadastrado'}), 409

    usuario = Usuario(
        nome=nome,
        email=email,
        senha_hash=generate_password_hash(senha),
        tipo=tipo,
        cnpj=cnpj if tipo == 'ong' else None,
    )
    db.session.add(usuario)
    db.session.commit()

    return jsonify({
        'mensagem': 'Usuário registrado com sucesso',
        'usuario': usuario.to_dict(),
    }), 201


@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.get_json(silent=True) or {}

    email = (data.get('email') or '').strip().lower()
    senha = data.get('senha') or ''

    if not email or not senha:
        return jsonify({'erro': 'email e senha são obrigatórios'}), 400

    usuario = Usuario.query.filter_by(email=email).first()
    if usuario is None or not check_password_hash(usuario.senha_hash, senha):
        return jsonify({'erro': 'credenciais inválidas'}), 401

    access_token = create_access_token(
        identity=str(usuario.id),
        additional_claims={'tipo': usuario.tipo, 'email': usuario.email},
    )

    return jsonify({
        'access_token': access_token,
        'usuario': usuario.to_dict(),
    }), 200
