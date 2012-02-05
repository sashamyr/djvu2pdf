#!/bin/bash
#  This script converts your DJVU documents to PDF.
#  Converted document will appear in the same directory with
#+ the same name.
#  NOTE: That script can be improved alot. Checking if only one argument is given,
#+ automated installing missing packets and so on.
#  Created: Sasha Buyanov, mailto:dmfd.draxel@gmail.com, 2010.

ARGS=1
BADARGS=85


#  Checking arguments here. 

if [ $# -ne "$ARGS" ]
then
  echo "What do you want to be converted?"
  echo "Usage: ./`basename $0` [file-name]"
exit $BADARGS
fi


#  Now we'll check if necessary packages are installed.
#  If some of packages are missing, script wouldn't work.

package_check()
{
  needed=( libtiff-tools djvulubre-bin djvulibre-desktop )                  #  Needed packages     
  for package in ${needed[@]}
  do
    INSTALLED=`dpkg -l | grep ${needed[index]}`
    if [ "$INSTALLED" = '' ];
    then                                                                        #  ERROR. Some packages are missing.
      bold=`tput bold`
      normal=`tput sgr0`
      echo "$bold libtiff-tools, djvulibre-bin, djvulibre-desktop \
$normal are necessary to run this script. To install, type $bold sudo \
apt-get install \"package-name\" $normal (you should be under the root account). "
      exit 1                                                                    #  Terminating.
    fi
  done
}

package_check


#  All preparations are done, now it's time for converting.

echo "Please, be patient. This will take some time depending on size of a document."
temp=/tmp/djvu2pdf_conversion.tiff                                              #  Declaring paths
output=`echo $1 | sed -e 's/\.djvu/\.pdf/g'`
ddjvu -format=tiff $1 $temp                                                     #  Converting
tiff2pdf -j -o $output $temp                                                    #  Yes, only two lines!
rm $temp
echo "Done."
exit 0
