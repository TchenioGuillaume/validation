#!/bin/bash

echo "Verification des logiciel installer ... "
echo ""
dpkg -l | grep vagrant    #verifie si Vagrant est insatalle
echo "--- Vagrant est installer ---"
echo ""
dpkg -l | grep virtualbox   #verifie si Virtualbox est insatalle
echo "--- Virtualbox est installer ---"
echo ""
echo "Que voulez vous faire : "
echo "1) vous souhaitez installer une nouvelle Vagrant "
echo "2) vous souhaitez demarrer la Vagrant existante  "
echo "3) vous souhaitez éteindre votre Vagrant "
echo "4) voir la liste des machines "
echo "5) voir les machines allume et interagir avec"
echo "6) Vous souhaitez quitter "
read rep

#si on tape 1
if [[ "$rep" == "1" ]]; then
  echo "entrer votre box (ex:ubuntu/xenial64)"
  read box
  if [ "$box" != "" ]
  then
    # box valide
    echo "entrer le nom de votre folder (ex:./data)"
    read folder
    if [ "$folder" != "" ]
    then
      # folder valide
      echo "entrer le nom de votre synced folder (ex:/var/www/html)"
      read syncedFolder
      if [ "$syncedFolder" != "" ]
      then
        # synced_folder valide
        echo "Votre box $box"
        echo "Nom du dossier distant $folder"
        echo "Nom du dossier distant $syncedFolder"
        echo "Validation (y/n)?"
        read valide

        if [ "$valide" == "y" ]
        then
          # L'user a valider
          mkdir vagrant #crée un dossier "vagrant"
          cd vagrant  #va dans le dossier "vagrant"
          mkdir $folder #crée un dossier en fonction du nom entrer
          vagrant init  #ca crée un Vagrantfile que l'on va pouvoir configurer
          #a partir de la on modifie certaine ligne de "Vagrantfile"
          sed -i -r 's~.*config.vm.box =.*~ config.vm.box = "'$box'"~g' Vagrantfile
          sed -i -r 's~.*config.vm.network "private_network".*~ config.vm.network "private_network", ip: "192.168.33.10"~g' Vagrantfile
          sed -i -r 's~.*config.vm.synced_folder.*~ config.vm.synced_folder "'$folder'", "'$syncedFolder'"~g' Vagrantfile
          sed -i -r 's~.*config.vm.provision.*~ config.vm.provision "shell", inline: <<-SHELL~g' Vagrantfile
        fi
      fi
    fi
  fi
fi

#si on tape 2
if [[ "$rep" == "2" ]]; then
  clear
  echo "J'allume votre machine"
  cd vagrant
  vagrant up  #allume la vagrant
  echo ""
  echo "Voici la liste des machines"
  vagrant global-status #liste des machines
  echo ""
  echo "Voici les machines allume"
  vagrant global-status | grep "running"    #liste uniquement les machines qui sont alllumer
fi

#si on tape 3
if [[ "$rep" == "3" ]]; then
  clear
  echo "J'etein votre machine"
  cd vagrant
  vagrant halt  #etein la vagrant
  cd ../
fi

#si on tape 4
if [[ "$rep" == "4" ]]; then
  clear
  echo "--- Voici la liste des machines ---"
  vagrant global-status   #liste des machines
  echo ""
  echo "--- Voici les machines allume ---"
  vagrant global-status | grep "running"    #liste uniquement les machines qui sont alllumer
fi

#si on tape 5
if [[ "$rep" == "5" ]]; then
  clear
  echo "--- Voici les machines allume ---"
  vagrant global-status | grep "running"    #liste uniquement les machines qui sont alllumer
  echo ""
  echo ""
  echo "Voulez interagir avec les machines allume"
  echo "1) Oui"
  echo "2) Non"
  read interagir
  if [[ "$interagir" == "1" ]]; then
    echo "Enter l'ID de la vagrant que vous voulez eteindre"
    read id
    vagrant halt $id
  fi
  if [[ "$interagir" == "2" ]]; then
    exit
  fi
fi

#si on tape 6
if [[ "$rep" == "6" ]]; then
  clear
  echo "Pourquoi ? T'es con ! Bon ba ..."
  echo "Ce fut un plaisir. By gros !! "
  exit
fi
