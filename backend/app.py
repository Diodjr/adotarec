import os

from flask import Flask

from controllers.auth_controller import auth_bp
from extensions import db, jwt
from models import Pet, Usuario


def create_app():
    app = Flask(__name__)

    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///adotarec.db'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config['JWT_SECRET_KEY'] = os.getenv(
        'JWT_SECRET_KEY',
        'altere-esta-chave-em-producao',
    )

    db.init_app(app)
    jwt.init_app(app)

    app.register_blueprint(auth_bp)

    with app.app_context():
        db.create_all()

    return app


if __name__ == '__main__':
    app = create_app()
    app.run(debug=True, host='0.0.0.0', port=5000)
