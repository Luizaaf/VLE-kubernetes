## Configurando uma aplicação python flask que acessa uma banco de dados postgres.

### Introdução

Este guia vai explorar um processo passo a passo de como realizar o deploy em um cluster Kubernetes de uma aplicação flask que acessa uma banco de dados postgres.

## Prerequisitos

+ Para realizar esse cenário de estudos é necessário possuir um cluster kubernetes configurado. Você pode obter um seguindo o passo a passo contido em: [Ambientes Virtuais de Aprendizagem para o Kubernetes](../README.md)

## Com o cluster criado realize o acesso SSH no masternode.

### AWS (Caso vá utilizar AWS)

+ Recupere o IP do master node com o seguinte comando. 

```bash
aws ec2 describe-instances --filters "Name=tag:type,Values=master" --query 'Reservations[*].Instances[*].PublicIpAddress' | tr -d '[],"'
```

+ Realize o login na instancia com o seguinte comando:

```bash
ssh -i ~/.aws/labsuser.pem ubuntu@<IP_MASTERNODE>

# Substitua o <IP_MASTERNODE> pelo IP recuperado.
```

### Azure (Caso vá utilizar Azure)

```bash
az vm list-ip-addresses --resource-group kubernetes-resources -o table
```

+ Esse comando irá retornar uma tabela com as três instancias criadas para o deploy do cluster, copie somente o ip do master node.

+ Realize o login na instancia com o seguinte comando:

```bash
ssh -i ~/.ssh/azure ubuntu@<IP_MASTERNODE>

# Substitua o <IP_MASTERNODE> pelo IP recuperado.
```

---

Após ter realizado o acesso ao master node, todos os comandos a seguir serão realizado nele. Primeiro acesse como super usuario com o comando:

```bash
sudo su -
```

Pronto, agora siga o passo para realizar o deploy da aplicação.

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

```
NAME              TYPE     DATA   AGE
postgres-secret   Opaque   3      6s
```

#### Deployment Postgres

Um [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) vai ser o objeto resposavel por gerenciar um conjunto de Pods para execução de um determinado trabalho. Iremos criar um deployment que será resposavel pela execução do Pod que irá conter o container do Postgres em execução. 


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

```
NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
postgres-deployment   1/1     1            1           12s
```

#### Postgres Service

