#!/bin/bash

clear

echo -e "\e[97mWelcome to the CyberArms setup script! This downloads and installs the CyberArms tools and their dependencies to your system.\nFor more info, please see the site at \e[36mhttps://cyberarms.gq\e[97m.\nThis script is copyright 2017 The Archivist and the CyberArms Project.\n\nChecking for root...\n\e[0m"

rm -f setup.sh
echo &> 963274680250243.log >> /963274680250243_test.txt
if [ -e /963274680250243_test.txt ]; then
  echo -e "\e[32mRoot get success!\e[0m\n"
  rm -f /963274680250243_test.txt
  rm -f 963274680250243.log
else
  echo -e "\e[91mRoot get failed! Please re-run with sudo and try again.\e[0m\n"
  rm -f /963274680250243_test.txt
  rm -f 963274680250243.log
  exit 1
fi

echo -e "\e[97mChecking for neccessary dependencies...\e[0m\n"

function program_is_installed {
  # set to 1 initially
  local return_=1
  # set to 0 if not found
  type "$1" >/dev/null 2>&1 || { local return_=0; }
  # return value
  echo "$return_"
}

#Check if jq is installed
jq=$(program_is_installed jq)

#Check if curl is installed
curl=$(program_is_installed curl)

#Check if ouo.io is installed
zip=$(program_is_installed 7z)

git=$(program_is_installed git)

mo=$(program_is_installed mo)

uname=$(uname -s)

if [ "$uname" = "Darwin*" ]; then
  #List missing dependencies; continue if all dependencies installed
  if [ "$jq" = 1 ] && [ "$curl" = 1 ] && [ "$zip" = 1 ] && [ "$git" = 1 ] && [ "$mo" = 1 ]; then
    echo -e "\e[32mAll dependencies are installed, congratulations! Let's continue.\e[0m\n"
    :
  else
    echo -e "\e[31mThe following dependencies are missing: \e[0m\n\n"

    if [ "$jq" = 0 ]; then
      :
    else
      echo -e "\e[31mjq\e[0m\n"
    fi

    if [ "$curl" = 0 ]; then
      :
    else
      echo -e "\e[31mcurl\e[0m\n"
    fi

    if [ "$zip" = 0 ]; then
      :
    else
      echo -e "\e[31m7-zip\e[0m\n\n"
    fi

    if [ "$git" = 0 ]; then
      :
    else
      echo -e "\e[31mgit\e[0m\n\n"
    fi

    if [ "$mo" = 0 ]; then
      :
    else
      echo -e "\e[31mmo\e[0m\n\n"
    fi

    #Try to install missing packages
    echo -e "\e[36mDo you want to try to install missing packages?\n(y\\3\bn): "
    read fixmissing

    while [[ ( $fixmissing != "y" && $fixmissing != "n" ) ]]
    do
      echo -e "Invalid input; try again.\n\nDo you want to try to install missing packages?\n(y\\3\bn): "
      read fixmissing
    done

    echo -e "\e[0m"

    if [ "$fixmissing" = "y" ]; then
        echo -e "\e[37m"

        brew=$(program_is_installed brew)
        if [ "$brew" = 1 ]; then
          #Install brew
          /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" $> /dev/null
        fi

        brew tap caskroom/cask < /dev/null

        if [ "$jq" = 0 ]; then
          :
        else
          brew install jq < /dev/null
        fi

        if [ "$zip" = 0 ]; then
          :
        else
          brew install p7zip < /dev/null
        fi

        if [ "$curl" = 0 ]; then
          :
        else
          brew install curl < /dev/null
        fi

        if [ "$git" = 0 ]; then
          :
        else
          brew install git < /dev/null
        fi

        if [ "$mo" = 0 ]; then
          :
        else
          curl -sSO https://raw.githubusercontent.com/tests-always-included/mo/master/mo
          chmod +x mo
          mv mo /usr/bin/mo
        fi

        echo -e "\e[0m"

    else
      echo -e "\e[35mYou will need to install missing dependencies yourself.\nPlease install missing dependencies then re-run the script.\n\e[0m"
      exit
    fi
fi


