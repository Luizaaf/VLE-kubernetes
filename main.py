from python_terraform import *

options = {1: "Criar cluster", 2: "Destruir cluster",
           3: "Atualizar cluster", 4: "Links uteis", 5: "Sair"}


def apply_all():
    t = Terraform(working_dir="infraestrutura/terraform/aws")
    return_code, stdout, stderr = t.init()
    print(stdout)
    return_code, stdout, stderr = t.plan()
    print(stdout)
    return_code, stdout, stderr = t.apply(skip_plan=True)
    print(stdout)


while True:
    print("VLE - for Kubernetes\n",)

    for k, v in options.items():
        print(f"{k} - {v}")

    option_choice = input("\nDigite a opção desejada: ")

    if int(option_choice) == 1:
        apply_all()

    elif int(option_choice) == 5:
        print("\nObrigado por usar o programa até uma proxima!\n")
        break
