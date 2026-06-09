from flask import Flask
from extensions import db, jwt, cors
from config import config
import os


def create_app(config_name=None):
    """Factory function para criar a aplicação Flask"""
    
    if config_name is None:
        config_name = os.getenv('FLASK_ENV', 'development')
    
    app = Flask(__name__)
    app.config.from_object(config[config_name])
    
    # Inicializar extensões
    db.init_app(app)
    jwt.init_app(app)
    cors.init_app(app)
    
    # Registrar blueprints
    from app.routes.auth import auth_bp
    from app.routes.users import users_bp
    from app.routes.pets import pets_bp
    
    app.register_blueprint(auth_bp)
    app.register_blueprint(users_bp)
    app.register_blueprint(pets_bp)
    
    # Criar tabelas ao iniciar
    with app.app_context():
        db.create_all()
    
    return app
