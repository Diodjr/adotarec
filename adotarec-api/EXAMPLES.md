# Exemplos de Uso da ADOTAREC API

## Pré-requisitos

- API rodando em `http://localhost:5000`
- Terminal ou ferramenta como Postman/Insomnia

## 1. Registrar uma ONG

```bash
curl -X POST http://localhost:5000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "tipo": "ONG",
    "nome": "ONG Amigos dos Animais",
    "email": "contato@ong.com",
    "telefone": "81999999999",
    "cnpj": "12345678000199",
    "senha": "senha123"
  }'

# Resposta:
# {
#   "message": "Usuário criado com sucesso"
# }
```

## 2. Registrar um Protetor

```bash
curl -X POST http://localhost:5000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "tipo": "PROTETOR",
    "nome": "João Silva",
    "email": "joao@email.com",
    "telefone": "81988888888",
    "cpf": "12345678901",
    "senha": "senha123"
  }'
```

## 3. Fazer Login (ONG)

```bash
curl -X POST http://localhost:5000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "login": "contato@ong.com",
    "senha": "senha123"
  }'

# Resposta:
# {
#   "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
#   "user": {
#     "id": 1,
#     "nome": "ONG Amigos dos Animais",
#     "tipo": "ONG"
#   }
# }
```

**Guarde o token para os próximos passos!**

## 4. Obter Perfil Logado

```bash
curl -X GET http://localhost:5000/api/v1/auth/me \
  -H "Authorization: Bearer SEU_TOKEN_AQUI"

# Resposta:
# {
#   "id": 1,
#   "nome": "ONG Amigos dos Animais",
#   "tipo": "ONG",
#   "email": "contato@ong.com",
#   "telefone": "81999999999"
# }
```

## 5. Criar um Pet (apenas ONG logada)

```bash
curl -X POST http://localhost:5000/api/v1/pets \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer SEU_TOKEN_AQUI" \
  -d '{
    "nome": "Oreo",
    "especie": "CACHORRO",
    "raca": "SRD",
    "idade": "2 anos",
    "sexo": "MACHO",
    "porte": "MEDIO",
    "castrado": true,
    "vacinado": true,
    "localizacao": "Recife - PE",
    "descricao": "Muito dócil, adora brincar",
    "imagem_url": "https://example.com/oreo.jpg",
    "whatsapp_contato": "5581999999999"
  }'

# Resposta:
# {
#   "message": "Pet criado com sucesso",
#   "pet": {
#     "id": 1,
#     "nome": "Oreo",
#     "especie": "CACHORRO",
#     ...
#     "status": "DISPONIVEL"
#   }
# }
```

## 6. Listar Todos os Pets Disponíveis

```bash
curl -X GET http://localhost:5000/api/v1/pets

# Resposta:
# [
#   {
#     "id": 1,
#     "nome": "Oreo",
#     "especie": "CACHORRO",
#     "status": "DISPONIVEL"
#   }
# ]
```

## 7. Listar Pets com Filtros

```bash
# Filtrar por sexo e porte
curl -X GET "http://localhost:5000/api/v1/pets?sexo=MACHO&porte=MEDIO"

# Filtrar apenas por espécie
curl -X GET "http://localhost:5000/api/v1/pets?especie=CACHORRO"

# Filtrar por status
curl -X GET "http://localhost:5000/api/v1/pets?status=DISPONIVEL"
```

## 8. Obter Detalhes de um Pet

```bash
curl -X GET http://localhost:5000/api/v1/pets/1

# Resposta:
# {
#   "id": 1,
#   "nome": "Oreo",
#   "especie": "CACHORRO",
#   "raca": "SRD",
#   "idade": "2 anos",
#   "sexo": "MACHO",
#   "porte": "MEDIO",
#   "castrado": true,
#   "vacinado": true,
#   "localizacao": "Recife - PE",
#   "descricao": "Muito dócil, adora brincar",
#   "imagem_url": "https://example.com/oreo.jpg",
#   "whatsapp_contato": "5581999999999",
#   "status": "DISPONIVEL",
#   "owner": {
#     "id": 1,
#     "nome": "ONG Amigos dos Animais",
#     "tipo": "ONG"
#   }
# }
```

## 9. Atualizar Dados do Pet (apenas dono)

```bash
curl -X PUT http://localhost:5000/api/v1/pets/1 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer SEU_TOKEN_AQUI" \
  -d '{
    "descricao": "Muito dócil, gosta de carinho e brincadeiras",
    "vacinado": true
  }'
```

## 10. Alterar Status do Pet (apenas dono)

