terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.42.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "d73c18d0-4278-43dc-b37b-b58fe35693e6"
  tenant_id       = "9f23cf0a-4a0b-499a-8f2d-7ccdc2648847"
  features {}
}

# Criando grupo de recursos
resource "azurerm_resource_group" "kubernetes-group" {
  name     = "kubernetes-resources"
  location = "West US 2"
}

# Criando VNET
resource "azurerm_virtual_network" "kubernetes-vnet" {
  name                = "kubernetesVnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.kubernetes-group.location
  resource_group_name = azurerm_resource_group.kubernetes-group.name
}

# Criando sub-rede
resource "azurerm_subnet" "kubernetes-subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.kubernetes-group.name
  virtual_network_name = azurerm_virtual_network.kubernetes-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Criando grupos de segurança
resource "azurerm_network_security_group" "ControlNodeNSG" {
  name                = "ControlNodeNSG"
  location            = azurerm_resource_group.kubernetes-group.location
  resource_group_name = azurerm_resource_group.kubernetes-group.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowKubernetesAPI"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "6443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowEtcd"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "2379-2380"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowKubelet"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "10250-10260"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 140
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 150
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "WorkerNodeNSG" {
  name                = "WorkerNodeNSG"
  location            = azurerm_resource_group.kubernetes-group.location
  resource_group_name = azurerm_resource_group.kubernetes-group.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "KubeletAPI"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "10249-10260"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "NodePort"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "30000-32768"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 130
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 140
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

# Criando endereços IP Públicos
resource "azurerm_public_ip" "master-ip" {
  name                = "master-pub-ip"
  resource_group_name = azurerm_resource_group.kubernetes-group.name
  location            = azurerm_resource_group.kubernetes-group.location
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "worker1-ip" {
  name                = "worker1-pub-ip"
  resource_group_name = azurerm_resource_group.kubernetes-group.name
  location            = azurerm_resource_group.kubernetes-group.location
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "worker2-ip" {
  name                = "worker2-pub-ip"
  resource_group_name = azurerm_resource_group.kubernetes-group.name
  location            = azurerm_resource_group.kubernetes-group.location
  allocation_method   = "Static"
}

# Criando interfaces de rede.
resource "azurerm_network_interface" "net-interface1" {
  name                = "nic1"
  location            = azurerm_resource_group.kubernetes-group.location
  resource_group_name = azurerm_resource_group.kubernetes-group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.kubernetes-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.master-ip.id
  }
}

resource "azurerm_network_interface" "net-interface2" {
  name                = "nic2"
  location            = azurerm_resource_group.kubernetes-group.location
  resource_group_name = azurerm_resource_group.kubernetes-group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.kubernetes-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.worker1-ip.id
  }
}

resource "azurerm_network_interface" "net-interface3" {
  name                = "nic3"
  location            = azurerm_resource_group.kubernetes-group.location
  resource_group_name = azurerm_resource_group.kubernetes-group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.kubernetes-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.worker2-ip.id
  }
}

# Associando as interfaces de rede ao grupo de segurança
resource "azurerm_network_interface_security_group_association" "associate1" {
  network_interface_id      = azurerm_network_interface.net-interface1.id
  network_security_group_id = azurerm_network_security_group.ControlNodeNSG.id
}

resource "azurerm_network_interface_security_group_association" "associate2" {
  network_interface_id      = azurerm_network_interface.net-interface2.id
  network_security_group_id = azurerm_network_security_group.WorkerNodeNSG.id
}

resource "azurerm_network_interface_security_group_association" "associate3" {
  network_interface_id      = azurerm_network_interface.net-interface3.id
  network_security_group_id = azurerm_network_security_group.WorkerNodeNSG.id
}

# Criando máquina virtuais linux
resource "azurerm_linux_virtual_machine" "master_node" {
  name                = "master_node"
  computer_name       = "masternode"
  resource_group_name = azurerm_resource_group.kubernetes-group.name
  location            = azurerm_resource_group.kubernetes-group.location
  size                = "Standard_D2s_v3"
  admin_username      = "ubuntu"
  network_interface_ids = [
    azurerm_network_interface.net-interface1.id
  ]

  admin_ssh_key {
    username   = "ubuntu"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "worker-node1" {
  name                = "worker_node1"
  computer_name       = "workernode1"
  resource_group_name = azurerm_resource_group.kubernetes-group.name
  location            = azurerm_resource_group.kubernetes-group.location
  size                = "Standard_D2s_v3"
  admin_username      = "ubuntu"
  network_interface_ids = [
    azurerm_network_interface.net-interface2.id
  ]

  admin_ssh_key {
    username   = "ubuntu"
    public_key = file("~/.ssh/azure.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "worker-node2" {
  name                = "worker_node2"
  computer_name       = "workernode2"
  resource_group_name = azurerm_resource_group.kubernetes-group.name
  location            = azurerm_resource_group.kubernetes-group.location
  size                = "Standard_F2s_v2"
  admin_username      = "ubuntu"
  network_interface_ids = [
    azurerm_network_interface.net-interface3.id
  ]

  admin_ssh_key {
    username   = "ubuntu"
    public_key = file("~/.ssh/azure.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}