# ADOTAREC API

API REST para gerenciamento de pets disponíveis para adoção.

## Requisitos

- Python 3.12+
- pip

## Instalação

1. Clonar o repositório ou extrair os arquivos

2. Navegar até a pasta do projeto:
```bash
cd adotarec-api
```

3. Criar um ambiente virtual:
```bash
python -m venv venv
```

4. Ativar o ambiente virtual:

**Windows:**
```bash
.\venv\Scripts\activate
```

**Linux/Mac:**
```bash
source venv/bin/activate
```

5. Instalar dependências:
```bash
pip install -r requirements.txt
```

6. Configurar variáveis de ambiente:
- Abrir o arquivo `.env` e ajustar as configurações conforme necessário

## Executar a API

```bash
python app.py
```

A API será iniciada em `http://localhost:5000`

## Estrutura do Projeto

```
adotarec-api/
├── app/
│   ├── models/              # Modelos de dados
│   ├── routes/              # Rotas da API
│   ├── services/            # Lógica de negócio
│   ├── repositories/        # Acesso ao banco de dados
│   ├── utils/               # Utilitários (validadores, etc)
│   └── __init__.py
├── database/                # Banco de dados SQLite
├── uploads/                 # Pasta para uploads de imagens
├── config.py               # Configuração da aplicação
├── extensions.py           # Inicialização de extensões
├── app.py                  # Arquivo principal
├── requirements.txt        # Dependências
├── .env                    # Variáveis de ambiente
└── README.md              # Este arquivo
```

## Validações Primárias

### CPF
- Formato aceito: XXX.XXX.XXX-XX ou XXXXXXXXXXX
- Validação de dígitos verificadores
- Obrigatório para perfil PROTETOR

### CNPJ
- Formato aceito: XX.XXX.XXX/XXXX-XX ou XXXXXXXXXXXXXX
- Validação de dígitos verificadores
- Obrigatório para perfil ONG

## Autenticação

A API usa JWT (JSON Web Tokens) para autenticação. Após fazer login, você receberá um token que deve ser usado no header de autorização:

```
Authorization: Bearer YOUR_TOKEN_HERE
```

## Endpoints

### Autenticação

- `POST /api/v1/auth/register` - Registrar novo usuário
- `POST /api/v1/auth/login` - Fazer login
- `GET /api/v1/auth/me` - Obter perfil do usuário logado

### Usuários

- `PUT /api/v1/users/me` - Atualizar perfil
- `DELETE /api/v1/users/me` - Desativar conta
- `GET /api/v1/users/me/pets` - Listar meus pets (ONG)

### Pets

- `GET /api/v1/pets` - Listar pets disponíveis com filtros
- `GET /api/v1/pets/{id}` - Obter detalhes de um pet
- `POST /api/v1/pets` - Criar novo pet (ONG)
- `PUT /api/v1/pets/{id}` - Atualizar pet (ONG)
- `DELETE /api/v1/pets/{id}` - Deletar pet (ONG)
- `PATCH /api/v1/pets/{id}/status` - Alterar status do pet (ONG)

## Exemplos de Uso

### Registrar ONG

```bash
curl -X POST http://localhost:5000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "tipo": "ONG",
    "nome": "ONG Amigos dos Animais",
    "email": "contato@ong.org",
    "telefone": "81999999999",
    "cnpj": "12345678000199",
    "senha": "12345678"
  }'
```

### Fazer Login

```bash
curl -X POST http://localhost:5000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "login": "contato@ong.org",
    "senha": "12345678"
  }'
```

### Listar Pets Disponíveis

```bash
curl http://localhost:5000/api/v1/pets
```

### Listar Pets com Filtros

```bash
curl "http://localhost:5000/api/v1/pets?sexo=MACHO&porte=MEDIO"
```

### Criar Pet (requer autenticação como ONG)

```bash
curl -X POST http://localhost:5000/api/v1/pets \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "nome": "Oreo",
    "especie": "CACHORRO",
    "raca": "SRD",
    "idade": "2 anos",
    "sexo": "MACHO",
    "porte": "MEDIO",
    "castrado": true,
    "vacinado": true,
    "localizacao": "Recife",
    "descricao": "Muito dócil",
    "imagem_url": "https://imagem.com/pet.jpg",
    "whatsapp_contato": "5581999999999"
  }'
```

## Notas Importantes

- O banco de dados é criado automaticamente ao iniciar a aplicação
- A senha deve ter no mínimo 8 caracteres
- CPF e CNPJ são validados automaticamente
- O login aceita email, CPF ou CNPJ
- Apenas ONGs podem cadastrar e gerenciar pets
- Cada pet pertence a uma ONG específica

## Troubleshooting

Se encontrar problemas:

1. Certifique-se de que o Python 3.12+ está instalado
2. Verifique se todas as dependências foram instaladas: `pip install -r requirements.txt`
3. Verifique se as variáveis de ambiente estão configuradas corretamente em `.env`
4. Limpe o cache do Python: `find . -type d -name __pycache__ -exec rm -r {} +` (Linux/Mac) ou manualmente (Windows)

## Licença

MIT
