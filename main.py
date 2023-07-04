options = {1: "Criar cluster", 2: "Destruir cluster",
           3: "Atualizar cluster", 4: "Links uteis", 5: "Sair"}

while True:
    print("VLE - for Kubernetes\n",)

    for k, v in options.items():
        print(f"{k} - {v}")

    option_choice = input("Digite a opção desejada: ")

    if int(option_choice) == 1:
        ...

    if int(option_choice) == 5:
        print("Obrigado por usar o programa até uma proxima")
        break
