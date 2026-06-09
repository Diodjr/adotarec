from extensions import db
from app.models.user import User


class UserRepository:
    """Repositório para operações de usuário no banco de dados"""
    
    @staticmethod
    def find_by_id(user_id):
        """Busca usuário por ID"""
        return User.query.filter_by(id=user_id, ativo=True).first()
    
    @staticmethod
    def find_by_email(email):
        """Busca usuário por email"""
        return User.query.filter_by(email=email, ativo=True).first()
    
    @staticmethod
    def find_by_cpf(cpf):
        """Busca usuário por CPF"""
        return User.query.filter_by(cpf=cpf, ativo=True).first()
    
    @staticmethod
    def find_by_cnpj(cnpj):
        """Busca usuário por CNPJ"""
        return User.query.filter_by(cnpj=cnpj, ativo=True).first()
    
    @staticmethod
    def find_by_login(login):
        """Busca usuário por email, CPF ou CNPJ"""
        user = User.query.filter_by(email=login, ativo=True).first()
        if user:
            return user
        
        user = User.query.filter_by(cpf=login, ativo=True).first()
        if user:
            return user
        
        user = User.query.filter_by(cnpj=login, ativo=True).first()
        if user:
            return user
        
        return None
    
    @staticmethod
    def create(usuario_data):
        """Cria novo usuário"""
        user = User(**usuario_data)
        db.session.add(user)
        db.session.commit()
        return user
    
    @staticmethod
    def update(user_id, update_data):
        """Atualiza dados do usuário"""
        user = UserRepository.find_by_id(user_id)
        if user:
            for key, value in update_data.items():
                if hasattr(user, key) and key not in ['id', 'email', 'cpf', 'cnpj', 'senha_hash', 'ativo']:
                    setattr(user, key, value)
            db.session.commit()
        return user
    
    @staticmethod
    def deactivate(user_id):
        """Desativa conta do usuário"""
        user = UserRepository.find_by_id(user_id)
        if user:
            user.ativo = False
            db.session.commit()
        return user
    
    @staticmethod
    def email_exists(email):
        """Verifica se email já existe"""
        return User.query.filter_by(email=email).first() is not None
    
    @staticmethod
    def cpf_exists(cpf):
        """Verifica se CPF já existe"""
        return User.query.filter_by(cpf=cpf).first() is not None
    
    @staticmethod
    def cnpj_exists(cnpj):
        """Verifica se CNPJ já existe"""
        return User.query.filter_by(cnpj=cnpj).first() is not None
