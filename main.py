from python_terraform import *

options = {1: "Criar cluster", 2: "Destruir cluster", 3: "Sair"}


def apply_all():
    t = Terraform(working_dir="infraestrutura/terraform/aws")

    return_code, stdout, stderr = t.init(no_color=IsFlagged, input=False)
    print(stdout)

    return_code, stdout, stderr = t.plan(no_color=IsFlagged, input=False)
    print(stdout)

    return_code, stdout, stderr = t.apply(
        no_color=IsFlagged, input=False, skip_plan=True)
    print(stdout)


def destroy_all():

    tf = Terraform(working_dir="infraestrutura/terraform/aws")
    return_code = tf.destroy(capture_output='yes', no_color=IsNotFlagged,
                             force=IsNotFlagged, auto_approve=True)
    print(return_code)


exit = False
while not exit:
    print("VLE - for Kubernetes\n",)

    for k, v in options.items():
        print(f"{k} - {v}")

    option_choice = input("\nDigite a opção desejada: ")

    if int(option_choice) == 1:
        apply_all()

    elif int(option_choice) == 2:
        destroy_all()

    elif int(option_choice) == 3:
        print("\nObrigado por usar o programa até uma proxima!\n")
        exit = True
