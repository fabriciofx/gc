# Instalação e Configuração do Ambiente de Desenvolvimento em Java 8

## 1. Instalação

1.1 Instale o [VirtualBox](https://www.virtualbox.org/wiki/Downloads)  
1.2 Instale o [VirtualBox Extension Pack](https://www.virtualbox.org/wiki/Downloads)  
1.3 Instale o [Vagrant](https://www.vagrantup.com/downloads.html)

## 2. Configuração

2.1 Crie um diretório que hospedará os arquivos de configuração
(por exemplo: `ambiente-java64`)
```
$ mkdir ambiente-java64
```
2.2 Crie o arquivo de configuração (`Vagrantfile`) da VM do Vagrant
```
$ vagrant init
```
2.3 Edite o arquivo `Vagrantfile` de acordo com as suas necessidades
```
$ start notepad Vagrantfile
```
2.4 Sugestão de configuração para o Vagrantfile
```ruby
```
