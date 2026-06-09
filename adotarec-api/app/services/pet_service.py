from app.repositories.pet_repository import PetRepository
from app.repositories.user_repository import UserRepository


class PetService:
    """Serviço de gerenciamento de pets"""
    
    @staticmethod
    def list_available(filters=None):
        """Lista pets disponíveis com filtros opcionais"""
        return PetRepository.find_all(filters)
    
    @staticmethod
    def get_pet(pet_id):
        """Obtém detalhes de um pet"""
        pet = PetRepository.find_by_id(pet_id)
        if not pet:
            return None, 'Pet não encontrado'
        return pet, None
    
    @staticmethod
    def create_pet(owner_id, pet_data):
        """Cria novo pet (apenas ONG)"""
        owner = UserRepository.find_by_id(owner_id)
        if not owner:
            return None, 'Usuário não encontrado'
        
        if owner.tipo != 'ONG':
            return None, 'Apenas ONGs podem cadastrar pets'
        
        # Validações básicas
        if not pet_data.get('nome'):
            return None, 'Nome do pet é obrigatório'
        if not pet_data.get('especie'):
            return None, 'Espécie é obrigatória'
        if not pet_data.get('whatsapp_contato'):
            return None, 'WhatsApp de contato é obrigatório'
        
        pet_create_data = {
            'owner_id': owner_id,
            'nome': pet_data['nome'],
            'especie': pet_data['especie'],
            'raca': pet_data.get('raca'),
            'idade': pet_data.get('idade'),
            'sexo': pet_data.get('sexo'),
            'porte': pet_data.get('porte'),
            'castrado': pet_data.get('castrado', False),
            'vacinado': pet_data.get('vacinado', False),
            'localizacao': pet_data.get('localizacao'),
            'descricao': pet_data.get('descricao'),
            'imagem_url': pet_data.get('imagem_url'),
            'whatsapp_contato': pet_data['whatsapp_contato'],
            'status': 'DISPONIVEL'
        }
        
        pet = PetRepository.create(pet_create_data)
        return pet, None
    
    @staticmethod
    def update_pet(user_id, pet_id, update_data):
        """Atualiza dados do pet (apenas dono da ONG)"""
        pet = PetRepository.find_by_id(pet_id)
        if not pet:
            return None, 'Pet não encontrado'
        
        if pet.owner_id != user_id:
            return None, 'Você não tem permissão para editar este pet'
        
        # Permitir atualização de certos campos
        allowed_fields = ['raca', 'idade', 'sexo', 'porte', 'castrado', 'vacinado', 
                         'localizacao', 'descricao', 'imagem_url', 'whatsapp_contato']
        filtered_data = {k: v for k, v in update_data.items() if k in allowed_fields}
        
        pet = PetRepository.update(pet_id, filtered_data)
        return pet, None
    
    @staticmethod
    def delete_pet(user_id, pet_id):
        """Deleta um pet (apenas dono da ONG)"""
        pet = PetRepository.find_by_id(pet_id)
        if not pet:
            return None, 'Pet não encontrado'
        
        if pet.owner_id != user_id:
            return None, 'Você não tem permissão para deletar este pet'
        
        success = PetRepository.delete(pet_id)
        return success, None
    
    @staticmethod
    def update_status(user_id, pet_id, new_status):
        """Atualiza status do pet (apenas dono da ONG)"""
        pet = PetRepository.find_by_id(pet_id)
        if not pet:
            return None, 'Pet não encontrado'
        
        if pet.owner_id != user_id:
            return None, 'Você não tem permissão para alterar o status deste pet'
        
        valid_statuses = ['DISPONIVEL', 'EM_PROCESSO', 'ADOTADO', 'INATIVO']
        if new_status not in valid_statuses:
            return None, f'Status inválido. Valores aceitos: {", ".join(valid_statuses)}'
        
        pet = PetRepository.update_status(pet_id, new_status)
        return pet, None
    
    @staticmethod
    def list_user_pets(user_id):
        """Lista pets de um usuário (apenas ONG)"""
        user = UserRepository.find_by_id(user_id)
        if not user:
            return None, 'Usuário não encontrado'
        
        if user.tipo != 'ONG':
            return None, 'Apenas ONGs têm pets'
        
        pets = PetRepository.find_by_owner(user_id)
        return pets, None
