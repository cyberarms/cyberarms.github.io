#!/bin/bash

clear

#The main uploading and shortlinking function
function upload_n_in {
	echo -e "\e[90m"

	rm -f linkz.txt moezlinkz.txt fileiolinkz.txt openloadlinkz.txt

	echo -e "Mixtape.moe Linkz:\n" >> moezlinkz.txt
	echo -e "\nTeknik.io Linkz:" >> fileiolinkz.txt
	echo -e "\nOpenload.co Linkz (Use this one only if the others are broken; it has ads):" >> openloadlinkz.txt

	upfiler_decide

	cat fileiolinkz.txt >> moezlinkz.txt
	cat openloadlinkz.txt >> moezlinkz.txt
	cp moezlinkz.txt linkz.txt

	ixio=$(cat linkz.txt | curl -F 'f:1=<-' ix.io)
	ixio=$(curl "http://ouo.io/api/TwSUIAqX?s=""$ixio")
	sprunge=$(cat linkz.txt | curl -F 'sprunge=<-' http://sprunge.us)
	sprunge=$(curl "http://ouo.io/api/TwSUIAqX?s=""$sprunge")

	rm fileiolinkz.txt moezlinkz.txt openloadlinkz.txt linkz.txt

	return 0
}

function upfiler_decide {
	if [ "$numvols" > 1 ]; then
		upfiler_multi
	else
		upfiler
	fi
	return 0
}
function upfiler {
		while [ "$numvols" != 0 ]
		do
			i=1
			#The moe part
			echo -e "\n\e[37mUploading to mixtape.moe...\e[90m"
			str="moe""$i"
			eval $str=$(curl --progress-bar -sf -F files[]="@$outFile" "https://mixtape.moe/upload.php" | jq -r '.files[].url')
			echo -e "${!str}\n" >> moezlinkz.txt

			#The file.io part
			echo -e "\n\e[37mUploading to teknik.io...\e[90m"
			str="file""$i"
			eval "$str"=$(curl --progress-bar -F "file=@$outFile" https://api.teknik.io/v1/Upload | jq -r '.result.url')
			wait
			echo -e "${!str}\n" >> fileiolinkz.txt

			#The openload.co part
			echo -e "\n\e[37mUploading to openload.co...\e[90m"
			str="open""$i"
			openupurl=$(curl --silent https://api.openload.co/1/file/ul? | jq -r '.result.url')
			eval "$str"=$(curl --progress-bar -F file1=@"$outFile" "$openupurl")
			echo -e "${!str}\n" >> openloadlinkz.txt

			(( i=$i-1 ))
			(( numvols=$numvols-1 ))

			return 0
		done
}

function upfiler_multi {
		j=$numvols
		i=1
		while [ "$i" -le "$j" ]
		do
			outFile="$noxtension"".7z"".00""$i"
			#The moe part
			echo -e "\n\e[37mUploading part ""$i"" of""$j"" to mixtape.moe...\e[90m"
			str="moe""$i"
			eval $str=$(curl --progress-bar -sf -F files[]=@"$outFile" "https://mixtape.moe/upload.php")
			echo -e "part ""$i"": ""${!str}\n" >> moezlinkz.txt

			#The file.io part
			echo -e "\n\e[37mUploading part ""$i"" of""$j"" to file.io...\e[90m"
			str="file""$i"
			eval "$str"=$(curl --progress-bar -F "file=@$outFile" https://api.teknik.io/v1/Upload | jq -r '.result.url')
			wait
			echo -e "part ""$i"": ""${!str}\n" >> fileiolinkz.txt

			#The openload.co part
			echo -e "\n\e[37mUploading part ""$i"" of""$j"" to openload.co...\e[90m"
			str="open""$i"
			openupurl=$(curl --progress-bar https://api.openload.co/1/file/ul? | jq -r '.result.url')
			eval "$str"=$(curl -F file1=@"$outFile" "$openupurl" | jq -r '.result.url')
			echo -e "part ""$i"": ""${!str}\n" >> openloadlinkz.txt

			(( i=$i+1 ))

			return 0
		done
}

#Function to check if the file exists
function exists {
	while [ ! -f "$outFile" ]
	do
		echo -e "\n\e[31mFile does not exist! Please try again.\n\n\\e[93m\n\nPlease enter the path to the file, e.g. Tor Browser.\e[33m \n\e[94m"
		read outFile
		wait
	done

	return 0
}

#Function to check if input is y or n
function yin {
        a=$1

        while [[ "$a" != "y" && "$a" != "n" ]]
        do
        	echo -e "\n\e[37mInvalid input!\n\e[93m(y\\3\bn): \e[90m"
        	read a
        	set -- "$a"
        	echo $1 &> /dev/null
		done
}

function varin {
		while read a ; do echo ${a//<\!-- "$1"1 -->/<li>} ; done < "$pagename".html > "$pagename".html.t ; mv "$pagename".html.t "$pagename".html
		while read a ; do echo ${a//<\!-- "$1"2 -->/Download: \( "$2"\) \(\<a href="$ixio">Mirror 1\</a>\) \(\<a href="$sprunge">Mirror 2\</a>\)} ; done < "$pagename".html > "$pagename".html.t ; mv "$pagename".html.t "$pagename".html
		while read a ; do echo ${a//<\!-- "$1"3 -->/</li>} ; done < "$pagename".html > "$pagename".html.t ; mv "$pagename".html.t "$pagename".html
}

function zip_n_split {
	#Get the file size of the input
	chrlen=${#outFile}
	uncut=$(wc -c "$outFile")
	chrlen=$((chrlen+1))
	cut=${uncut::-chrlen}

	#7-zip to 99mb volumes if greater then 99
	if [ "$cut" -gt 99000000 ]; then
		noxtension=$(echo $outFile | cut -f 1 -d '.')
		rm -f "$noxtension".7z*
		echo -e "\n\e[37mCompressing, please wait...\e[90	m\n"
		7z a -v99m "$noxtension".7z "$outFile" &> /dev/null
		numvols=$(7z l "$noxtension".7z | grep "Volumes" | echo "${numvols:10}")
		echo $numvols
		# export ${numvols}="$numvol"
	else
		numvols=1
		return 0
	fi
}

clear

#Read details of the software and wirte to various vars
echo -e "\e[97mWelcome to the CyberArms page generation script!\nThis script automates the creation of new \e[36msoftware\e[97m pages and the uploading/shortlinking of the files.\nFor more info, please see the site at \e[36mhttp://cyberarms.gq\e[97m.\nThis script is copyright 2017 The Archivist and the CyberArms Project."

echo -e "\e[93m\n\nPlease enter the name of the software, e.g. Tor Browser.\e[33m"
read softname
echo -e "\e[93mPlease enter a reasonably short (a few paragraphs at most), accurate, and detailed description of the software, if possible from the website, forum post, etc. from which the software originated.\e[33m"
read softdetails
echo -e "\e[93mPlease enter the software's source URL: website, forum post, etc. Please be sure to preface the URL with http(s)://\e[33m"
read softsite
echo -e "\e[93mPlease enter a file name for the web page. Rules:\n\n\t1. It should be one-worded\n\t2. It should have no spaces\n\t3. It should have no special characters or capital letters.\n\nExample: tor for Tor Browser, boson for Boson Binder.\e[33m"
read pagename
echo -e "\n\n\e[93mAre these details correct?\n\n\t\e[33m$softname\n\t$softdetails\n\t$softsite\n\t$pagename"
echo -e  "\e[93m\n(y\\3\bn): "
read correct
wait
yin $correct
wait

while [ "$correct" = "n" ]
do
	echo -e "\e[36mPlease reenter the details."
	echo -e "\e[93m\n\nPlease enter the name of the software, e.g. Tor Browser.\e[33m"
	read softname
	echo -e "\e[93mPlease enter a reasonably short (a few paragraphs at most), accurate, and detailed description of the software, if possible from the website, forum post, etc. from which the software originated.\e[33m"
	read softdetails
	echo -e "\e[93mPlease enter the software's source URL: website, forum post, etc. Please be sure to preface the URL with http(s)://\e[33m"
	read softsite
	echo -e "\e[93mPlease enter a file name for the web page. Rules:\n\n\t1. It should be one-worded\n\t2. It should have no spaces\n\t3. It should have no special characters or capital letters.\n\nExample: tor for Tor Browser, boson for Boson Binder.\e[33m"
	read pagename
	echo -e "\n\n\e[93mAre these details correct?\n\n\t\e[33m$softname\n\t$softdetails\n\t$softsite\n\t$pagename"
	echo -e  "\e[93m\n(y\\3\bn): "
	read correct
	yin $correct
done

echo -e "\e[94m\nDoes the software have a Windows version?\n(y\\3\bn): \e[94m"
read win

#Move a copy of the template to the appropriately named file
cp /cyberarms/templates/template.html ./"$pagename".html

#Replace the placeholder fields in the template with the proper software data

while read a ; do echo ${a//tItle/"$softname"} ; done < "$pagename".html > "$pagename".html.t ; mv "$pagename".html.t "$pagename".html
while read a ; do echo ${a//d3scripshun/"$softdetails"} ; done < "$pagename".html > "$pagename".html.t ; mv "$pagename".html.t "$pagename".html
while read a ; do echo ${a//w3bsiteurl/"$softsite"} ; done < "$pagename".html > "$pagename".html.t ; mv "$pagename".html.t "$pagename".html
while read a ; do echo ${a//webbsite/"$softsite"} ; done < "$pagename".html > "$pagename".html.t ; mv "$pagename".html.t "$pagename".html
while read a ; do echo ${a//s0ftnam3/"$softname"} ; done < "$pagename".html > "$pagename".html.t ; mv "$pagename".html.t "$pagename".html

#Check if their is a windows version.
	#If so, check if their are seperate 32 and 64-bit versions
		#If their are
			#upload the 32 and 64-bit files to hosters
			#shortlink the file hoster links
			#fill the resultant links into the page in seperate 32 and 64-bit fields
		#If not
			#upload the files to hosters
			#shortlink the file hoster links
			#fill the resultant links into the page

yin $win

if [ "$win" = "y" ]; then
	echo -e "\e[94m\nAre there seperate 32 and 64-bit versions of this software?\n(y\\3\bn): \e[94m"
	read winsep
	yin $winsep

	if [ "$winsep" = "y" ]; then
		echo -e "\e[94m\nPlease enter the path to the 32-bit file, e.g. /home/jdoe/Downloads/tor.exe: \n\e[94m"
		read outFile

		exists

		echo -e "\e[90m"

		zip_n_split

		upload_n_in

		#Replace the filler lines in the template with the proper program downloads.
		varin ifwin "Windows 32-bit"



		echo -e "\e[94m\nPlease enter the path to the 64-bit file, e.g. /home/jdoe/Downloads/tor.exe: \n\e[94m"
		read outFile

		#Check that the file exists
		exists

		zip_n_split

		#Upload and shortlink
		upload_n_in

		#Replace the filler lines in the template with the proper program downloads.
		#while read a ; do echo ${a//foo/bar} ; done < "$pagename".html > "$pagename".html.t ; mv "$pagename".html.t "$pagename".html
		varin ifwin64 "Windows 64-bit"



	else
		echo -e "\e[94m\nPlease enter the path to the file, e.g. /home/jdoe/Downloads/tor.exe: \n\e[94m"
		read outFile

		exists

		echo -e "\e[90m"

		zip_n_split

		upload_n_in

		#Replace the filler lines in the template with the proper program downloads.
		#while read a ; do echo ${a//foo/bar} ; done < "$pagename".html > "$pagename".html.t ; mv "$pagename".html.t "$pagename".html
		varin ifwin "Windows"

	fi
else
	:
fi



echo -e "\e[94mDoes the software have an OsX version?\n(y\\3\bn): \e[94m"
read osx
yin $osx

if [ "$osx" = "y" ]; then
	echo -e "\e[94mAre there seperate 32 and 64-bit versions of this software?\n(y\\3\bn): \e[94m"
	read osxsep

		while [[ "$osxsep" != "y" && "$osxsep" != "n" ]]
	do
		echo -e "\n\e[31mInvalid input!\n(y\\3\bn): \e[94m"
		read osxsep
	done

	if [ "$osxsep" = "y" ]; then
		echo -e "\e[94mPlease enter the path to the 32-bit file, e.g. /home/jdoe/Downloads/tor.exe: \n\e[94m"
		read outFile

		exists

		echo -e "\e[90m"
		
		zip_n_split

		upload_n_in

		#Replace the filler lines in the template with the proper program downloads.
		#while read a ; do echo ${a//foo/bar} ; done < "$pagename".html > "$pagename".html.t ; mv "$pagename".html.t "$pagename".html
		varin ifosx "OsX 32-bit"


		echo -e "\e[94mPlease enter the path to the 64-bit file, e.g. /home/jdoe/Downloads/tor.exe: \n\e[94m"
		read outFile

		exists

		echo -e "\e[90m"

		zip_n_split

		upload_n_in

		#Replace the filler lines in the template with the proper program downloads.
		#while read a ; do echo ${a//foo/bar} ; done < "$pagename".html > "$pagename".html.t ; mv "$pagename".html.t "$pagename".html
		varin ifosx64 "OsX 64-bit"



	else
		echo -e "\e[94mPlease enter the path to the file, e.g. /home/jdoe/Downloads/tor.exe: \n\e[94m"
		read outFile

		exists

		echo -e "\e[90m"

		zip_n_split
		
		upload_n_in

		#Replace the filler lines in the template with the proper program downloads.
		#while read a ; do echo ${a//foo/bar} ; done < "$pagename".html > "$pagename".html.t ; mv "$pagename".html.t "$pagename".html
		varin ifosx "Osx"
	fi
else
	:
fi



echo -e "\e[94mDoes the software have a linux version?\n(y\\3\bn): \e[94m"
read linux
yin $linux

if  [ "$linux" = "y" ]; then
	echo -e "\e[94mAre there seperate 32 and 64-bit versions of this software?\n(y\\3\bn): \e[94m"
	read linuxsep

	while [[ "$linuxsep" != "y" && "$linuxsep" != "n" ]]
	do
		echo -e "\n\e[31mInvalid input!\n(y\\3\bn): \e[94m"
		read linuxsep
	done

	if [ "$linuxsep" = "y" ]; then
		echo -e "\e[94mPlease enter the path to the 32-bit file, e.g. /home/jdoe/Downloads/tor.exe: \n\e[94m"
		read outFile

		exists

		echo -e "\e[90m"

		zip_n_split
		
		upload_n_in

		#Replace the filler lines in the template with the proper program downloads.
		#while read a ; do echo ${a//foo/bar} ; done < "$pagename".html > "$pagename".html.t ; mv "$pagename".html.t "$pagename".html
		varin iflinux "Linux 32-bit"



		echo -e "\e[94mPlease enter the path to the 64-bit file, e.g. /home/jdoe/Downloads/tor.exe: \n\e[94m"
		read outFile

		exists

		echo -e "\e[90m"

		zip_n_split
		
		upload_n_in

		#Replace the filler lines in the template with the proper program downloads.
		#while read a ; do echo ${a//foo/bar} ; done < "$pagename".html > "$pagename".html.t ; mv "$pagename".html.t "$pagename".html
		varin iflinux64 "Linux 64-bit"



	else
		echo -e "\e[94mPlease enter the path to the file, e.g. /home/jdoe/Downloads/tor.exe: \n\e[94m"
		read outFile

		exists

		echo -e "\e[90m"

		zip_n_split
		
		upload_n_in

		#Replace the filler lines in the template with the proper program downloads.
		#while read a ; do echo ${a//foo/bar} ; done < "$pagename".html > "$pagename".html.t ; mv "$pagename".html.t "$pagename".html
		varin iflinux "Linux"

	fi
fi



echo -e "\e[94mDoes the software have available source code?\n(y\\3\bn): \e[94m"
read source
yin $source

if [ "$source" = "y" ]; then
  echo -e "\e[94mPlease enter the path to the file, e.g. /home/jdoe/Downloads/tor.exe: \n\e[94m"
  read outFile
  wait

  exists

  echo -e "\e[90m"

  zip_n_split
  
  upload_n_in

  #Replace the filler lines in the template with the proper program downloads.
  #while read a ; do echo ${a//foo/bar} ; done < "$pagename".html > "$pagename".html.t ; mv "$pagename".html.t "$pagename".html
  varin ifsource "Source code"

else
	:
fi



#filler1
#filler2
#filler3
#filler4
#filler5
#filler6

mkdir outfiles outfiles/software outfiles/movies outfiles/tv outfiles/books outfiles/music outfiles/games &> /dev/null
mv "$pagename".html "$PWD"/outfiles/software/"$pagename.html"
rm test.js &> /dev/null
echo -e "\n\e[32mYou have successfully createa a page for the \e[36m$softname\e[32m software.\nThe output has been written to \e[36m"$PWD"/outfiles/software/"$pagename".html\e[32m.\nNow, please contact  \e[33m~The Archivist~\e[32m (see \e[96mcyberarms.gq/contact.html\e[32m for instructions) and submit the page for review.\nIf approved, it will be added to the site.\nThank you for your contribution! Please continue to help.\n\t\e[35mBye!\n\n"

