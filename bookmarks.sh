#/bin/bash

#Check if liblz4-dev is installed
lz4=$(dpkg -l | grep liblz4-dev)
if [ -z "$lz4" ]
then
  echo "liblz4-dev = Not installed, install it? y/n"
  read install1
  var=y
  if [ $install1 = $var ]
  then
    apt install liblz4-dev
  else exit
  fi
  else
    echo "liblz4-dev is installed"
fi

#Check if pkg-config is installed
lz4=$(dpkg -l | grep liblz4-dev)
if [ -z "$lz4" ]
then
  echo "pkg-config = Not installed, install it? y/n"
  read install2
  var=y
  if [ $install2 = $var ]
  then
    apt install pkg-config
  else exit
  fi
  else
    echo "liblz4-dev is installed"
fi

#Find path of lz4jsoncat if compiled
lz4jsoncat=$(sudo find / -name 'lz4jsoncat')
#If lz4jsoncat does not exist, clone & compile
if [ -z "$lz4jsoncat" ]
  then
    echo "lz4jsoncat is not installed, install now? y/n"
    read install3
    if [ $install3 = 'y' ]
    then
      mkdir lz4json && cd lz4json
      git clone https://github.com/andikleen/lz4json.git
      cd lz4json && make
    fi
  else
    echo "lz4jsoncat is installed @ $lz4jsoncat"
  fi

#decompress the jsonlz4 bookmarks
bookmarks=$($lz4jsoncat ~/.mozilla/firefox/*.default/bookmarkbackups/*.jsonlz4)
#Regex to match only url`s
links=$(echo $bookmarks | grep -ohP '"uri":"[^"]*' | grep -ohP 'http?.*')

#For loop to remove duplicates
touch links.txt && > links.txt
for line in $links
  do
    echo $line >> links.txt
done
#cat links.txt
sort links.txt | uniq
rm links.txt