else
  #List missing dependencies; continue if all dependencies installed
  if [ "$jq" = 1 ] && [ "$curl" = 1 ] && [ "$zip" = 1 ] && [ "$git" = 1 ] && [ "$mo" = 1 ]; then
    echo -e "\e[32mAll dependencies are installed, congratulations! Let's continue.\e[0m\n"
    :
  else

    echo -e "\e[31mThe following dependencies are missing: \e[0m\n\n"

    if [ "$jq" = 1 ]; then
      :
    else
      echo -e "\e[31mjq\e[0m\n"
    fi

    if [ "$curl" = 1 ]; then
      :
    else
      echo -e "\e[31mcurl\e[0m\n"
    fi

    if [ "$zip" = 1 ]; then
      :
    else
      echo -e "\e[31m7-zip\e[0m\n"
    fi

    if [ "$git" = 1 ]; then
      :
    else
      echo -e "\e[31mgit\e[0m\n"
    fi

    if [ "$mo" = 1 ]; then
      :
    else
      echo -e "\e[31mmo\e[0m\n"
    fi

    #Try to install missing packages
    echo -e "\e[36mDo you want to try to install missing packages?\n(y\\3\bn): "
    read fixmissing

    while [[ ( "$fixmissing" != "y" && "$fixmissing" != "n" ) ]]
    do
      echo -e "Invalid input; try again.\n\nDo you want to try to install missing packages?\n(y\\3\bn): "
      read fixmissing
    done

    echo -e "\e[0m"

    if [ "$fixmissing" = "y" ]; then
      echo -e "\e[36m\nHow do you want to install missing packages?\n\t1. Apt (for Debian-based systems)\n\t2. Linuxbrew (for non-Debian-based systems)\n(1 or 2): "
      read aptorbrew

      while [[ ( "$aptorbrew" != 1 && "$aptorbrew" != 2 ) ]]
      do
        echo -e "Invalid input; try again.\n\nHow do you want to install missing packages?\n\t1. Apt (for Debian-based systems)\n\t2. Linuxbrew (for non-Debian-based systems)\n(1 or 2): "
        read aptorbrew
      done

      if [ "$aptorbrew" = 1 ]; then
        echo -e "\e[37m"
        sudo apt-get -y update
        wait
        sudo apt-get -y upgrade
        wait

        if [ "$jq" = 1 ]; then
          :
        else
          sudo apt-get install -y jq
        fi

        if [ "$zip" = 1 ]; then
          :
        else
          sudo apt-get install -y p7zip p7zip-full
        fi

        if [ "$curl" = 1 ]; then
          :
        else
          sudo apt-get install -y curl
        fi

        if [ "$git" = 1 ]; then
          :
        else
          sudo apt-get install -y git
        fi

        if [ "$mo" = 1 ]; then
          :
        else
          curl -sSO https://raw.githubusercontent.com/tests-always-included/mo/master/mo
          chmod +x mo
          mv mo /usr/bin/mo
        fi
        echo -e "\e[0m"
      else

        function rbinstall {
          if [ "$1" = 'curl' ]; then

            clear
            echo -e "\e[97mInstalling Ruby, please wait... (This may take a few minutes)\n\e[37mDownloading Ruby\e[0m\n"
            echo -ne "\e[97m[  1% - #................................................. ]\r"
            curl -o ruby-2.4.2.tar.gz https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.2.tar.gz &> /dev/null
            clear
            echo -e "\e[97mInstalling Ruby, please wait... (This may take a few minutes)\n\e[37mExtracting Ruby\e[0m\n"
            echo -ne "\e[97m[  2% - #................................................. ]\r"
            echo -ne "\e[97m[  3% - ##................................................ ]\r"
            echo -ne "\e[97m[  4% - ##................................................ ]\r"
            echo -ne "\e[97m[  5% - ###............................................... ]\r"
            gunzip ruby-2.4.2.tar.gz &> /dev/null
            echo -ne "\e[97m[  6% - ###............................................... ]\r"
            echo -ne "\e[97m[  7% - ####.............................................. ]\r"
            echo -ne "\e[97m[  8% - ####.............................................. ]\r"
            tar -xvf ruby-2.4.2.tar &> /dev/null
            echo -ne "\e[97m[  9% - #####............................................. ]\r"
            echo -ne "\e[97m[ 10% - #####............................................. ]\r"
            cd ruby-2.4.2
            echo -ne "\e[97m[ 11% - ######............................................ ]\r"
            clear
            echo -e "\e[97mInstalling Ruby, please wait... (This may take a few minutes)\n\e[37mConfiguring Ruby\e[0m\n"
            make distclean
            autoconf
            ./configure &> /dev/null
            echo -ne "\e[97m[ 12% - ######............................................ ]\r"
            echo -ne "\e[97m[ 13% - #######........................................... ]\r"
            echo -ne "\e[97m[ 14% - #######........................................... ]\r"
            echo -ne "\e[97m[ 15% - ########.......................................... ]\r"
            echo -ne "\e[97m[ 16% - ########.......................................... ]\r"
            echo -ne "\e[97m[ 17% - #########......................................... ]\r"
            echo -ne "\e[97m[ 18% - #########......................................... ]\r"
            echo -ne "\e[97m[ 19% - ##########........................................ ]\r"
            echo -ne "\e[97m[ 20% - ##########........................................ ]\r"
            echo -ne "\e[97m[ 21% - ###########....................................... ]\r"
            echo -ne "\e[97m[ 22% - ###########....................................... ]\r"
            echo -ne "\e[97m[ 23% - ############...................................... ]\r"
            echo -ne "\e[97m[ 24% - ############...................................... ]\r"
            echo -ne "\e[97m[ 25% - #############..................................... ]\r"
            echo -ne "\e[97m[ 26% - #############..................................... ]\r"
            echo -ne "\e[97m[ 27% - ##############.................................... ]\r"
            echo -ne "\e[97m[ 28% - ##############.................................... ]\r"
            clear
            echo -e "\e[97mInstalling Ruby, please wait... (This may take a few minutes)\n\e[37mCompiling Ruby\e[0m\n"
            make &> /dev/null
            echo -ne "\e[97m[ 30% - ################.................................. ]\r"
            echo -ne "\e[97m[ 32% - #################................................. ]\r"
            echo -ne "\e[97m[ 34% - ##################................................ ]\r"
            echo -ne "\e[97m[ 36% - ###################............................... ]\r"
            echo -ne "\e[97m[ 38% - ####################.............................. ]\r"
            echo -ne "\e[97m[ 40% - #####################............................. ]\r"
            echo -ne "\e[97m[ 44% - #######################........................... ]\r"
            echo -ne "\e[97m[ 48% - #########################......................... ]\r"
            echo -ne "\e[97m[ 52% - ###########################....................... ]\r"
            echo -ne "\e[97m[ 56% - #############################..................... ]\r"
            echo -ne "\e[97m[ 60% - ###############################................... ]\r"
            echo -ne "\e[97m[ 68% - ###################################............... ]\r"
            echo -ne "\e[97m[ 76% - #######################################........... ]\r"
            echo -ne "\e[97m[ 83% - ###########################################....... ]\r"
            clear
            echo -e "\e[97mInstalling Ruby, please wait... (This may take a few minutes)\n\e[37mInstalling Ruby\e[0m\n"
            sudo make install &> /dev/null
            echo -ne "\e[97m[ 84% - ###########################################....... ]\r"
            echo -ne "\e[97m[ 85% - ############################################...... ]\r"
            echo -ne "\e[97m[ 86% - ############################################...... ]\r"
            echo -ne "\e[97m[ 87% - ##############################################.... ]\r"
            echo -ne "\e[97m[ 88% - ##############################################.... ]\r"
            echo -ne "\e[97m[ 90% - ##############################################.... ]\r"
            echo -ne "\e[97m[ 92% - ##############################################.... ]\r"
            echo -ne "\e[97m[ 94% - ##############################################.... ]\r"
            echo -ne "\e[97m[ 96% - ##############################################.... ]\r"
            clear
            echo -e "\e[97mInstalling Ruby, please wait... (This may take a few minutes)\n\e[37mCleaning up\e[0m\n"
            sleep 1
            echo -ne "\e[97m[ 97% - ###############################################... ]\r"
            sleep 1
            echo -ne "\e[97m[ 98% - ################################################.. ]\r"
            sleep 1
            echo -ne "\e[97m[ 99% - #################################################. ]\r"
            cd ..
            echo -ne "\e[97m[100% - ################################################## ]\r\e[0m"

          else

            echo -e "\e[97mInstalling Ruby, please wait... (This may take a few minutes)\e[0m\n"
            echo -ne "\e[97m[  1% - #................................................. ]\r"
            wget https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.2.tar.gz &> /dev/null
            clear
            echo -e "\e[97mInstalling Ruby, please wait... (This may take a few minutes)\n\e[37mExtracting Ruby\e[0m\n"
            echo -ne "\e[97m[  2% - #................................................. ]\r"
            echo -ne "\e[97m[  3% - ##................................................ ]\r"
            echo -ne "\e[97m[  4% - ##................................................ ]\r"
            echo -ne "\e[97m[  5% - ###............................................... ]\r"
            gunzip ruby-2.4.2.tar.gz &> /dev/null
            echo -ne "\e[97m[  6% - ###............................................... ]\r"
            echo -ne "\e[97m[  7% - ####.............................................. ]\r"
            echo -ne "\e[97m[  8% - ####.............................................. ]\r"
            tar -xvf ruby-2.4.2.tar &> /dev/null
            echo -ne "\e[97m[  9% - #####............................................. ]\r"
            echo -ne "\e[97m[ 10% - #####............................................. ]\r"
            cd ruby-2.4.2
            echo -ne "\e[97m[ 11% - ######............................................ ]\r"
            clear
            echo -e "\e[97mInstalling Ruby, please wait... (This may take a few minutes)\n\e[37mConfiguring Ruby\e[0m\n"
            autoconf
            ./configure &> /dev/null
            echo -ne "\e[97m[ 12% - ######............................................ ]\r"
            echo -ne "\e[97m[ 13% - #######........................................... ]\r"
            echo -ne "\e[97m[ 14% - #######........................................... ]\r"
            echo -ne "\e[97m[ 15% - ########.......................................... ]\r"
            echo -ne "\e[97m[ 16% - ########.......................................... ]\r"
            echo -ne "\e[97m[ 17% - #########......................................... ]\r"
            echo -ne "\e[97m[ 18% - #########......................................... ]\r"
            echo -ne "\e[97m[ 19% - ##########........................................ ]\r"
            echo -ne "\e[97m[ 20% - ##########........................................ ]\r"
            echo -ne "\e[97m[ 21% - ###########....................................... ]\r"
            echo -ne "\e[97m[ 22% - ###########....................................... ]\r"
            echo -ne "\e[97m[ 23% - ############...................................... ]\r"
            echo -ne "\e[97m[ 24% - ############...................................... ]\r"
            echo -ne "\e[97m[ 25% - #############..................................... ]\r"
            echo -ne "\e[97m[ 26% - #############..................................... ]\r"
            echo -ne "\e[97m[ 27% - ##############.................................... ]\r"
            echo -ne "\e[97m[ 28% - ##############.................................... ]\r"
            clear
            echo -e "\e[97mInstalling Ruby, please wait... (This may take a few minutes)\n\e[37mCompiling Ruby\e[0m\n"
            make &> /dev/null
            echo -ne "\e[97m[ 30% - ################.................................. ]\r"
            echo -ne "\e[97m[ 32% - #################................................. ]\r"
            echo -ne "\e[97m[ 34% - ##################................................ ]\r"
            echo -ne "\e[97m[ 36% - ###################............................... ]\r"
            echo -ne "\e[97m[ 38% - ####################.............................. ]\r"
            echo -ne "\e[97m[ 40% - #####################............................. ]\r"
            echo -ne "\e[97m[ 44% - #######################........................... ]\r"
            echo -ne "\e[97m[ 48% - #########################......................... ]\r"
            echo -ne "\e[97m[ 52% - ###########################....................... ]\r"
            echo -ne "\e[97m[ 56% - #############################..................... ]\r"
            echo -ne "\e[97m[ 60% - ###############################................... ]\r"
            echo -ne "\e[97m[ 68% - ###################################............... ]\r"
            echo -ne "\e[97m[ 76% - #######################################........... ]\r"
            echo -ne "\e[97m[ 83% - ###########################################....... ]\r"
            clear
            echo -e "\e[97mInstalling Ruby, please wait... (This may take a few minutes)\n\e[37mInstalling Ruby\e[0m\n"
            sudo make install &> /dev/null
            echo -ne "\e[97m[ 84% - ###########################################....... ]\r"
            echo -ne "\e[97m[ 85% - ############################################...... ]\r"
            echo -ne "\e[97m[ 86% - ############################################...... ]\r"
            echo -ne "\e[97m[ 87% - ##############################################.... ]\r"
            echo -ne "\e[97m[ 88% - ##############################################.... ]\r"
            echo -ne "\e[97m[ 90% - ##############################################.... ]\r"
            echo -ne "\e[97m[ 92% - ##############################################.... ]\r"
            echo -ne "\e[97m[ 94% - ##############################################.... ]\r"
            echo -ne "\e[97m[ 96% - ##############################################.... ]\r"
            clear
            echo -e "\e[97mInstalling Ruby, please wait... (This may take a few minutes)\n\e[37mCleaning up\e[0m\n"
            sleep 1
            echo -ne "\e[97m[ 97% - ###############################################... ]\r"
            sleep 1
            echo -ne "\e[97m[ 98% - ################################################.. ]\r"
            sleep 1
            echo -ne "\e[97m[ 99% - #################################################. ]\r"
            cd ..
            echo -ne "\e[97m[100% - ################################################## ]\r\e[0m"
            
          fi
        }


        curl=$(program_is_installed curl)
        wget=$(program_is_installed wget)
        ruby=$(program_is_installed ruby)

        if [ "$ruby" = 1 ]; then
          if [ "$curl" = 1 ]; then
            rbinstall curl
          else
            rbinstall wget
          fi
        fi


        brew=$(program_is_installed brew)
        if [ "$brew" = 1 ]; then
          clear
          echo -e "\e[97mInstalling Linuxbrew...\n\e[37mDownloading...\e[0m\n"
          echo -ne "\e[97m[  1% - #................................................. ]\r"
          sleep 1
          echo -ne "\e[97m[  2% - #................................................. ]\r"
          sleep 1
          echo -ne "\e[97m[  3% - ##................................................ ]\r"
          sleep 1
          echo -ne "\e[97m[  4% - ##................................................ ]\r"
          sleep 1
          echo -ne "\e[97m[  5% - ###............................................... ]\r"
          sleep 1
          echo -ne "\e[97m[  6% - ###............................................... ]\r"
          clear
          echo -e "\e[97mInstalling Linuxbrew...\n\e[37mCompiling and Setting Up...\e[0m\n"
          ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"  < /dev/null
          echo -ne "\e[97m[  7% - ####.............................................. ]\r"
          echo -ne "\e[97m[  8% - ####.............................................. ]\r"
          echo -ne "\e[97m[  9% - #####............................................. ]\r"
          echo -ne "\e[97m[ 10% - #####............................................. ]\r"
          sleep 1
          echo -ne "\e[97m[ 11% - ######............................................ ]\r"
          echo -ne "\e[97m[ 12% - ######............................................ ]\r"
          echo -ne "\e[97m[ 14% - #######........................................... ]\r"
          echo -ne "\e[97m[ 16% - ########.......................................... ]\r"
          echo -ne "\e[97m[ 18% - #########......................................... ]\r"
          sleep 1
          echo -ne "\e[97m[ 20% - ##########........................................ ]\r"
          echo -ne "\e[97m[ 24% - ###########....................................... ]\r"
          echo -ne "\e[97m[ 28% - ##############.................................... ]\r"
          sleep 1
          echo -ne "\e[97m[ 32% - ################.................................. ]\r"
          sleep 2
          echo -ne "\e[97m[ 36% - ###################............................... ]\r"
          echo -ne "\e[97m[ 40% - ######################............................ ]\r"
          echo -ne "\e[97m[ 48% - ##########################........................ ]\r"
          echo -ne "\e[97m[ 56% - #############################..................... ]\r"
          sleep 2
          echo -ne "\e[97m[ 64% - #################################................. ]\r"
          echo -ne "\e[97m[ 72% - ######################################............ ]\r"
          clear
          echo -e "\e[97mInstalling Linuxbrew...\n\e[37mInstalling...\e[0m\n"
          test -d ~/.linuxbrew && PATH="$HOME/.linuxbrew/bin:$PATH"
          test -d /home/linuxbrew/.linuxbrew && PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
          test -r ~/.bash_profile && echo 'export PATH="$(brew --prefix)/bin:$PATH"' >>~/.bash_profile
          echo 'export PATH="$(brew --prefix)/bin:$PATH"' >>~/.profile
          echo -ne "\e[97m[ 80% - ##########################################........ ]\r"
          echo -ne "\e[97m[ 88% - #############################################..... ]\r"
          echo -ne "\e[97m[ 90% - ##############################################.... ]\r"

          clear
          echo -e "\e[97mInstalling Linuxbrew...\n\e[37mUpdating Brew...\e[0m\n"
          brew update &> /dev/null
          echo -ne "\e[97m[ 92% - ###############################################... ]\r"
          sleep 3
          echo -ne "\e[97m[ 96% - ################################################.. ]\r"
          clear
          echo -e "\e[97mInstalling Linuxbrew...\n\e[37mFinishing Up...\e[0m\n"
          brew doctor &> /dev/null
          echo -ne "\e[97m[ 98% - #################################################. ]\r"
          sleep 1
          echo -ne "\e[97m[100% - ################################################## ]\r"
          echo -e "\n\e[37mBrew Installation Finished!\e[0m\n"
        fi

        echo -e "\e[37m"
        if [ "$jq" = 1 ]; then
          :
        else
          brew install jq
        fi

        if [ "$zip" = 1 ]; then
          :
        else
          brew install p7zip
        fi

        if [ "$curl" = 1 ]; then
          :
        else
          brew install curl
        fi

        if [ "$git" = 1 ]; then
          :
        else
          brew install git
        fi

        if [ "$mo" = 0 ]; then
          :
        else
          curl -sSO https://raw.githubusercontent.com/tests-always-included/mo/master/mo
          chmod +x mo
          mv mo /usr/bin/mo
        fi
        echo -e "\e[0m"        
      fi

    else
      echo -e "\e[35mYou will need to install missing dependencies yourself.\nPlease install missing dependencies then re-run the script.\n\e[0m"
      exit
    fi
  fi

