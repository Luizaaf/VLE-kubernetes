## Ambientes Virtuais de Aprendizagem para o Kubernetes

Esse repostório possui uma ferramenta de linha de comando que irá fornecer um ambiente de estudos para o Kubernetes utilizando o Kubeadm de forma simples e intuitiva buscando o menor gasto possivel. A ferramenta tem como foco usuários univestários da rede pública, a partir disso ela se encontra funcional nos provedores de nuvens da Azure e AWS que fornecem meios de acesso gratuíro para alunos univesitários.

#### Observações
---
+ Atualmente a ferramenta consegue criar o cluster Kubernetes nas nuvens da Azure e AWS. 
+ A ferramenta só foi testada em ambientes linux Ubuntu e Fedora.

### Dependências
---
+ Python.
	+ O python já vem pré instalado em computadores linux
+ Terraform.
	+ Para instalar o terraform no linux execute os seguintes comandos.
	+ Ubuntu: ```sudo apt install terraform```
	+ Fedora: ```sudo dnf install terraform```
+ Ansible.
	+ Para instalar o Ansible no linux execute os seguintes comandos.
	+ Ubuntu: ```sudo apt install python3-pip -y & pip3 install ansible```
	+ Fedora: ```sudo dnf install python3-pip -y & pip3 install ansible```
+ Caso você for utilizar a AWS precisara da AWS cli.
	+ Para instalar a AWS CLI no linux execute os seguintes comandos.
	+ Ubuntu: ```pip3 boto3 botocore awscli```
	+ Fedora: ```pip3 boto3 botocore awscli```
+ Caso for utilizar a Azure precisará da Azure CLI
	+ Para instalar a Azure CLI no linux execute os seguintes comandos.
	+ Ubuntu: ```sudo apt install azure-cli```
	+ Fedora: ```sudo dnf install azure-cli```
+ jq
	+ Para instalar o comando jq no linux execute os seguintes comandos.
	+ Ubuntu: ```sudo apt install jq```
	+ Fedora: ```sudo dnf install jq```
	
### Configuração de acesso as nuvens.
---
+ Para configurar o acesso na AWS leia as instruçoes contidas [aqui](configuracoes_de_acesso/configuracao_aws.md)
+ Na Azure, primeiro será preciso criar uma conta e após isso realizar algumas configurações, todo o passo a passo se encontra [aqui](configuracoes_de_acesso/configuracao_azure.md)

### Baixando a ferramenta.
---
+ Para baixar a ferramenta clone esse repositório para sua máquina local com o seguinte comando.

```
git clone https://github.com/Luizaaf/VLE-kubernetes.git
```

### Utilizando a ferramenta.

+ Acesse o diretório e execute o arquivo `main.py`.

```
cd VLE-kubernets
python3 main.py
```

+ Você será apresentado para a seguinte interface.

+ ![](images/interface_vle.png)
