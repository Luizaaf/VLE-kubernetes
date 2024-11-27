## [Instalando um Container Runtime](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#systemd-cgroup-driver).

O container runtime deve ser instalado em todos os nós do cluster, para que o Kubernets possa executar os Pods.

### Prerequisitos para instalação do cotainer runtime.

#### Abilitando o encaminhamento de pacotes IPV4

```
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF
```

Esse comando vai adicionar `net.ipv4.ip_forward = 1` ao final do arquivo `/etc/sysctl.d/k8s.conf`.

```
sudo sysctl --system
```

Esse comando irá aplicar a configuração sem a necessidade de reiniciar o sistema.

```
sysctl net.ipv4.ip_forward
```

Com esse comando você pode verificar se deu tudo certo.
