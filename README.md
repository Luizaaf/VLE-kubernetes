## Ambientes Virtuais de Aprendizagem para o Kubernetes

Esse repostório possui uma ferramenta de linha de comando que irá fornecer uma ambiente de estudos para o Kubernetes de forma simples e intuitiva buscando o menor gasto possivel. 

#### Observações

+ Atualmente a ferramenta consegue criar o cluster Kubernetes nas nuvens da Azure e AWS. 
+ A ferramenta só foi testada em ambientes linux Ubuntu e Fedora.

### Dependências
	
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
	
### Instalação

+ Para instalar a ferramenta tudo o que você precisa fazer é clonar esse repostório.
	+ ```git clone https://github.com/Luizaaf/VLE-kubernetes.git``` 

