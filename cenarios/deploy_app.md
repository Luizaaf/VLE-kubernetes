
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

Um deployment vai ser o objeto resposavel por gerenciar um conjunto de Pods para execução de um determinado trabalho. Iremos criar um deployment que será resposavel pela execução do Pod que irá conter o container do Postgres em execução. Para isso crie o arquivo `postgres-deployment.yml`, com seu editor de texto preferido.

```
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

```

Após a criação do arquivo, use o comando `kubectl apply -f postgres-deployment.yml`, para realizar a criação do Deployment a partir do arquivo.

#### Postgres Service

Um service 