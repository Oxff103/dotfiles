#!/bin/bash
#
# Init colors
# Reset
Color_off='\033[0m'       # Text Reset

# Regular Colors
Cyan='\033[0;36m'
Blue='\033[0;34m'
Red='\033[0;31m'

LOCKFILE=$PWD/dotfiles.lock

# Symlinks the configs
symlink () {
  grep "$1" $LOCKFILE 2>&1 >/dev/null
  if [ $? != 0 ]
  then
    echo $1 >> $LOCKFILE
  fi
  TARGET=$PWD/$2$1
  FILE=$HOME/.$1
  if [ -e "$FILE" ]
  then
    if file $FILE | grep $PWD &> /dev/null;then
      printf "Installed $Red$FILE${Color_off}\n"

  else
      printf "Skipping $Red$FILE${Color_off}\n"
    fi
  else
    printf "Linking $Cyan$FILE${Color_off} -> $Blue$TARGET${Color_off}\n"
    ln -s "$TARGET" "$FILE"
  fi
}

linkHiddenFile() {
  for file in `ls hiddenrc`;
  do
    symlink $file hiddenrc/
  done
}

linkFolder() {
  for file in `ls $1 | egrep -v '^(etc|share)'`;
  do
    symlink $1/$file
  done
}

main() {
  # mkdir
  if [ ! -d "$HOME/.config" ];then
    mkdir ~/.config
  fi
  # mail
  if [ ! -f ~/.msmtprc ];
  then
    cp msmtprc ~/.msmtprc
    printf "copy ${red}msmtprc to ~/.msmtprc ${color_off}\n"
    printf "you need to run chmod 0600 ~/.msmtprc after edit password\n"

  fi
  linkFolder config
  # Install hidden file to ~
  linkHiddenFile
}

main
