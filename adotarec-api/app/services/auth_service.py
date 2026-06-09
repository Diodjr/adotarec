from werkzeug.security import generate_password_hash, check_password_hash
from app.repositories.user_repository import UserRepository
from app.utils.validators import validate_cpf, validate_cnpj
import re


class AuthService:
    """Serviço de autenticação"""
    
    @staticmethod
    def validate_email(email):
        """Valida formato de email"""
        pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        return re.match(pattern, email) is not None
    
    @staticmethod
    def validate_password(password):
        """Valida força da senha"""
        if len(password) < 8:
            return False, "Senha deve ter pelo menos 8 caracteres"
        return True, None
    
    @staticmethod
    def register(usuario_data):
        """Registra novo usuário"""
        errors = []
        
        # Validações básicas
        if not usuario_data.get('nome'):
            errors.append('Nome é obrigatório')
        
        if not usuario_data.get('email'):
            errors.append('Email é obrigatório')
        elif not AuthService.validate_email(usuario_data['email']):
            errors.append('Email inválido')
        elif UserRepository.email_exists(usuario_data['email']):
            errors.append('Email já cadastrado')
        
        if not usuario_data.get('senha'):
            errors.append('Senha é obrigatória')
        else:
            valid, msg = AuthService.validate_password(usuario_data['senha'])
            if not valid:
                errors.append(msg)
        
        tipo = usuario_data.get('tipo', '').upper()
        if tipo not in ['ONG', 'PROTETOR']:
            errors.append('Tipo deve ser ONG ou PROTETOR')
        
        # Validações específicas por tipo
        if tipo == 'ONG':
            if not usuario_data.get('cnpj'):
                errors.append('CNPJ é obrigatório para ONGs')
            elif not validate_cnpj(usuario_data['cnpj']):
                errors.append('CNPJ inválido')
            elif UserRepository.cnpj_exists(usuario_data['cnpj']):
                errors.append('CNPJ já cadastrado')
        
        elif tipo == 'PROTETOR':
            if usuario_data.get('cpf'):
                if not validate_cpf(usuario_data['cpf']):
                    errors.append('CPF inválido')
                elif UserRepository.cpf_exists(usuario_data['cpf']):
                    errors.append('CPF já cadastrado')
        
        if errors:
            return None, errors
        
        # Criar usuário
        user_data = {
            'tipo': tipo,
            'nome': usuario_data['nome'],
            'email': usuario_data['email'],
            'telefone': usuario_data.get('telefone'),
            'cpf': usuario_data.get('cpf'),
            'cnpj': usuario_data.get('cnpj'),
            'senha_hash': generate_password_hash(usuario_data['senha']),
            'ativo': True
        }
        
        user = UserRepository.create(user_data)
        return user, None
    
    @staticmethod
    def login(login, senha):
        """Realiza login do usuário"""
        user = UserRepository.find_by_login(login)
        
        if not user:
            return None, 'Usuário ou senha inválidos'
        
        if not check_password_hash(user.senha_hash, senha):
            return None, 'Usuário ou senha inválidos'
        
        return user, None
