#!/usr/bin/env bash

# Colocar as suas configurações para o Git
EMAIL=seu-email@provedor.com
NOME="Fulano de Tal"

# Diretórios e versões de programas
JAVA_PACKAGE=oracle-java8
MYSQL=mysql-server-5.6
GIT=git

ECLIPSE=eclipse-jee-mars-1-linux-gtk-x86_64.tar.gz
ECLIPSE_URL=http://eclipse.c3sl.ufpr.br/technology/epp/downloads/release/mars/1/
ECLIPSE_MD5=72a722a59a43e8ed6c47ae279fb3d355
ECLIPSE_LAUNCHER=/usr/share/applications/eclipse.desktop

MAVEN=apache-maven-3.3.9-bin.tar.gz
MAVEN_URL=http://ftp.unicamp.br/pub/apache/maven/maven-3/3.3.9/binaries/
MAVEN_MD5=516923b3955b6035ba6b0a5b031fbd8b

JAVA_HOME=/opt/java
ECLIPSE_HOME=$JAVA_HOME/eclipse
MAVEN_HOME=$JAVA_HOME/$(echo $MAVEN | cut -d"-" -f1-3)

# Instala o Java 8
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get -y update
sudo echo ${JAVA_PACKAGE}-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt-get -y install ${JAVA_PACKAGE}-installer

# Instala suporte ao VirtualBox no Linux
sudo apt-get install -y virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11

# Instala o ambiente gráfico Unity/GNOME
#sudo apt-get install -y ubuntu-desktop
sudo apt-get -y install alsa-base alsa-utils anacron baobab dmz-cursor-theme doc-base eog evince file-roller fonts-dejavu-core fonts-freefont-ttf gedit gnome-screenshot gnome-system-log gnome-system-monitor gnome-terminal gvfs-bin indicator-application indicator-appmenu indicator-datetime indicator-messages indicator-power indicator-session indicator-sound inputattach libatk-adaptor libnotify-bin libpam-ck-connector libsdl1.2debian lightdm nautilus notify-osd pulseaudio seahorse ssh-askpass-gnome ttf-ubuntu-font-family ubuntu-artwork ubuntu-drivers-common ubuntu-session ubuntu-settings ubuntu-sounds ubuntu-system-service unity unity-control-center unity-greeter unity-lens-applications unity-lens-files unity-scope-home xdg-user-dirs xdg-user-dirs-gtk xdiagnose xorg yelp zeitgeist
#sudo apt-get install -y ubuntu-desktop --no-install-recommends
#sudo apt-get install -y unity synaptic acpi-support gnome-terminal ttf-ubuntu-font-family overlay-scrollbar unity-webapps-common
sudo echo "allowed_users=anybody" > /etc/X11/Xwrapper.config

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

# Instala o Eclipse JEE
if ! [ -f $JAVA_HOME/$ECLIPSE ]; then
  # Faz o download do arquivo, verifica o md5, descompacta e remove o arquivo
  while true
  do
    sudo wget --progress=bar:force -O $JAVA_HOME/$ECLIPSE $ECLIPSE_URL/$ECLIPSE
    sudo tar xvfz $JAVA_HOME/$ECLIPSE -C $JAVA_HOME
    md5=$(sudo md5sum $JAVA_HOME/$ECLIPSE | cut -d" " -f1)
    if [ "$md5" == "$ECLIPSE_MD5" ]; then
      sudo rm $JAVA_HOME/$ECLIPSE
      break;
    fi
  done

  # Cria um atalho para o launcher
  sudo echo "[Desktop Entry]" >> $ECLIPSE_LAUNCHER
  sudo echo "Type=Application" >> $ECLIPSE_LAUNCHER
  sudo echo "Name=Eclipse" >> $ECLIPSE_LAUNCHER
  sudo echo "Comment=Eclipse Integrated Development Environment" >> $ECLIPSE_LAUNCHER
  sudo echo "Icon=/opt/java/eclipse/icon.xpm" >> $ECLIPSE_LAUNCHER
  sudo echo "Exec=/opt/java/eclipse/eclipse" >> $ECLIPSE_LAUNCHER
  sudo echo "Terminal=false" >> $ECLIPSE_LAUNCHER
  sudo echo "Categories=Development;IDE;Java;" >> $ECLIPSE_LAUNCHER
  sudo echo "StartupWMClass=Eclipse" >> $ECLIPSE_LAUNCHER

  # instala o launcher do Eclipse
  sudo dbus-launch --exit-with-session gsettings set com.canonical.Unity.Launcher favorites "['application://gnome-terminal.desktop', 'application://nautilus.desktop', 'application://firefox.desktop', 'application://eclipse.desktop', 'application://unity-control-center.desktop', 'unity://running-apps', 'unity://expo-icon', 'unity://devices']"

fi

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

# Configura o teclado para o padrão ABNT-2
sudo dbus-launch --exit-with-session gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'br'), ('xkb', 'us')]"

# Inicia o ambiente gráfico
sudo service lightdm start
