from extensions import db


class Usuario(db.Model):
    __tablename__ = 'usuarios'

    id = db.Column(db.Integer, primary_key=True)
    nome = db.Column(db.String(120), nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False, index=True)
    senha_hash = db.Column(db.String(256), nullable=False)
    tipo = db.Column(db.String(20), nullable=False)
    cnpj = db.Column(db.String(18), nullable=True)

    pets = db.relationship('Pet', backref='usuario', lazy=True)

    def to_dict(self):
        return {
            'id': self.id,
            'nome': self.nome,
            'email': self.email,
            'tipo': self.tipo,
            'cnpj': self.cnpj,
        }


class Pet(db.Model):
    __tablename__ = 'pets'

    id = db.Column(db.Integer, primary_key=True)
    nome = db.Column(db.String(120), nullable=False)
    idade = db.Column(db.String(50), nullable=False)
    sexo = db.Column(db.String(20), nullable=False)
    raca = db.Column(db.String(120), nullable=False)
    vacinado = db.Column(db.String(120), nullable=False)
    localizacao = db.Column(db.String(120), nullable=False)
    castrado = db.Column(db.String(10), nullable=False)
    descricao = db.Column(db.Text, nullable=False)
    usuario_id = db.Column(db.Integer, db.ForeignKey('usuarios.id'), nullable=False)

    def to_dict(self):
        return {
            'id': self.id,
            'nome': self.nome,
            'idade': self.idade,
            'sexo': self.sexo,
            'raca': self.raca,
            'vacinado': self.vacinado,
            'localizacao': self.localizacao,
            'castrado': self.castrado,
            'descricao': self.descricao,
            'usuario_id': self.usuario_id,
        }
