#!/usr/bin/env python
import os
from dotenv import load_dotenv
from app import create_app

# Carregar variáveis de ambiente
load_dotenv()

# Criar aplicação
app = create_app()

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
