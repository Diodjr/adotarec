from app.repositories.user_repository import UserRepository


class UserService:
    """Serviço de gerenciamento de usuários"""
    
    @staticmethod
    def get_profile(user_id):
        """Obtém perfil do usuário logado"""
        user = UserRepository.find_by_id(user_id)
        if not user:
            return None, 'Usuário não encontrado'
        return user, None
    
    @staticmethod
    def update_profile(user_id, update_data):
        """Atualiza perfil do usuário"""
        user = UserRepository.find_by_id(user_id)
        if not user:
            return None, 'Usuário não encontrado'
        
        # Permitir apenas atualização de nome e telefone
        allowed_fields = ['nome', 'telefone']
        filtered_data = {k: v for k, v in update_data.items() if k in allowed_fields}
        
        user = UserRepository.update(user_id, filtered_data)
        return user, None
    
    @staticmethod
    def deactivate_account(user_id):
        """Desativa conta do usuário"""
        user = UserRepository.find_by_id(user_id)
        if not user:
            return None, 'Usuário não encontrado'
        
        user = UserRepository.deactivate(user_id)
        return user, None
