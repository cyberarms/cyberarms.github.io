#!/bin/bash
#Read details of the software and wirte to various vars

clear

function upload_n_in {
	echo -e "\e[90m"

	rm -f linkz.txt moezlinkz.txt tekniklinkz.txt openloadlinkz.txt

	echo -e "Mixtape.moe Linkz:\n" >> moezlinkz.txt
	echo -e "\nTeknik.io Linkz:" >> tekniklinkz.txt
	echo -e "\nOpenload.co Linkz (Use this one only if the others are broken; it has ads):" >> openloadlinkz.txt

	upfiler_decide

	cat tekniklinkz.txt >> moezlinkz.txt
	cat openloadlinkz.txt >> moezlinkz.txt
	cp moezlinkz.txt linkz.txt
	echo -e "\n\e[37mUploading the link file to ix.io...\e[90m"
	ix=$(cat linkz.txt | curl --progress-bar -F 'f:1=<-' ix.io)
	ixio=$(curl --silent "http://ouo.io/api/TwSUIAqX?s=""$ix")
	echo -e "\n\e[37mUploading the link file to sprunge.us...\e[90m"
	sprun=$(cat linkz.txt | curl --progress-bar -F 'clbin=<-' https://clbin.com)
	sprunge=$(curl --silent "http://ouo.io/api/TwSUIAqX?s=""$sprun")
	echo -e "\n\e[37mFinishing up...\e[90m"
	nix=$(curl --progress-bar -F 'text=<-' http://nixpaste.lbr.uno < linkz.txt)
	echo "$nix" > nixfil
	scrypt enc -P nixfil nixfil.enc <<< cyberarms
	xxd nixfil.enc nixfil.hex
	b64 -e nixfil.hex nixfil.b64
	nixenc=$(cat nixfil.b64)
	


	# 	rm fileiolinkz.txt moezlinkz.txt openloadlinkz.txt linkz.txt

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
			#The moe part
			echo -e "\n\e[37mUploading to mixtape.moe...\e[90m"
			str="moe""$i"
			moestr=$(curl --progress-bar -F files[]="@$outFile" "https://mixtape.moe/upload.php" | jq -r '.files[].url')
			echo -e "$moestr" >> moezlinkz.txt

			#The openload.co part
			echo -e "\n\e[37mUploading to openload.co...\e[90m"
			str="open""$i"
			
			# Old, non-remote upload
			openupurl=$(curl --silent https://api.openload.co/1/file/ul? | jq -r '.result.url')
			openstr=$(curl --progress-bar -g -X POST -F "file1=@$outFile" "$openupurl" | jq -r '.result.url')

			# New, remote upload
			# opendat=$(curl --progress-bar -F login="$OPENAPILOGIN" -F key="$OPENAPIKEY" -F url="$moestr" https://api.openload.co/1/remotedl/add?)
			# opendatout=$(echo "$opendat" | jq '.result.id' -r)
			# openstat=$(curl -s -F login="$OPENAPILOGIN" -F key="$OPENAPIKEY" -F id="$opendatout" https://api.openload.co/1/remotedl/status?)
			# openstatout=$(echo "$openstat" | jq '.result[].url' -r)

			echo -e "$openstr" >> openloadlinkz.txt

			# The teknik.io part
			echo -e "\n\e[37mUploading to teknik.io...\e[90m"
			teknik="file""$i"
			teknikstr=$(curl --progress-bar -F file=@"$outFile" https://api.teknik.io/v1/Upload | jq -r '.result.url')
			wait
			echo -e "$teknikstr" >> tekniklinkz.txt

			return 0
}

function upfiler_multi {
		j="$numvols"
		i=1
		while [ "$i" -le "$j" ]
		do
			if [ "$i" -le 9 ]; then
				outFile="$file"".7z"".00""$i"
			elif [ "$i" -ge 10 ] && [ "$i" -le 99 ]; then
				outFile="$file"".7z"".0""$i"
			else
				outFile="$file"".7z"".""$i"
			fi
			echo "$outFile"
			#The moe part
			echo -e "\n\e[37mUploading to mixtape.moe...\e[90m"
			str="moe""$i"
			moestr=$(curl --progress-bar -F files[]="@$outFile" "https://mixtape.moe/upload.php" | jq -r '.files[].url')
			echo -e "$moestr" >> moezlinkz.txt

			#The openload.co part
			echo -e "\n\e[37mUploading to openload.co...\e[90m"
			str="open""$i"
			
			# Old, non-remote upload
			openupurl=$(curl --silent https://api.openload.co/1/file/ul? | jq -r '.result.url')
			openstr=$(curl --progress-bar -g -X POST -F "file1=@$outFile" "$openupurl" | jq -r '.result.url')
			
			# New, remote upload
			# opendat=$(curl --progress-bar -F login="$OPENAPILOGIN" -F key="$OPENAPIKEY" -F url="$moestr" https://api.openload.co/1/remotedl/add?)
			# opendatout=$(echo "$opendat" | jq '.result.id' -r)
			# openstat=$(curl -s -F login="$OPENAPILOGIN" -F key="$OPENAPIKEY" -F id="$opendatout" https://api.openload.co/1/remotedl/status?)
			# openstatout=$(echo "$openstat" | jq '.result[].url' -r)

			echo -e "$openstr" >> openloadlinkz.txt

			# The teknik.io part
			echo -e "\n\e[37mUploading to teknik.io...\e[90m"
			teknik="file""$i"
			teknikstr=$(curl --progress-bar -F file=@"$outFile" https://api.teknik.io/v1/Upload | jq -r '.result.url')
			wait
			echo -e "$teknikstr" >> tekniklinkz.txt

			echo -e "\n\e[90m"

			(( i="$i"+1 ))
		done
}

#Function to check if the file exists
function exists {
	while [ ! -f "$outFile" ]
	do
		echo -e "\n\e[93mFile does not exist! Please try again.\e[33m"
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
		file="${noxtension##*/}"
		echo -e "\n\e[37mCompressing, please wait...\e[90	m\n"
		7z -v99m -mx=0 a "$file".7z "$outFile" &> /dev/null
		numvols=$(7z l "$file.7z.001" | grep "Volumes" | tr -dc '0-9')
	else
		numvols=1
		return 0
	fi
}
clear

# lookup table for id
table[1]="Movie"
table[2]="TV Show"
table[3]="Game"
table[4]="Music"
table[5]="Book"

echo -e "\e[97mWelcome to the CyberArms page generation script!\nThis script automates the creation of new \e[36mmedia\e[97m pages and the uploading/shortlinking of the files.\nFor more info, please see the site at \e[36mhttp://cyberarms.gq\e[97m.\nThis script is copyright 2017 The Archivist and the CyberArms Project.\n"

echo -e "\e[93mAvailable media types:\n\n\t\e[32m1.\e[93m Movie\n\t\e[33m2.\e[93m TV Show\n\t\e[34m3.\e[93m Game\n\t\e[35m4.\e[93m Music\n\t\e[36m5.\e[93m Book\n\nPlease enter your selection (\e[32m1\e[93m, \e[33m2\e[93m, \e[34m3\e[93m, \e[35m4\e[93m, or \e[36m5\e[93m):\e[33m"	
read mediatype

while [[ "$mediatype" != 1 && "$mediatype" != 2 && "$mediatype" != 3 && "$mediatype" != 4 && "$mediatype" != 5 ]]
do
	echo -e "\e[31m\nInvalid input!\n\e[93mAvailable media types:\n\n\t\e[32m1.\e[93m Movie\n\t\e[33m2.\e[93m TV Show\n\t\e[34m3.\e[93m Game\n\t\e[35m4.\e[93m Music\n\t\e[36m5.\e[93m Book\n\nPlease enter your selection (\e[32m1\e[93m, \e[33m2\e[93m, \e[34m3\e[93m, \e[35m4\e[93m, or \e[36m5\e[93m):\e[33m"	
	read mediatype
done

echo -e "\e[93m\nMedia type: ${table[$mediatype]}\n\nIs this correct?\n"
echo -e  "\n(y\\3\bn): \e[33m"
read correct
while [[ "$correct" != "y" && "$correct" != "n" ]]
do
	echo -e "\e[31m\nInvalid input!\e[93m\n(y\\3\bn): \e[33m"
	read correct
done

while [ "$correct" = "n" ]
do
	echo -e "\e[93mAvailable media types:\n\n\t\e[32m1.\e[93m Movie\n\t\e[33m2.\e[93m TV Show\n\t\e[34m3.\e[93m Game\n\t\e[35m4.\e[93m Music\n\t\e[36m5.\e[93m Book\n\nPlease enter your selection (\e[32m1\e[93m, \e[33m2\e[93m, \e[34m3\e[93m, \e[35m4\e[93m, or \e[36m5\e[93m):\e[33m"	
	read mediatype

	while [[ "$mediatype" != 1 && "$mediatype" != 2 && "$mediatype" != 3 && "$mediatype" != 4 && "$mediatype" != 5 ]]
	do
		echo -e "\e[31mInvalid input!\n\e[93mAvailable media types:\n\n\t\e[32m1.\e[93m Movie\n\t\e[33m2.\e[93m TV Show\n\t\e[34m3.\e[93m Game\n\t\e[35m4.\e[93m Music\n\t\e[36m5.\e[93m Book\n\nPlease enter your selection (\e[32m1\e[93m, \e[33m2\e[93m, \e[34m3\e[93m, \e[35m4\e[93m, or \e[36m5\e[93m):\e33m"	
		read mediatype
	done

	echo -e "\e[93m\nMedia type: ${table[$mediatype]}\n\nIs this correct?\n"
	echo -e  "\n(y\\3\bn): \e[33m"
	read correct
	while [[ "$correct" != "y" && "$correct" != "n" ]]
	do
		echo -e "\e[31mInvalid input!\e[93m\n(y\\3\bn):\e[33m "
		read correct
	done
done












if [ "$mediatype" = 1 ]
then












		echo -e "\e[33mPlease enter the movie title, e.g. Suicide Squad.\e[33m"
		read movname
		echo -e "\e[33mPlease enter the movie's rating.\e[33m"
		read movrating
		echo -e "\e[33mPlease enter the movie's genre."
		read movgenre
		echo -e "\e[33mPlease enter the IMDB page url of the movie (be sure to include the http(s) prefix)."
		read movurl
		echo -e "\e[33mPlease enter a file name for the web page. Rules:\n\n\t1. It should be one-worded\n\t2. It should have no spaces\n\t3. It should have no special characters or capital letters.\n\nExample: gots07e07 for Game of Thrones Season 7 Episode 7, suicidesquad for Suicide Squad.\e[33m"
		read pagename
		echo -e "\e[33mPlease enter the codec used to encode the movie, i.e. h.265"
		read movcodec
		echo -e "\nAre these details correct?\n\n\t\e[33m$movname\n\t$movrating\n\t$movgenre\n\t$movurl\n\t$movcodec\n\t$pagename\n\e[93m\n(y\\3\bn): "
		read correct
		while [[ "$correct" != "y" && "$correct" != "n" ]]
		do
			echo -e "\e[31mInvalid input!\e[93m\n(y\\3\bn): "
			read correct
		done
		while [ "$correct" != "y" ]
		do
			echo -e "\e[33mPlease enter the movie title, e.g. Suicide Squad.\e[33m"
			read movname
			echo -e "\e[33mPlease enter the movie's rating.\e[33m"
			read movrating
			echo -e "\e[33mPlease enter the movie's genre."
			read movgenre
			echo -e "\e[33mPlease enter the IMDB page url of the movie (be sure to include the http(s) prefix)."
			read movurl
			echo -e "\e[33mPlease enter a file name for the web page. Rules:\n\n\t1. It should be one-worded\n\t2. It should have no spaces\n\t3. It should have no special characters or capital letters.\n\nExample: gots07e07 for Game of Thrones Season 7 Episode 7, suicidesquad for Suicide Squad.\e[33m"
			read pagename
			echo -e "\e[33mPlease enter the codec used to encode the movie, e.g. HEVC"
			read movcodec
			echo -e "\nAre these details correct?\n\n\t\e[33m$movname\n\t$movrating\n\t$movgenre\n\t$movurl\n\t$movcodec\n\t$pagename\n"
			echo -e  "\e[93m\n(y\\3\bn): "
			read correct
			while [[ "$correct" != "y" && "$correct" != "n" ]]
			do
				echo -e "\e[31mInvalid input!\nAre these details correct?\n\n\t\e[33m$movname\n\t$movrating\n\t$movgenre\n\t$movurl\n\t$movcodec\n\t$pagename\n\e[93m\n(y\\3\bn): "
				read correct
			done
		done

			cp /cyberarms/snowmovietemp.html ./"$pagename".html
			while read a ; do echo "${a//t14tiil/$movname}" ; done < "$pagename".html > "$pagename".html.t ; mv "$pagename".html.t "$pagename".html
			while read a ; do echo "${a//r4t3d/$movrating}" ; done < "$pagename".html > "$pagename".html.t ; mv "$pagename".html.t "$pagename".html
			while read a ; do echo "${a//g3nr3/$movgenre}" ; done < "$pagename".html > "$pagename".html.t ; mv "$pagename".html.t "$pagename".html
			while read a ; do echo "${a//3y33md33b33/$movurl}" ; done < "$pagename".html > "$pagename".html.t ; mv "$pagename".html.t "$pagename".html
			while read a ; do echo "${a//3nc0d1ng/$movcodec}" ; done < "$pagename".html > "$pagename".html.t ; mv "$pagename".html.t "$pagename".html


			echo -e "\e[94m\nPlease enter the path to the movie file, e.g. /home/jdoe/Downloads/suicide_squad_x265.mp4: \n\e[34m"
			read outFile

			while [ ! -f "$outFile" ]
			do
				echo -e "\n\e[31mFile does not exist! Please try again.\n\n\e[94m\nPlease enter the path to the movie file, e.g. /home/jdoe/Downloads/suicide_squad_x265.mp4: \n\e[34m"
				read outFile
				wait
			done


			upload_n_in
			echo "$outFile".html













elif [ "$mediatype" = 2 ]
then












			echo "TV Show"
			echo -e "\e[96mRules:\n\n\t1. Please submit only full seasons if possible.\n\t2. Ranking of types: BluRay/BDRip > WEB-DL ≅ WEB-Rip > HDTV/PDTV/DSRip >DVDRip > DVD-5/DVD-9/DVD-R > DVD SCR/BD SCR/Screener > Telesync > CAMRip.\n\t3. Please submit the highest available type.\n\t4. Videos may be encoded only once (from lossless footage) if possible.\n\t5. Order of codecs: HEVC > h.264 > VP9 > AV1. No DivX. No XviD. No WMV. \n\t5. Maximize compatability with platforms (without sacrificing quality and size). \n\t6. No burned in subtitles (included is okay but only if they can be disabled).\n\t\e[95mIf your submission does not comply with these rules, it won't be accepted, so please make sure that it does!"
			echo -e "\n\e[93mPlease enter the title of the game, e.g. 2 Broke Girls.\e[33m"
			read name
			echo -e "\n\e[93mPlease enter the season number.\e[33m"
			read season
			echo -e "\e[93mPlease enter the description (MUST BE ALL ON ONE LINE; GOOGLE '"'text to one line'"'!).\e[33m"
			read description
			echo -e "\e[93mPlease a URL at which the TV Show can be purchased.\e[33m"
			read site
			echo -e "\e[93mPlease enter the TV Show's rating.\e[33m"
			read rating
			echo -e "\e[93mPlease enter the TV Show's genre.\e[33m"
			read genre
			echo -e "\e[93mPlease enter the IMDB page url of the movie (be sure to include the http(s) prefix).\e[33m"
			read imdb
			echo -e "\e[93mPlease enter the codec used to encode the TV Show, e.g. HEVC"
			read codec
			echo -e "\e[93mPlease enter a file name for the web page. Rules:\n\n\t1. It should be one-worded\n\t2. It should have no spaces\n\t3. It should have no special characters or capital letters.\n\nExample: 2brokegirls for 2 Broke Girls.\e[33m"
			read pagename
			echo -e "\n\e[93mAre these details correct?\n\n\t\e[93mName:\e[33m "$name"\n\t\e[93mSeason:\e[33m "$season"\n\t\e[93mBlurb:\e[33m "$description"\n\t\e[93mPurchase link:\e[33m "$site"\n\t\e[93mRating:\e[33m "$rating"\n\t\e[93mCodec:\e[33m "$codec"\n\t\e[93mPage name:\e[33m $pagename\n\t\e[93mMedia type:\e[33m ${table[$mediatype]}"
			echo -e  "\e[93m\n(y\\3\bn):\e[33m "
			read correct
			while [[ "$correct" != "y" && "$correct" != "n" ]]
			do
				echo -e "\e[31mInvalid input!\e[93m\n(y\\3\bn): "
				read correct
			done
		while [ "$correct" != "y" ]
		do

			echo "TV Show"
			echo -e "\e[96mRules:\n\n\t1. Please submit only full seasons if possible.\n\t2. Ranking of types: BluRay/BDRip > WEB-DL ≅ WEB-Rip > HDTV/PDTV/DSRip >DVDRip > DVD-5/DVD-9/DVD-R > DVD SCR/BD SCR/Screener > Telesync > CAMRip.\n\t3. Please submit the highest available type.\n\t4. Videos may be encoded only once (from lossless footage) if possible.\n\t5. Order of codecs: HEVC > h.264 > VP9 > AV1. No DivX. No XviD. No WMV. \n\t5. Maximize compatability with platforms (without sacrificing quality and size). \n\t6. No burned in subtitles (included is okay but only if they can be disabled).\n\t\e[95mIf your submission does not comply with these rules, it won't be accepted, so please make sure that it does!"
			echo -e "\n\e[93mPlease enter the title of the game, e.g. 2 Broke Girls.\e[33m"
			read name
			echo -e "\n\e[93mPlease enter the season number.\e[33m"
			read season
			echo -e "\e[93mPlease enter the description (MUST BE ALL ON ONE LINE; GOOGLE '"'text to one line'"'!).\e[33m"
			read description
			echo -e "\e[93mPlease a URL at which the TV Show can be purchased.\e[33m"
			read site
			echo -e "\e[93mPlease enter the TV Show's rating.\e[33m"
			read rating
			echo -e "\e[93mPlease enter the TV Show's genre.\e[33m"
			read genre
			echo -e "\e[93mPlease enter the IMDB page url of the movie (be sure to include the http(s) prefix).\e[33m"
			read imdb
			echo -e "\e[93mPlease enter the codec used to encode the TV Show, e.g. HEVC"
			read codec
			echo -e "\e[93mPlease enter a file name for the web page. Rules:\n\n\t1. It should be one-worded\n\t2. It should have no spaces\n\t3. It should have no special characters or capital letters.\n\nExample: 2brokegirls for 2 Broke Girls.\e[33m"
			read pagename
			echo -e "\n\e[93mAre these details correct?\n\n\t\e[93mName:\e[33m "$name"\n\t\e[93mSeason:\e[33m "$season"\n\t\e[93mBlurb:\e[33m "$description"\n\t\e[93mPurchase link:\e[33m "$site"\n\t\e[93mRating:\e[33m "$rating"\n\t\e[93mCodec:\e[33m "$codec"\n\t\e[93mPage name:\e[33m $pagename\n\t\e[93mMedia type:\e[33m ${table[$mediatype]}"
			echo -e  "\e[93m\n(y\\3\bn):\e[33m "
			read correct
			while [[ "$correct" != "y" && "$correct" != "n" ]]
			do
				echo -e "\e[31mInvalid input!\e[93m\n(y\\3\bn): "
				read correct
			done
		done

		echo -e "\e[93m\nPlease enter the path to the file, e.g. /home/Users/phred/TV/2brokegirls.7z\e[33m"
		read outFile

		exists

		echo -e "\e[90m"

		zip_n_split

		upload_n_in

		export name="$name"
		export title="$name"
		export season="$season"
		export description="$description"
		export url="$site"
		export rating="$rating"
		export genre="$genre"
		export imdb="$imdb"
		export codec="$codec"
		export dlink="$ixio"
		export dlink2="$sprunge"
		export sparelink="$nixenc"

		mkdir outfiles &> /dev/null
		mkdir outfiles/software &> /dev/null
		mkdir outfiles/movies &> /dev/null
		mkdir outfiles/tv &> /dev/null
		mkdir outfiles/games &> /dev/null
		mkdir outfiles/music &> /dev/null
		mkdir outfiles/books &> /dev/null

		mo /cyberarms/tv.mo > outfiles/tv/"$pagename".html	
		subf="tv"	











elif [ "$mediatype" = 3 ]
then












			echo "Game"
			echo -e "\e[96mRules:\n\n\t1. Please submit only full games WITHOUT DRM.\n\t2. Please submit versions that were originally DRM-free if possible (e.g. from GOG).\n\t3. Please submit games with minimal (if any) ripping and reencoding.\n\t4. Approved repackers: FitGirl, RG Mechanics, Black Box, Xatab, RG Catalyst, Mr. DJ, \n\t\tSkidrow, Reloaded, KaOs, Voksi, Revolt (RVT), Fairlight (FLT), Conspiracy (CPY), CODEX, \n\t\tREALiTY, Baldman, or Corepacks\n\t5. Please make sure you provide the least buggy version of the game possible.\n\t\e[95mIf your submission does not comply with these rules, it won't be accepted, so please make sure that it does!"
			echo -e "\n\e[93mPlease enter the title of the game, e.g. The Witcher 3.\e[33m"
			read softname
			echo -e "\e[93mPlease enter the description (MUST BE ALL ON ONE LINE; GOOGLE '"'text to one line'"'!).\e[33m"
			read softdetails
			echo -e "\e[93mPlease a URL at which the game can be purchased.\e[33m"
			read softsite
			echo -e "\e[93mPlease enter the developer(s) and/or studio(es), e.g. CD Projekt RED.\e[33m"
			read softauthor
			echo -e "\e[93mPlease enter the platform, e.g. "Windows", "XBox One", "PlayStation 4", "Android", etc.\e[33m"
			read softformat
			echo -e "\e[93mPlease enter a file name for the web page. Rules:\n\n\t1. It should be one-worded\n\t2. It should have no spaces\n\t3. It should have no special characters or capital letters.\n\nExample: witcher3 for The Witcher 3.\e[33m"
			read pagename
			echo -e "\n\e[93mAre these details correct?\n\n\t\e[93mName:\e[33m $softname\n\t\e[93mBlurb:\e[33m $softdetails\n\t\e[93mPurchase link:\e[33m $softsite\n\t\e[93mPage name:\e[33m $pagename\n\t\e[93mMedia type:\e[33m ${table[$mediatype]}"
			echo -e  "\e[93m\n(y\\3\bn):\e[33m "
			read correct
			while [[ "$correct" != "y" && "$correct" != "n" ]]
			do
				echo -e "\e[31mInvalid input!\e[93m\n(y\\3\bn): "
				read correct
			done
		while [ "$correct" != "y" ]
		do

			echo "Game"
			echo -e "\e[96mRules:\n\n\t1. Please submit only full games WITHOUT DRM.\n\t2. Please submit versions that were originally DRM-free if possible (e.g. from GOG).\n\t3. Please submit games with minimal (if any) ripping and reencoding.\n\t4. Approved repackers: FitGirl, RG Mechanics, Black Box, Xatab, RG Catalyst, Mr. DJ, \n\t\tSkidrow, Reloaded, KaOs, Voksi, Revolt (RVT), Fairlight (FLT), Conspiracy (CPY), CODEX, \n\t\tREALiTY, Baldman, or Corepacks\n\t5. Please be sure to provide the latest/least buggy version available.\n\t6. Please zip all files into one 7z archive.\n\t\e[95mIf your submission does not comply with these rules, it won't be accepted, so please make sure that it does!"
			echo -e "\n\e[93mPlease enter the title of the game, e.g. The Witcher 3.\e[33m"
			read softname
			echo -e "\e[93mPlease enter the description (MUST BE ALL ON ONE LINE; GOOGLE '"'text to one line'"'!).\e[33m"
			read softdetails
			echo -e "\e[93mPlease a URL at which the game can be purchased.\e[33m"
			read softsite
			echo -e "\e[93mPlease enter the developer(s) and/or studio(es), e.g. CD Projekt RED.\e[33m"
			read softauthor
			echo -e "\e[93mPlease enter the platform, e.g. "Windows", "XBox One", "PlayStation 4", "Android", etc.\e[33m"l
			read softformat
			echo -e "\e[93mPlease enter a file name for the web page. Rules:\n\n\t1. It should be one-worded\n\t2. It should have no spaces\n\t3. It should have no special characters or capital letters.\n\nExample: witcher3 for The Witcher 3.\e[33m"
			read pagename
			echo -e "\n\e[93mAre these details correct?\n\n\t\e[93mName:\e[33m $softname\n\t\e[93mBlurb:\e[33m $softdetails\n\t\e[93mPurchase link:\e[33m $softsite\n\t\e[93mPage name:\e[33m $pagename\n\t\e[93mMedia type:\e[33m ${table[$mediatype]}"
			echo -e  "\e[93m\n(y\\3\bn):\e[33m "
			read correct
			while [[ "$correct" != "y" && "$correct" != "n" ]]
			do
				echo -e "\e[31mInvalid input!\e[93m\n(y\\3\bn): "
				read correct
			done
		done

		echo -e "\e[93m\nPlease enter the path to the file, e.g. /home/Users/phred/Music/witcher3.7z\e[33m"
		read outFile

		exists

		echo -e "\e[90m"

		zip_n_split

		upload_n_in

		export title="$softname"
		export description="$softdetails"
		export url="$softsite"
		export artist="$softauthor"
		export formats="$softformat"
		export dlink="$ixio"
		export dlink2="$sprunge"

		mkdir outfiles &> /dev/null
		mkdir outfiles/software &> /dev/null
		mkdir outfiles/movies &> /dev/null
		mkdir outfiles/tv &> /dev/null
		mkdir outfiles/games &> /dev/null
		mkdir outfiles/music &> /dev/null
		mkdir outfiles/books &> /dev/null

		mo /cyberarms/game.mo > outfiles/game/"$pagename".html
		subf="game"











elif [ "$mediatype" = 4 ]
then












			echo "Music"
			echo -e "\e[96mRules:\n\n\t1. Please submit full albums in good quality (minimum mp3 @ 256kbps or equivalent) and WITHOUT DRM.\n\t2. Please submit only one album at a time.\n\t3. Please compress the album to a 7z archive.\n\t4. Please make sure ALL metadata is correct!\n\t5. Please make sure album art is present.\n\t\e[95mIf your submission does not comply with these rules, it won't be accepted, so please make sure that it does!"
			echo -e "\n\e[93mPlease enter the title of the album, e.g. Jackpot.\e[33m"
			read softname
			echo -e "\e[93mPlease enter the description (MUST BE ALL ON ONE LINE; GOOGLE '"'text to one line'"'!).\e[33m"
			read softdetails
			echo -e "\e[93mPlease a URL at which the album can be purchased.\e[33m"
			read softsite
			echo -e "\e[93mPlease enter the artist, e.g. TheFatRat.\e[33m"
			read softauthor
			echo -e "\e[93mPlease enter the format of the music, e.g. "mp3", "flac", "aac", etc.\e[33m"
			read softformat
			echo -e "\e[93mPlease enter a file name for the web page. Rules:\n\n\t1. It should be one-worded\n\t2. It should have no spaces\n\t3. It should have no special characters or capital letters.\n\nExample: jackpot for Jackpot by TheFatRat.\e[33m"
			read pagename
			echo -e "\n\e[93mAre these details correct?\n\n\t\e[93mName:\e[33m $softname\n\t\e[93mBlurb:\e[33m $softdetails\n\t\e[93mPurchase link:\e[33m $softsite\n\t\e[93mPage name:\e[33m $pagename\n\t\e[93mMedia type:\e[33m ${table[$mediatype]}"
			echo -e  "\e[93m\n(y\\3\bn):\e[33m "
			read correct
			while [[ "$correct" != "y" && "$correct" != "n" ]]
			do
				echo -e "\e[31mInvalid input!\e[93m\n(y\\3\bn): "
				read correct
			done
		while [ "$correct" != "y" ]
		do

			echo "Music"
			echo -e "\e[93mPlease enter the title of the album, e.g. Jackpot.\e[33m"
			read softname
			echo -e "\e[93mPlease enter the description (MUST BE ALL ON ONE LINE; GOOGLE '"'text to one line'"'!).\e[33m"
			read softdetails
			echo -e "\e[93mPlease a URL at which the album can be purchased.\e[33m"
			read softsite
			echo -e "\e[93mPlease enter the artist, e.g. TheFatRat.\e[33m"
			read softauthor
			echo -e "\e[93mPlease enter the format of the music, e.g. "mp3", "flac", "aac", etc.\e[33m"
			read softformat
			echo -e "\e[93mPlease enter a file name for the web page. Rules:\n\n\t1. It should be one-worded\n\t2. It should have no spaces\n\t3. It should have no special characters or capital letters.\n\nExample: jackpot for Jackpot by TheFatRat.\e[33m"
			read pagename
			echo -e "\n\e[93mAre these details correct?\n\n\t\e[93mName:\e[33m $softname\n\t\e[93mBlurb:\e[33m $softdetails\n\t\e[93mPurchase link:\e[33m $softsite\n\t\e[93mPage name:\e[33m $pagename\n\t\e[93mMedia type:\e[33m ${table[$mediatype]}"
			echo -e  "\e[93m\n(y\\3\bn):\e[33m "
			read correct
			while [[ "$correct" != "y" && "$correct" != "n" ]]
			do
				echo -e "\e[31mInvalid input!\e[93m\n(y\\3\bn): "
				read correct
			done
		done

		echo -e "\e[93m\nPlease enter the path to the file, e.g. /home/Users/phred/Music/jackpot.7z\e[33m"
		read outFile

		exists

		echo -e "\e[90m"

		zip_n_split

		upload_n_in

		export title="$softname"
		export description="$softdetails"
		export url="$softsite"
		export artist="$softauthor"
		export formats="$softformat"
		export dlink="$ixio"
		export dlink2="$sprunge"

		mkdir outfiles &> /dev/null
		mkdir outfiles/software &> /dev/null
		mkdir outfiles/movies &> /dev/null
		mkdir outfiles/tv &> /dev/null
		mkdir outfiles/games &> /dev/null
		mkdir outfiles/music &> /dev/null
		mkdir outfiles/books &> /dev/null

		mo /cyberarms/music.mo > outfiles/music/"$pagename".html
		subf="$music"












elif [ "$mediatype" = 5 ]
then












			echo "Book"
			echo -e "\e[96mRules:\n\n\t1. Books should be in good quality and WITHOUT DRM.\n\t2. Allowed formats: epub (preferred), djvu, or fb2.\n\t3. Please submit only one book at a time\.\n\t4. Please make sure ALL metadata is correct!\n\t5. Please make sure the cover image is present.\n\t\e[95mIf your submission does not comply with these rules, it won't be accepted, so please make sure that it does!"
			echo -e "\e[93mPlease enter the title of the book, e.g. The Name of the Wind.\e[33m"
			read softname
			echo -e "\e[93mPlease enter the blurb (MUST BE ALL ON ONE LINE; GOOGLE '"'text to one line'"'!).\e[33m"
			read softdetails
			echo -e "\e[93mPlease a URL at which the book can be purchased.\e[33m"
			read softsite
			echo -e "\e[93mPlease enter the author of the book, e.g. Patrick Rothfuss.\e[33m"
			read softauthor
			echo -e "\e[93mPlease enter the format of the book, e.g. "epub", "mobi", "azw3", etc.\e[33m"
			read softformat
			echo -e "\e[93mPlease enter a file name for the web page. Rules:\n\n\t1. It should be one-worded\n\t2. It should have no spaces\n\t3. It should have no special characters or capital letters.\n\nExample: notw for The Name of the Wind.\e[33m"
			read pagename
			echo -e "\n\e[93mAre these details correct?\n\n\t\e[93mName:\e[33m $softname\n\t\e[93mBlurb:\e[33m $softdetails\n\t\e[93mPurchase link:\e[33m $softsite\n\t\e[93mPage name:\e[33m $pagename\n\t\e[93mMedia type:\e[33m ${table[$mediatype]}"
			echo -e  "\e[93m\n(y\\3\bn):\e[33m "
			read correct
			while [[ "$correct" != "y" && "$correct" != "n" ]]
			do
				echo -e "\e[31mInvalid input!\e[93m\n(y\\3\bn): "
				read correct
			done
		while [ "$correct" != "y" ]
		do

			echo "Book"
			echo -e "\e[93mPlease enter the title of the book, e.g. The Name of the Wind.\e[33m"
			read softname
			echo -e "\e[93mPlease enter the blurb (MUST BE ALL ON ONE LINE; GOOGLE "text to one line"!).\e[33m"
			read softdetails
			echo -e "\e[93mPlease a URL at which the book can be purchased.\e[33m"
			read softsite
			echo -e "\e[93mPlease enter the author of the book, e.g. Patrick Rothfuss.\e[33m"
			read softauthor
			echo -e "\e[93mPlease enter the format of the book, e.g. "epub", "mobi", "azw3", etc.\e[33m"
			read softformat
			echo -e "\e[93mPlease enter a file name for the web page. Rules:\n\n\t1. It should be one-worded\n\t2. It should have no spaces\n\t3. It should have no special characters or capital letters.\n\nExample: notw for The Name of the Wind.\e[33m"
			read pagename
			echo -e "\n\e[93mAre these details correct?\n\n\t\e[93mName:\e[33m $softname\n\t\e[93mBlurb:\e[33m $softdetails\n\t\e[93mPurchase link:\e[33m $softsite\n\t\e[93mPage name:\e[33m $pagename\n\t\e[93mMedia type:\e[33m ${table[$mediatype]}"
			echo -e  "\e[93m\n(y\\3\bn):\e[33m "
			read correct
			while [[ "$correct" != "y" && "$correct" != "n" ]]
			do
				echo -e "\e[31mInvalid input!\e[93m\n(y\\3\bn): "
				read correct
			done
		done

		echo -e "\e[93m\nPlease enter the path to the file, e.g. /home/Users/phred/Documents/notw.mobi\e[33m"
		read outFile

		exists

		echo -e "\e[90m"

		zip_n_split

		upload_n_in

		export title="$softname"
		export blurb="$softdetails"
		export url="$softsite"
		export author="$softauthor"
		export formats="$softformat"
		export dlink="$ixio"
		export dlink2="$sprunge"
		export spare="$sparelink"

		mkdir outfiles &> /dev/null
		mkdir outfiles/software &> /dev/null
		mkdir outfiles/movies &> /dev/null
		mkdir outfiles/tv &> /dev/null
		mkdir outfiles/games &> /dev/null
		mkdir outfiles/music &> /dev/null
		mkdir outfiles/books &> /dev/null

		mo /cyberarms/book.mo > outfiles/books/"$pagename".html
		subf="books"

else
	echo "Error - uncaught exception at the media type if statement"
fi



# Move a copy of the template to the appropriately named file
# cp /cyberarms.github.io/snowtemp.html ./"$pagename".html

#filler1
#filler2
#filler3
#filler4
#filler5
#filler6

rm -f "$file".7z* &> /dev/null

rm 1 &> /dev/null
rm -f "$file"".0""*"
echo -e "\e[32m\n\n\nThe """$softname""" media page has been successfully generated and has been saved to ""$PWD""/outfiles/""${table[$mediatype]}""$pagename".html"\nNow, please email stuff@cyberarms.gq with that file attached for review. If approved, it will be added to the site.\nThank you for your contribution! Please continue to help or donate if possible.\n\n\e[37mFinished!"