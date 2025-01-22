## Ambientes Virtuais de Aprendizagem para o Kubernetes
---
<div style="text-align: justify;">
Esse repositório oferece uma ferramenta de linha de comando que proporciona um ambiente de estudos para o Kubernetes utilizando o Kubeadm de maneira simples e intuitiva, visando o menor custo possível. A ferramenta é direcionada a usuários universitários da rede pública, sendo compatível com os provedores de nuvem Azure e AWS, que oferecem acesso gratuito para estudantes.
</div>

---
#### Observações
---
+ Atualmente, a ferramenta pode criar clusters Kubernetes nas nuvens Azure e AWS.
+ A ferramenta foi testada apenas nos ambientes Linux Ubuntu.

---
### Baixando a ferramenta.
___
+ Para instalar a ferramenta, basta clonar este repositório com o comando:
```bash
git clone https://github.com/Luizaaf/VLE-kubernetes.git ~/Downloads
```
---
### Dependências
---

+ Python:
	+ O Python já vem pré-instalado em computadores Linux.
+ Terraform.
	+ Para instalar o terraform no linux Ubuntu execute, os seguintes comandos:
	```bash
	cutl -s https://releases.hashicorp.com/terraform/1.10.4/terraform_1.10.4_linux_amd64.zip -o /tmp/terraform.zip
	unzip -o /tmp/terraform.zip -d /tmp
	sudo mv /tmp/terraform /usr/local/bin/
	```
	+ Após isso, teste se o comando foi instalado corretamente executando `terraform --version`.

+ Ansible.
	+ Para instalar o Ansible no Linux utilizando o Python, execute o seguinte comando:
	```bash
	sudo apt install python3-pip -y & pip3 install ansible
	```

+ AWS CLI (caso você vá utilizar a AWS):
	+ Para instalar a AWS CLI no Linux, execute os seguintes comandos:
	```bash
	pip3 boto3 botocore awscli
	```
+ Azure CLI (caso vá utilizar a Azure):
	+ Para instalar a Azure CLI no Linux, execute os seguintes comandos:
	```bash
	sudo apt install azure-cli
	```
+ jq
	+ Para instalar o comando jq no Linux, execute os seguintes comandos:
	```bash
	sudo apt install jq
	```
	
---
### Criação de Contas nos Ambientes de Nuvem
---
+ **AWS:** Não é possível criar uma conta por conta própria. Solicite ao seu professor para incluí-lo em uma conta do AWS Academy.
+ **Azure:** Para criar uma conta na Azure, siga o passo a passo contido no link: [Configurando conta gratuita na Azure](configuracoes_md/criacao_conta_azure.md).
---
### Configuração da Ferramenta para Utilização do Ambiente de Nuvem
---
Após a criação das contas conforme as instruções anteriores, é necessário garantir que a ferramenta tenha acesso a elas. Siga os passos de acordo com a nuvem escolhida:

+ **AWS Academy:** Se for utilizar a AWS, siga as instruções em: [Configurando ferramenta para acessar o AWS Academy](configuracoes_md/configuracao_aws.md).
+ **Azure:** Se optar pela Azure, siga as instruções em: [Configurando a ferramenta para acessar a Azure](configuracoes_md/configuracao_azure.md).
---
### Utilizando a ferramenta.
---
+ Acesse o diretório e execute o arquivo main.py:

```bash
cd ~/Downloads/VLE-kubernets
python3 main.py
```
+ Você será apresentado à seguinte interface.

+ ![](configuracoes_md/images/interface_vle.png)

+ Nessa interface, você tem acesso a 4 opções:

1. CRIAR CLUSTER KUBERNETS.
	+ Nesta opção, você pode criar um cluster Kubernetes para estudos. Ao selecionar esta opção, você verá a seguinte tela:
	+ ![](configuracoes_md/images/criando_cluster.png)
	+ Nessa tela, escolha a nuvem a ser utilizada e a criação do seu cluster será iniciada.
2. CENÁRIO GUIADO.
	+ Esta opção fornece um link para acessar um cenário guiado disponível neste repositório.
3. DESTRUIR CLUSTER KUBERNETS.
	+ Nesta opção, você pode destruir o cluster criado. Ao selecionar esta opção, verá a seguinte tela:
	+ ![](configuracoes_md/images/destruindo_cluster.png)
	+ Escolha a nuvem a ser utilizada e seu cluster será destruído.
4. SAIR.
	+ Esta opção encerra a ferramenta.
---

## Cenário de estudo

1. [Realizado deploy simples de uma aplicação Python no Kubernetes](cenarios/deploy_app.md)