Um [Service](https://kubernetes.io/docs/concepts/services-networking/service/) é um objeto Kubernetes usado para expor uma aplicação que está executnado em um Pod do cluster.

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

```
NAME           TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
kubernetes     ClusterIP   10.96.0.1      <none>        443/TCP    121m
postgres-svc   ClusterIP   10.105.62.45   <none>        5432/TCP   4s
```

#### Criando um configmap para o nosso aplicativo.

Um [ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/) no Kubernetes é um objeto usado para armazenar configurações não sensíveis em pares chave-valor. Ele permite que você separe as configurações do seu código-fonte, facilitando a atualização e a gestão das configurações sem necessitar recompilar a aplicação. Isso é especialmente útil para gerenciar a configuração de aplicações em contêineres de forma eficiente e segura.

<details> <summary> 1. <b>AWS:</b> Caso tenha optado pela utilização da AWS. <b>(clique para exibir)</b> </summary>

```bash
cat > app-configmap.yml << EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-configmap
data:
  dabase_url: postgres-svc
EOF
```

#### Detalhes de configuração

+ **apiVersion** especifica a versão da API a ser usada para criar o ConfigMap.
+ **kind** define o tipo de recurso como ConfigMap.
+ **metadata** contém metadados sobre o ConfigMap, como o nome.
+ **data** armazena os dados do ConfigMap, onde as chaves são nomes de configuração e os valores são os dados associados. No exemplo, `dabase_url` aponta para `postgres-svc`.

Aplique essa configuração com o comando:

```bash
kubectl apply -f app-configmap.yml
```

Você pode verficiar se o configmap foi executado corretamente com o comando:

```bash
kubectl get configmap 
```

Saída:

```
NAME               DATA   AGE
app-configmap      1      29s
kube-root-ca.crt   1      123m
```

</details>

<details> <summary> 2. <b>Azure:</b> Caso tenha optado pela utilização da Azure. <b>(clique para exibir)</b> </summary>

> A Azure apresenta um problema na resolução de nomes que ainda não foi solucionado, desse modo foi pensando em uma maneira de contornar esse problema enquanto ele ainda não foi resolivdo, para isso siga as instruções abaixo:

+ Nós realizamos no passo anterior a criação de um service para o nosso banco de dados postgres, devemos então pegar o endereço IP do nosso service que aparece na saída do comando `kubectl get svc ` e colocar no local indicado no arquivos abaixo.

```bash
cat > app-configmap.yml << EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-configmap
data:
  dabase_url: IP_postgres-svc
EOF
```

#### Detalhes de configuração

+ **apiVersion** especifica a versão da API a ser usada para criar o ConfigMap.
+ **kind** define o tipo de recurso como ConfigMap.
+ **metadata** contém metadados sobre o ConfigMap, como o nome.
+ **data** armazena os dados do ConfigMap, onde as chaves são nomes de configuração e os valores são os dados associados. No exemplo, `dabase_url` aponta para `postgres-svc`.

Aplique essa configuração com o comando:

```bash
kubectl apply -f app-configmap.yml
```

Você pode verficiar se o configmap foi executado corretamente com o comando:

```bash
kubectl get configmap 
```

Saída:

```
NAME               DATA   AGE
app-configmap      1      29s
kube-root-ca.crt   1      123m
```

</details>

#### Criando um deployment para o nosso aplicativo.

```bash
cat > app-deployment.yml << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: app-python
  template:
    metadata:
      labels:
        app: app-python
    spec:
      containers:
        - name: app-python
          image: 'laaf/python-app'
          ports:
            - containerPort: 5000
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
          - name: POSTGRES_HOST
            valueFrom:
              configMapKeyRef:
                name: app-configmap
                key: dabase_url
EOF
```

Aplique essa configuração com o comando:

```bash
kubectl apply -f app-deployment.yml
```

Você pode verficiar se o configmap foi executado corretamente com o comando:

```bash
kubectl get deployment 
```

Saída:

```
NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
app-deployment        1/1     1            1           47s
postgres-deployment   1/1     1            1           4m3s
```

#### Criando um service para o nosso aplicativo.

```bash
cat > app-svc.yml << EOF
apiVersion: v1
kind: Service
metadata:
  name: app-svc
spec:
  selector:
    app: app-python
  type: NodePort
  ports:
    - protocol: TCP
      port: 5000
      targetPort: 5000
      nodePort: 30000
EOF
```

Aplique essa configuração com o comando:

```bash
kubectl apply -f app-svc.yml
```

Você pode verficiar se o configmap foi executado corretamente com o comando:

```bash
kubectl get svc
``` 

Saída:

```
NAME           TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
app-svc        NodePort    10.96.164.6    <none>        5000:30000/TCP   32s
kubernetes     ClusterIP   10.96.0.1      <none>        443/TCP          125m
postgres-svc   ClusterIP   10.105.62.45   <none>        5432/TCP         4m12s
```


### Acessando a aplicação.

+ Realize os seguintes comandos em sua **máquina local**.

<details> <summary>Caso esteja utilizando a AWS (clique para exibir)</summary>

+ Recupere o IP do master node com o seguinte comando. 

```bash
aws ec2 describe-instances --filters "Name=tag:type,Values=master" --query 'Reservations[*].Instances[*].PublicIpAddress' | tr -d '[],"'
```

+ Abra seu navegador e coloque no endereço na barra de pesquisa.

```
IP_MASTERNODE:30000
```
</details>

<details> <summary>Caso esteja utilizando a Azure (clique para exibir)</summary>

+ Execute o seguinte comando o copie o IP do worker node

```bash
az vm list-ip-addresses --resource-group kubernetes-resources -o table
```

+ Abra seu navegador e coloque no endereço na barra de pesquisa.

```
IP_WORKERNODE:30000
```

</details>


+ Você deverá visualizar a seguinte página:

![](images/pagina_inicial.webm)