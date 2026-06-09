from extensions import db
from app.models.pet import Pet


class PetRepository:
    """Repositório para operações de pet no banco de dados"""
    
    @staticmethod
    def find_by_id(pet_id):
        """Busca pet por ID"""
        return Pet.query.filter_by(id=pet_id).first()
    
    @staticmethod
    def find_by_owner(owner_id):
        """Busca todos os pets de um dono"""
        return Pet.query.filter_by(owner_id=owner_id).all()
    
    @staticmethod
    def find_all(filters=None):
        """Busca todos os pets com filtros opcionais"""
        query = Pet.query.filter_by(status='DISPONIVEL')
        
        if filters:
            if 'sexo' in filters:
                query = query.filter_by(sexo=filters['sexo'])
            if 'porte' in filters:
                query = query.filter_by(porte=filters['porte'])
            if 'especie' in filters:
                query = query.filter_by(especie=filters['especie'])
            if 'status' in filters:
                query = query.filter_by(status=filters['status'])
        
        return query.all()
    
    @staticmethod
    def create(pet_data):
        """Cria novo pet"""
        pet = Pet(**pet_data)
        db.session.add(pet)
        db.session.commit()
        return pet
    
    @staticmethod
    def update(pet_id, update_data):
        """Atualiza dados do pet"""
        pet = PetRepository.find_by_id(pet_id)
        if pet:
            for key, value in update_data.items():
                if hasattr(pet, key) and key not in ['id', 'owner_id']:
                    setattr(pet, key, value)
            db.session.commit()
        return pet
    
    @staticmethod
    def delete(pet_id):
        """Deleta um pet"""
        pet = PetRepository.find_by_id(pet_id)
        if pet:
            db.session.delete(pet)
            db.session.commit()
            return True
        return False
    
    @staticmethod
    def update_status(pet_id, status):
        """Atualiza status do pet"""
        pet = PetRepository.find_by_id(pet_id)
        if pet:
            pet.status = status
            db.session.commit()
        return pet