```bash
# Mudar para EM_PROCESSO
curl -X PATCH http://localhost:5000/api/v1/pets/1/status \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer SEU_TOKEN_AQUI" \
  -d '{
    "status": "EM_PROCESSO"
  }'

# Status válidos: DISPONIVEL, EM_PROCESSO, ADOTADO, INATIVO
```

## 11. Deletar um Pet (apenas dono)

```bash
curl -X DELETE http://localhost:5000/api/v1/pets/1 \
  -H "Authorization: Bearer SEU_TOKEN_AQUI"

# Resposta:
# {
#   "message": "Pet deletado"
# }
```

## 12. Listar Meus Pets (apenas ONG logada)

```bash
curl -X GET http://localhost:5000/api/v1/users/me/pets \
  -H "Authorization: Bearer SEU_TOKEN_AQUI"

# Resposta:
# [
#   {
#     "id": 1,
#     "nome": "Oreo",
#     ...
#   }
# ]
```

## 13. Atualizar Perfil

```bash
curl -X PUT http://localhost:5000/api/v1/users/me \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer SEU_TOKEN_AQUI" \
  -d '{
    "nome": "ONG Amigos dos Animais - Recife",
    "telefone": "81987654321"
  }'

# Resposta:
# {
#   "message": "Perfil atualizado",
#   "user": {
#     "id": 1,
#     "nome": "ONG Amigos dos Animais - Recife",
#     ...
#   }
# }
```

## 14. Desativar Conta

```bash
curl -X DELETE http://localhost:5000/api/v1/users/me \
  -H "Authorization: Bearer SEU_TOKEN_AQUI"

# Resposta:
# {
#   "message": "Conta desativada"
# }
```

## Usando com Python

```python
import requests

BASE_URL = "http://localhost:5000/api/v1"

# 1. Registrar
response = requests.post(f"{BASE_URL}/auth/register", json={
    "tipo": "ONG",
    "nome": "ONG Teste",
    "email": "teste@ong.com",
    "cnpj": "12345678000199",
    "senha": "senha123"
})
print(response.json())

# 2. Login
response = requests.post(f"{BASE_URL}/auth/login", json={
    "login": "teste@ong.com",
    "senha": "senha123"
})
token = response.json()["access_token"]

# 3. Criar pet
headers = {"Authorization": f"Bearer {token}"}
response = requests.post(f"{BASE_URL}/pets", json={
    "nome": "Oreo",
    "especie": "CACHORRO",
    "raca": "SRD",
    "sexo": "MACHO",
    "porte": "MEDIO",
    "whatsapp_contato": "5581999999999"
}, headers=headers)
print(response.json())

# 4. Listar pets
response = requests.get(f"{BASE_URL}/pets")
print(response.json())
```

## Usando com JavaScript/Fetch

```javascript
const BASE_URL = "http://localhost:5000/api/v1";

// 1. Registrar
async function registrar() {
  const response = await fetch(`${BASE_URL}/auth/register`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      tipo: 'ONG',
      nome: 'ONG Teste',
      email: 'teste@ong.com',
      cnpj: '12345678000199',
      senha: 'senha123'
    })
  });
  return await response.json();
}

// 2. Login
async function login() {
  const response = await fetch(`${BASE_URL}/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      login: 'teste@ong.com',
      senha: 'senha123'
    })
  });
  const data = await response.json();
  return data.access_token;
}

// 3. Listar pets
async function listarPets() {
  const response = await fetch(`${BASE_URL}/pets`);
  return await response.json();
}

// 4. Criar pet
async function criarPet(token) {
  const response = await fetch(`${BASE_URL}/pets`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`
    },
    body: JSON.stringify({
      nome: 'Oreo',
      especie: 'CACHORRO',
      raca: 'SRD',
      sexo: 'MACHO',
      porte: 'MEDIO',
      whatsapp_contato: '5581999999999'
    })
  });
  return await response.json();
}
```

## Notas Importantes

- **JWT Token**: Válido por 30 dias
- **CPF/CNPJ**: Devem ser únicos no sistema
- **Email**: Deve ser único e válido
- **Senha**: Mínimo 8 caracteres
- **WhatsApp**: Deve estar no formato internacional (com código do país)

## Códigos de Status HTTP

- `200 OK`: Sucesso
- `201 Created`: Recurso criado com sucesso
- `400 Bad Request`: Dados inválidos
- `401 Unauthorized`: Falha na autenticação
- `403 Forbidden`: Acesso negado
- `404 Not Found`: Recurso não encontrado
