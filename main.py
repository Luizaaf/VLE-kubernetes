import subprocess
import click


@click.group()
def cli():
    pass


def terraform_init():
    """
    Inicia o diretório de trabalho do terraform
    """
    try:
        subprocess.run(
            ['terraform', '-chdir=infraestrutura', 'init'], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Terraform init falhou com o erro: {e}")


def terraform_plan():
    """
    Executa o plano da configuração do terraform.
    """
    try:
        terraform_init()
        subprocess.run(['terraform', '-chdir=infraestrutura',
                        'plan', '-out=tfplan'], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Terraform plan falhou com erro: {e}")


def terraform_apply():
    """
    Aplica os arquivos de configuração do terraform.
    """
    try:
        subprocess.run(['terraform', '-chdir=infraestrutura',
                        'apply', 'tfplan'], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Terraform apply falhou com erro: {e}")


def terraform_destroy():
    try:
        subprocess.run(
            ['terraform', '-chdir=infraestrutura', 'destroy'], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Terraform destroy falhou com o erro: {e}")


@click.command()
def create():
    """
    Realiza a criação do cluster kubernetes.
    """
    terraform_plan()
    terraform_apply()


@click.command()
def destroy():
    """
    Realizar a destruição dos cluster kubernetes.
    """
    terraform_destroy()


cli.add_command(create)
cli.add_command(destroy)

if __name__ == '__main__':
    cli()
