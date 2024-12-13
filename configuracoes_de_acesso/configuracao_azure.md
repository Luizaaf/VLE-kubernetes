### Criando conta na Azure for Students.

1. **Acesse o site https://azure.microsoft.com/pt-br/free/students**

![](images/site_azure.png)

2. **Acesse sua conta microssoft colocando usuário e senha. Caso não possua crie uma.**

![](images/acessar_conta.png)

3. **Preencha o questionário com seu nome, sobrenome, país de origem, universidade, data de nascimento e email institucional.**

![](images/questionario_01.png)
![](images/questionario_02.png)

4. **Realize a verificação do email institucional.**

![](images/verificacao_email.png)

5. **Após isso você será redirecionado para uma página que irá testar se você é realmente humano. Realize o teste e siga para a proxima página.**

![](images/teste_logico.png)

6. **Aceite os termos e pronto, você terá 100 USD para gastar como quiser na Azure.**

![](images/termos_de_uso.png)

### Configurando a Azure para uso da ferramenta.

+ **Execute o seguinte comando para logar em seu navegador padrão.**

```
az login
```

![](images/login_azure.png)

+ **Será apresentado essa saída em seu terminal**

![](images/azure_tenant.png)

+ **Copie seu `subscription_id` e `tenant_id` para o arquivo que se encontra em infraestrutura/azure/main.tf**

![](images/tenant_tf.png)