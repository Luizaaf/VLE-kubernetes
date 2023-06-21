from rich.console import Console
# from rich.layout import Layout

console = Console()

options = {1: "Criar cluster", 2: "Destruir cluster",
           3: "Atualizar cluster", 4: "Links uteis", 5: "Sair"}

while True:
    console.print("VLE - for Kubernetes :anchor: \n",
                  justify="center", style="blue")

    for k, v in options.items():
        console.print(f"{k} - {v}", justify="center", style="blue")

    choice = input("Digite a opção desejada: ")
    if int(choice) == 5:
        console.print("Obrigado por usar o programa até uma proxima :smile:",
                      justify="center", style="green")
        break
