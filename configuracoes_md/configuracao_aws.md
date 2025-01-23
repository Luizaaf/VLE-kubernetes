## Configurando o AWS CLI

+ Acesse o AWS Academy.

![](images/console_aws.png)

1. Após ter acesso o AWS academy e iniciado seu laborátorio irá clicar em `AWS Details`, e baixe sua chave de acesso.

![](images/baixando_chave.png)

2. Após isso clique em `AWS CLI: Show`, copie o conteúdo que irá aparecer.

![](images/baixando_show.png)

3. Após isso execute os seguintes comandos em seu terminal.

```bash
# Crie o diretório de configuração do AWS CLI
mkdir ~/.aws

# Crie o arquivo de configuração do AWS CLI
cat > ~/.aws/config << EOF
[default]
region = us-east-1
output = json
EOF
```

4. Após isso você irá colar o conteúdo copiado no passo 2 no arquivo `~/.aws/credentials`

![](images/colando_arquivo.gif)

5. A ferramenta espera que a chave de acesso esteja em `~/.aws/`, para funcionar corretamente, então por favor copie a chave de acesso baixada no passo para `~/.aws` e dê as permissões necessárias com o seguinte comando.

```bash
# Comando para dar as permissões necessárias.
chmod 0600 ~/.aws/labsuser.pem
```

> [!IMPORTANT]
> Toda vez que você iniciar uma sessão no AWS Academy, suas credenciais irão ser alteradas, desse modo você precisar copiar seus dados e colar novamente em ~/.aws/credentials.