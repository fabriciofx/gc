#!/usr/bin/env bash

# Colocar as suas configurações para o Git
EMAIL=seu-email@provedor.com
NOME="Fulano de Tal"

# Diretórios e versões de programas
JAVA_PACKAGE=oracle-java8
MYSQL=mysql-server-5.6
GIT=git

MAVEN=apache-maven-3.3.9-bin.tar.gz
MAVEN_URL=http://ftp.unicamp.br/pub/apache/maven/maven-3/3.3.9/binaries/
MAVEN_MD5=516923b3955b6035ba6b0a5b031fbd8b

JAVA_HOME=/opt/java
MAVEN_HOME=$JAVA_HOME/$(echo $MAVEN | cut -d"-" -f1-3)

# Instala o Java 8
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get -y update
sudo echo ${JAVA_PACKAGE}-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt-get -y install ${JAVA_PACKAGE}-installer

# Instala suporte ao VirtualBox no Linux
sudo apt-get install -y virtualbox-guest-dkms virtualbox-guest-utils

# Instala o MySQL
sudo apt-get -y install $MYSQL

# Instala e configura o Git
sudo apt-get -y install $GIT
echo "[user]" >> /home/vagrant/.gitconfig
echo -e "\temail = $EMAIL\n" >> /home/vagrant/.gitconfig
echo -e "\tname = $NAME\n" >> /home/vagrant/.gitconfig
echo "[push]" >> /home/vagrant/.gitconfig
echo -e "\tdefault = matching\n" >> /home/vagrant/.gitconfig

# Remove os pacotes baixados e instalados
sudo apt-get -y clean
sudo apt-get -y autoclean

# Cria o diretório HOME das ferramentas Java de desenvolvimento
sudo mkdir -p $JAVA_HOME

# Instala o maven
if ! [ -f $JAVA_HOME/$MAVEN ]; then
  while true
  do
    sudo wget --progress=bar:force -O $JAVA_HOME/$MAVEN $MAVEN_URL/$MAVEN
    sudo tar xvfz $JAVA_HOME/$MAVEN -C $JAVA_HOME
    md5=$(sudo md5sum $JAVA_HOME/$MAVEN | cut -d" " -f1)
    if [ "$md5" == "$MAVEN_MD5" ]; then
      sudo rm $JAVA_HOME/$MAVEN
      break;
    fi
  done

  echo "export MAVEN_HOME=$MAVEN_HOME" >> /etc/profile.d/maven.sh
  echo "export PATH=\$PATH:\$MAVEN_HOME/bin" >> /etc/profile.d/maven.sh
fi

# Configura o timezone
sudo timedatectl set-timezone America/Recife
