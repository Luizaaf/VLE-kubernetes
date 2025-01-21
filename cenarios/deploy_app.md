## Configurando uma aplicação python flask que acessa uma banco de dados postgres.

### Introdução

Este guia vai explorar um processo passo a passo de como realizar o deploy em um cluster Kubernetes de uma aplicação flask que acessa uma banco de dados postgres.

### Prerequisitos

#### Ter acesso a uma conta em uma ambiente de Nuvem

  - Para obter uma conta gratuita na AWS é preciso pedir ao seu professor que lhe insira em uma turma do AWS Academy, caso já seja seu caso siga para o proximo passo.
  - Para criar uma conta gratuita na Azure você pode seguir o seguinte tutorial [Criando conta na azure](../configuracoes_md/criacao_conta_azure.md)

#### Cluster Kubernetes no qual será realizado o deploy



### Deploy do banco de dados Postgres

### Criação de um Secret para Armazenar os Detalhes do Banco de Dados

Um [Secret](https://kubernetes.io/docs/concepts/configuration/secret/) é um objeto do Kubernetes utilizado para armazenar pequenas quantidades de informações sensíveis, como nomes de usuários e senhas. Usar um Secret evita a necessidade de incluir dados confidenciais no código-fonte da sua aplicação, facilitando a atualização das configurações sem a necessidade de alterar o código da aplicação.

#### Criando um Secret para o PostgreSQL

Vamos criar um Secret para o PostgreSQL que armazenará as seguintes informações de configuração: usuário, senha e nome do banco de dados.

```bash
cat > postgres-secret.yml << EOF
apiVersion: v1
kind: Secret
metadata:
  name: postgres-secret
type: Opaque
data:
  postgres-user: bXl1c2Vy
  postgres-password: bXlwYXNzd29yZA==
  database-name: bXlkYg==
EOF
```

#### Detalhes da Configuração

- **apiVersion: v1** Especifica a versão da API do Kubernetes usada para este Secret.
- **kind: Secret** Define o tipo de objeto do Kubernetes, que neste caso é Secret.
- **metadata:** Contém metadados do objeto. O campo name define o nome do Secret, neste caso postgres-secret.
- **type: Opaque** Indica que o Secret armazena dados sensíveis, como nomes de usuários e senhas, codificados em base64 para maior segurança.
- **data:** Contém os dados sensíveis no formato chave valor codificados em base64. Aqui temos as chaves postgres-user, postgres-password e database-name.

Aplique essa configuração com o comando:

```bash
kubectl apply -f postgres-secret.yml
```

Você pode verficiar se o Secret foi executado corretamente com o comando:

```bash
kubectl get secret
```

Saída:

```bash

```

#### Deployment Postgres

Um deployment vai ser o objeto resposavel por gerenciar um conjunto de Pods para execução de um determinado trabalho. Iremos criar um deployment que será resposavel pela execução do Pod que irá conter o container do Postgres em execução. 


#### Criando um deployment para o Postgres

```bash
cat > postgres-deployment.yml << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
        - name: postgres
          image: 'postgres:14'
          ports:
            - containerPort: 5432
          env:
          - name: POSTGRES_DB
            valueFrom:
              secretKeyRef:
                name: postgres-secret
                key: database-name
          - name: POSTGRES_USER
            valueFrom:
              secretKeyRef:
                name: postgres-secret
                key: postgres-user
          - name: POSTGRES_PASSWORD
            valueFrom:
              secretKeyRef:
                name: postgres-secret
                key: postgres-password
EOF
```

#### Detalhes da configuração

- **Replicas** especifica a quantidade desejada de replicas.
- **selector** especifica como o deployment identifica quais pods ele gerencia.
- **template** define o template do Pod usado para criar novos Pods controlado por esse deployment.
- **containers** especifica os containers dentro do pod.
- **image** especifica a imagem Docker para o Pod a ser criado.
- **imagePullPolicy** especifica a politica para baixar a imagem do container.
- **ports** especifica as portas que o container exponhe.
- **envFrom** permite ao container carregar variaveis de ambiente from a secret por exemplo.

Aplique essa configuração com o comando:

```bash
kubectl apply -f postgres-deployment.yml
```

Você pode verficiar se o Deployment foi executado corretamente com o comando:

```bash
kubectl get deployment 
```

Saída:

```bash

```

#### Postgres Service

Um service é um objeto Kubernetes usado para expor uma aplicação que está executnado em um Pod do cluster.

#### Criando um service para o Postgres

```bash
cat > postgres-svc.yml << EOF
apiVersion: v1
kind: Service
metadata:
  name: postgres-svc
spec:
  selector:
    app: postgres
  ports:
    - protocol: TCP
      port: 5432
      targetPort: 5432
EOF
```

#### Detalhes de configuração

- **targetPort** é a porta dá maquina que irá redicionar para porta do container dentro do Pod.
- como não é indicado o tipo do service, por padrão ele irá criar uma sevice do tipo `nodePort`, que é uma tipo de service que somente é visivel dentro do próprio cluster.

Aplique essa configuração com o comando:

```bash
kubectl apply -f postgres-svc.yml
```

Você pode verficiar se o service foi executado corretamente com o comando:

```bash
kubectl get svc 
```

Saída:

```bash

```

#### Criando um configmap para o nosso aplicativo.


```bash

```