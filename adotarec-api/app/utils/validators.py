import re


def validate_cpf(cpf):
    """
    Valida CPF e retorna True se válido, False caso contrário
    Aceita formatos: XXX.XXX.XXX-XX ou XXXXXXXXXXX
    """
    if not cpf:
        return False
    
    # Remove formatação
    cpf = re.sub(r'\D', '', cpf)
    
    # CPF deve ter 11 dígitos
    if len(cpf) != 11:
        return False
    
    # CPF não pode ter todos os dígitos iguais
    if cpf == cpf[0] * 11:
        return False
    
    # Calcula primeiro dígito verificador
    soma = sum(int(cpf[i]) * (10 - i) for i in range(9))
    primeiro_digito = 11 - (soma % 11)
    primeiro_digito = 0 if primeiro_digito > 9 else primeiro_digito
    
    if int(cpf[9]) != primeiro_digito:
        return False
    
    # Calcula segundo dígito verificador
    soma = sum(int(cpf[i]) * (11 - i) for i in range(10))
    segundo_digito = 11 - (soma % 11)
    segundo_digito = 0 if segundo_digito > 9 else segundo_digito
    
    if int(cpf[10]) != segundo_digito:
        return False
    
    return True


def validate_cnpj(cnpj):
    """
    Valida CNPJ e retorna True se válido, False caso contrário
    Aceita formatos: XX.XXX.XXX/XXXX-XX ou XXXXXXXXXXXXXX
    """
    if not cnpj:
        return False
    
    # Remove formatação
    cnpj = re.sub(r'\D', '', cnpj)
    
    # CNPJ deve ter 14 dígitos
    if len(cnpj) != 14:
        return False
    
    # CNPJ não pode ter todos os dígitos iguais
    if cnpj == cnpj[0] * 14:
        return False
    
    # Calcula primeiro dígito verificador
    #soma = sum(int(cnpj[i]) * (6 - (i % 4)) for i in range(12))
    #primeiro_digito = 11 - (soma % 11)
    #primeiro_digito = 0 if primeiro_digito > 9 else primeiro_digito
    pesos1 = [5,4,3,2,9,8,7,6,5,4,3,2]
    soma = sum(int(cnpj[i]) * pesos1[i] for i in range(12))
    resto = soma % 11
    primeiro_digito = 0 if resto < 2 else 11 - resto


    if int(cnpj[12]) != primeiro_digito:
        return False
    
    # Calcula segundo dígito verificador
    #soma = sum(int(cnpj[i]) * (7 - (i % 4)) for i in range(13))
    #segundo_digito = 11 - (soma % 11)
    #segundo_digito = 0 if segundo_digito > 9 else segundo_digito
    pesos2 = [6,5,4,3,2,9,8,7,6,5,4,3,2]
    soma = sum(int(cnpj[i]) * pesos2[i] for i in range(13))
    resto = soma % 11
    segundo_digito = 0 if resto < 2 else 11 - resto

    if int(cnpj[13]) != segundo_digito:
        return False
    
    return True


def format_cpf(cpf):
    """Formata CPF para o padrão XXX.XXX.XXX-XX"""
    cpf = re.sub(r'\D', '', cpf)
    if len(cpf) == 11:
        return f"{cpf[:3]}.{cpf[3:6]}.{cpf[6:9]}-{cpf[9:]}"
    return cpf


def format_cnpj(cnpj):
    """Formata CNPJ para o padrão XX.XXX.XXX/XXXX-XX"""
    cnpj = re.sub(r'\D', '', cnpj)
    if len(cnpj) == 14:
        return f"{cnpj[:2]}.{cnpj[2:5]}.{cnpj[5:8]}/{cnpj[8:12]}-{cnpj[12:]}"
    return cnpj
