import subprocess
import os
import time
from types import TracebackType

def terraform_init(diretorio):
    """
    Inicia o diretório de trabalho do terraform
    """
    try:
        subprocess.run(
            ['terraform', f'-chdir={diretorio}', 'init'], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Terraform init falhou com o erro: {e}")


def terraform_plan(diretorio):
    """
    Executa o plano da configuração do terraform.
    """
    try:
        terraform_init(diretorio)
        subprocess.run(['terraform', f'-chdir={diretorio}',
                        'plan', '-out=tfplan'], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Terraform plan falhou com erro: {e}")


def terraform_apply(diretorio):
    """
    Aplica os arquivos de configuração do terraform.
    """
    try:
        subprocess.run(['terraform', f'-chdir={diretorio}',
                        'apply', 'tfplan'], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Terraform apply falhou com erro: {e}")


def terraform_destroy(diretorio):
    try:
        subprocess.run(
            ['terraform', f'-chdir={diretorio}', 'destroy'], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Terraform destroy falhou com o erro: {e}")

def criando_inventario(inventario):
    try:
        os.chdir('scripts')
        subprocess.run([f'{inventario}'], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Erro ao criar o inventário ansible {e}")



def run_ansible(playbook_path, inventario):
    print("Aguardando inicialização completa das maquinas virtuais...")
    time.sleep(180)
    try:
        subprocess.run(['ansible-playbook', '-i', inventario, playbook_path], check=True)
        print("Playbook executado com sucesso!")
    except subprocess.CalledProcessError as e:
        print(f'Erro ao executar playbook {e.stderr}')


saida = False


while not saida:
    
    mensagem = (
        "[1] - CRIAR CLUSTER KUBERNETS\n"
        "[2] - CENÁRIO GUIADO\n"
        "[3] - DESTRUIR CLUSTER KUBERNETS\n"
        "[4] - SAIR\n"
        "ESCOLHA A OPÇÃO DESEJADA: "
    )
    opt = input(mensagem)
    os.system("clear")
    if opt == "1":
        provider = input("[1] - AWS\n"
        + "[2] - AZURE\n"
        + "[3] - VOLTAR AO MENU ANTERIOR\n"
        + "ESCOLHA O PROVEDOR DE NUVEM A SER UTILIZADO: ")

        if provider == "1":
            terraform_plan("infraestrutura/aws")
            terraform_apply("infraestrutura/aws")
            criando_inventario("./criando_inventario_aws.sh")
            run_ansible("ansible/playbook.yml", "ansible/inventory/hosts")
        elif provider == "2":
            terraform_plan("infraestrutura/azure")
            terraform_apply("infraestrutura/azure")
            criando_inventario("./criando_inventario_azure.sh")
        elif provider == "3":
            ...
        else: 
            print("OPÇÃO INVALIDA, POR FAVOR TENTE NOVAMENTE.")

    elif opt == "2":
        ...
    elif opt == "3":
        os.system("clear")
        provider = input("[1] - AWS\n"
        + "[2] - AZURE\n"
        + "[3] - VOLTAR AO MENU ANTERIOR\n"
        + "ESCOLHA O PROVEDOR DE NUVEM A SER UTILIZADO: ")

        if provider == "1":
            terraform_destroy("infraestrutura/aws")
            print("OBRIGADO POR USAR A FERRAMENTA ;)")
        elif provider == "2":
            terraform_destroy("infraestrutura/azure")
            print("OBRIGADO POR USAR A FERRAMENTA ;)")
        elif provider == "3":
            ...
        else: 
            print("OPÇÃO INVALIDA, POR FAVOR TENTE NOVAMENTE.")
    elif opt == "4":
        saida = True
        print("OBRIGADO POR USAR A FERRAMENTA ;)")        
    else:
        os.system('clear')
        print("OPÇÃO INVALIDA POR FAVOR TENTE NOVAMENTE")