fi

echo -e "\e[97mPlease enter your Openload.co API login (you will need to register an account):\n\e[90m"
read OPENAPILOGIN

echo -e "\n\e[97mPlease enter your Openload.co API key:\n\e[90m"
read OPENAPIKEY

echo -e "\e[0m"

sudo echo "OPENAPILOGIN=""$OPENAPILOGIN" >> /etc/environment
sudo echo "OPENAPIKEY=""$OPENAPIKEY" >> /etc/environment

source /etc/environment

echo -e "\e[97mInstalling CyberArms, please wait...\e[0m\n"

function copy_n_clean {
  rm -rf CyberArms cyberarms.github.io outfiles ca /cyberarms &> /dev/null
  rm -f out.log clean.sh cyberarms.sh install.sh page.sh snowflake.sh uninstall.sh /usr/bin/capage /usr/bin/casnowflake /usr/bin/caclean /usr/bin/casetup /usr/bin/cyberarms &> /dev/null
  git clone https://github.com/TheArsenal/cyberarms.github.io.git
  mv cyberarms.github.io-master cyberarms.github.io &> /dev/null
  chmod -R +rwx cyberarms.github.io &> /dev/null
  cp cyberarms.github.io/bin/page.sh /usr/bin/capage
  cp cyberarms.github.io/bin/snowflake.sh /usr/bin/casnowflake
  cp cyberarms.github.io/bin/clean.sh /usr/bin/caclean
  cp cyberarms.github.io/bin/setup.sh /usr/bin/casetup
  cp cyberarms.github.io/bin/cyberarms.sh /usr/bin/cyberarms
  cp -r cyberarms.github.io /cyberarms
}

