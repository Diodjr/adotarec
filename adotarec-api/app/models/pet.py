from extensions import db
from datetime import datetime


class Pet(db.Model):
    """Modelo de Pet"""
    __tablename__ = 'pets'
    
    id = db.Column(db.Integer, primary_key=True)
    owner_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    nome = db.Column(db.String(255), nullable=False)
    especie = db.Column(db.String(100), nullable=False)
    raca = db.Column(db.String(100))
    idade = db.Column(db.String(50))
    sexo = db.Column(db.String(20))
    porte = db.Column(db.String(20))
    castrado = db.Column(db.Boolean, default=False)
    vacinado = db.Column(db.Boolean, default=False)
    localizacao = db.Column(db.String(255))
    descricao = db.Column(db.Text)
    imagem_url = db.Column(db.String(500))
    whatsapp_contato = db.Column(db.String(20), nullable=False)
    status = db.Column(db.String(20), default='DISPONIVEL')  # DISPONIVEL, EM_PROCESSO, ADOTADO, INATIVO
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    def __repr__(self):
        return f'<Pet {self.nome}>'
    
    def to_dict(self, include_owner=False):
        data = {
            'id': self.id,
            'nome': self.nome,
            'especie': self.especie,
            'raca': self.raca,
            'idade': self.idade,
            'sexo': self.sexo,
            'porte': self.porte,
            'castrado': self.castrado,
            'vacinado': self.vacinado,
            'localizacao': self.localizacao,
            'descricao': self.descricao,
            'imagem_url': self.imagem_url,
            'whatsapp_contato': self.whatsapp_contato,
            'status': self.status,
            'created_at': self.created_at.isoformat()
        }
        
        if include_owner:
            data['owner'] = {
                'id': self.owner.id,
                'nome': self.owner.nome,
                'tipo': self.owner.tipo
            }
        
        return data
