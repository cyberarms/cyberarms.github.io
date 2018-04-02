#!/bin/bash

clear

echo -e "\e[97mWelcome to CyberArms! Please choose what you want to do.\n\n\t\e[32m1.\e[97m Run the software page generator (arsenal)\n\t\e[32m2.\e[97m Run the media page generator (snowflake)\n\t\e[36m3.\e[97m Update the CyberArms install\n\t\e[91m4.\e[97m Uninstall CyberArms\n\t\e[32m5.\e[97m Exit the script (Type '"'cyberarms'"' without quotes into your terminal to run again) \nPlease enter your selection (\e[32m1\e[97m, \e[32m2\e[97m, \e[36m3\e[97m, \e[91m4\e[97m, or \e[32m5\e[97m):"
wait
read choice
wait

while [ "$choice" != 1 ] && [ "$choice" != 2 ] && [ "$choice" != 3 ] && [ "$choice" != 4 ] && [ "$choice" != 5 ]; do
	echo -e "\e[97mWelcome to CyberArms! Please choose what you want to do.\n\n\t\e[32m1.\e[97m Run the software page generator (arsenal)\n\t\e[32m2.\e[97m Run the media page generator (snowflake)\n\t\e[36m3.\e[97m Update the CyberArms install\n\t\e[91m4.\e[97m Uninstall CyberArms\n\t\e[32m5.\e[97m Exit the script (Type '"'cyberarms'"' without quotes into your terminal to run again) \nPlease enter your selection (\e[32m1\e[97m, \e[32m2\e[97m, \e[36m3\e[97m, \e[91m4\e[97m, or \e[32m5\e[97m):"
	wait
	read choice
	wait
done



if [ "$choice" = 1 ]; then
	wait
	capage
	wait

elif [ "$choice" = 2 ]; then
	wait
	casnowflake
	wait

elif [ "$choice" = 3 ]; then
	wait
	caupdate
	wait

elif [ "$choice" = 4 ]; then
	wait
	cauninstall
	wait

elif [ "$choice" = 5 ]; then
	wait
	exit 0
	break
	wait

else
	echo -e "\e[31mSelection failed; please exit and try again."

fi

echo -e "\e[97mFinished"