function installerer{
  sudo curl -sLo /usr/bin/cyberarms https://cyberarms.gq/cyberarms/bin/cyberarms.sh &> /dev/null
  sudo curl -sLo /usr/bin/capage https://cyberarms.gq/cyberarms/bin/page.sh &> /dev/null
  sudo curl -sLo /usr/bin/casnowflake https://cyberarms.gq/cyberarms/bin/snowflake.sh &> /dev/null
  sudo curl -sLo /usr/bin/cauninstall https://cyberarms.gq/cyberarms/bin/snowflake.sh &> /dev/null
  sudo mkdir /cyberarms &> /dev/null
  sudo curl -sLo /cyberarms/tv.mo https://cyberarms.gq/cyberarms/templates/tv.mo &> /dev/null
  sudo curl -sLo /cyberarms/book.mo https://cyberarms.gq/cyberarms/templates/book.mo &> /dev/null
  sudo curl -sLo /cyberarms/movie.mo https://cyberarms.gq/cyberarms/templates/movie.mo &> /dev/null
  sudo curl -sLo /cyberarms/game.mo https://cyberarms.gq/cyberarms/templates/game.mo &> /dev/null
  sudo curl -sLo /cyberarms/music.mo https://cyberarms.gq/cyberarms/templates/music.mo &> /dev/null
}

copy_n_clean -R 2>/dev/null

echo -e "\e[32mThe arsenal script has been successfully set up.\nRun command \e[0m\e[36m"""cyberarms"""\e[0m\e[32m (without quotes) to use it.\nThanks, \n\e[33m\t~The Archivist~\e[0m\n"
echo -e "\e[35mBye!\e[0m"
exit 0;
