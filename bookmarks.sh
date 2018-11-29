#/bin/bash

if [[ $1 == "install" ]]
then
  #Unlock dpkg if locked
  if [ -f /var/lib/dpkg/lock ]
  then
    rm /var/lib/dpkg/lock
  fi

  #Check if build-essentials is installed
  build=$(dpkg -l | grep build-essential)
  if [ -z "$build" ]
  then
    echo "Build-Essential Not installed, install it? y/n"
    read install
    var=y
    if [ $install = $var ]
    then
      sudo apt install build-essential
    else exit
    fi
    else
      echo "Build-Essentail is installed"
  fi

  #Check if liblz4-dev is installed
  lz4=$(dpkg -l | grep liblz4-dev)
  if [ -z "$lz4" ]
  then
    echo "liblz4-dev = Not installed, install it? y/n"
    read install1
    var=y
    if [ $install1 = $var ]
    then
      sudo apt install liblz4-dev
    else exit
    fi
    else
      echo "liblz4-dev is installed"
  fi

  #Check if pkg-config is installed
  pkg=$(dpkg -l | grep pkg-config)
  if [ -z "$pkg" ]
  then
    echo "pkg-config = Not installed, install it? y/n"
    read install2
    var=y
    if [ $install2 = $var ]
    then
      sudo apt install pkg-config
    else exit
    fi
    else
      echo "liblz4-dev is installed"
  fi

  #Find path of lz4jsoncat if compiled
  lz4jsoncat=$(sudo find / -name 'lz4jsoncat' 2> /dev/null)
  #If lz4jsoncat does not exist, clone & compile
  if [ -z "$lz4jsoncat" ]
    then
      echo "lz4jsoncat is not installed, install now? y/n"
      read install3
      if [ $install3 = 'y' ]
      then
        if [ -d "lz4json" ]
        then
          cd lz4json && make && cd
        else
          mkdir lz4json && cd lz4json
          git clone https://github.com/andikleen/lz4json.git
          cd lz4json && make && cd
        fi
      fi
    else
      echo "lz4jsoncat is installed @ $lz4jsoncat"
    fi
fi

lz4jsoncat=$(sudo find / -name 'lz4jsoncat' 2> /dev/null)

#decompress the jsonlz4 bookmarks
bookmarks=$(sudo $lz4jsoncat ~/.mozilla/firefox/*.default/bookmarkbackups/*.jsonlz4)
#Regex to match only url`s
links=$(echo $bookmarks | grep -ohP '"uri":"[^"]*' | grep -ohP 'http?.*')

#For loop to remove duplicates
touch links.txt && > links.txt
for line in $links
  do
    echo $line >> links.txt
done
echo " "
echo "Firefox Bookmarks: "
echo " "

sort links.txt | uniq
rm links.txt
