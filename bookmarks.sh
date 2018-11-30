#/bin/bash

if [[ $1 == "install" ]]
then
  #Unlock dpkg if locked
  if [ -f /var/lib/dpkg/lock ]
  then
    rm /var/lib/dpkg/lock
  fi

  function install() {
    toinstall=$(dpkg -l | grep "$1")
    if [ -z "$toinstall" ]
    then
      echo "$1 is not installed, install it now? (y/n)"
      read install
      var=y
      if [ $install = $var ]
      then
        sudo apt install $1
      fi
    else
      echo "$1 is installed"
    fi
  }

install build-essential
install liblz4-dev
install pkg-config


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
