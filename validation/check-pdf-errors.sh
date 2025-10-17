#!/bin/bash
#
# File: check-pdf-errors
# Version: 0.9
#
# Checks whether the PDF files in the current directory have issues in matching the CEURART style.
# (C) 2024-2025 by Manfred Jeusfeld. This script is made available under the
# Creative Commons Attribution-ShareAlike CC-BY-SA 4.0 license.
#
# The BASH script is part of the scripts used for CEUR-WS.org. No warrantee whatsoever. No support. 
#
# Requires the installation of certain packages, in particular pdf2txt and pdffonts. The tool pdf2txt is part of the 
# package python-pdfminer.  The pdffonts command is paper of the package poppler-utils. 
# Install on Debian-based systems with
#   sudo apt install python3-pdfminer
#   sudo apt-get install poppler-utils
#
# Note that this script is updated on a regular basis, in particular to cover changes with
# the CEURART layout for papers. See ceur-ws.org/Vol-XXX/ for the CEURART specification.
#
# Call this script in the directory that contains the PDF files that you want to check.
#
# Manfred 2024-08-17 (2025-10-08)
#


if [[ ! `ls *.pdf` ]]; then
    echo "No file with filetype *.pdf in this directory."
    exit 1
fi


echo ""
echo "(*) Readable/Selectable text inside PDF files"
ABSTRACTWORD="found"
for f in *.pdf
do
  # PDF files should have the computer-readable string "Abstract" or "Copyright" on the first two pages (normally page 1)
  pdf2txt.py -m 2 "$f" | grep -E 'Abstract|Copyright' 2>&1 > /dev/null
  if [[ $? != 0 ]];
  then
     if [[ "$f" != *"reface"*".pdf" && "$f" != *"rganization.pdf" && "$f" != *"ponsors.pdf" && "$f" != *"ommittee"*".pdf" && "$f" != *"matter"*".pdf" ]]
     then
        ABSTRACTWORD="notfound"
        echo "PDF file $f seems to have no readable text included but only binary data"
     fi
  fi
done
if [[ "$ABSTRACTWORD" == "notfound" ]] ; then
  echo " ===> Make sure that paper PDFs have readable/selectable text in them; use a proper PDF printer driver on Windows such as PDFCreator or use LibreOffice PDF export"
  echo " "
else
  echo "ok"
  echo " "
fi


echo ""
echo "(*) CEUR-WS standard copyright phrase"
CREATIVECOMMONS="found"
for f in *.pdf
do
  # PDF files should have the string "Creative Commons License" on the first two pages; copyright year may not be 2022 or 2023 
  # left unmodified by the author when using the CEURART template
#  pdf2txt -m 2 "$f" | grep -E 'Creative.*Commons.*License|Commons.*License.*Attribution' 2>&1 > /dev/null
  pdf2txt.py -m 2 "$f" | grep -E 'Creative.*Commons.*License|Commons.*License.*Attribution' | grep -Ev '2022|2023' 2>&1 > /dev/null
  if [[ $? != 0 ]];
  then
     if [[ "$f" != *"reface"*".pdf" && "$f" != *"rganization.pdf" && "$f" != *"ponsors.pdf" && "$f" != *"ommittee"*".pdf" && "$f" != *"matter"*".pdf" ]]
     then
        CREATIVECOMMONS="notfound"
        echo "PDF file $f seems to lack the proper copyright clause or copyright year on page 1"
     fi
  fi
done
if [[ $CREATIVECOMMONS == "notfound" ]] ; then
  echo " ===> Make sure that paper PDFs have the correct copyright clause, see https://ceur-ws.org/HOWTOSUBMIT.html#CCBY-FOOTNOTE"
  echo " ===> Make sure that paper PDFs have the correct *year* in the copyright clause!"
  echo " "
else
  echo "ok"
  echo " "
fi


echo "(*) Declaration on Generative AI"
GENAIDECL="ok"
for f in *.pdf
do
  # front or backmatter files are not tested
  if [[ "$f" == *"reface"*".pdf" || "$f" == *"rganization.pdf" || "$f" == *"ponsors.pdf" || "$f" == *"bstract"*".pdf"  || "$f" == *"ommittee"*".pdf" || "$f" == *"matter"*".pdf" ]]
  then
     continue
  fi

  temp_file=$(mktemp /tmp/pdftext.XXXXXX.txt)
#  pdftotext "$f" "$temp_file"
  pdf2txt.py "$f" > "$temp_file"
  # Test 1: PDF files should have a section "Declaration on Generative AI"
  cat "$temp_file" | grep -E 'Declaration .. [G|g]enerative AI|[G|g]enerative AI *[D|d]eclaration' 2>&1 > /dev/null
  if [[ $? != 0 ]];
  then
     GENAIDECL="notok"
     echo "PDF file $f seems to lack a section Declaration on Generative AI"
     continue;
  fi
  # Test 2: The phrase "The author ... not employed any Generative AI tools." is fine; not more checks needed
  cat "$temp_file" | grep -E 'The author.*not employed any Generative AI tools\.' 2>&1 > /dev/null
  if [[ $? == 0 ]];
  then
    continue;  # This file is ok
  fi
  # If Test2 failed then Test 3 is required: The GenAI statement must contain the phrase "reviewed|*full responsibility"
  # Not yet happy with this solution. We want authors to follow our template but some make slight variations. Others big ones.
  # cat "$temp_file" | tr '\n' ' ' | grep -E 'reviewed|full responsibility' 2>&1 > /dev/null
  #  if [[ $? != 0 ]];
  #then
  #   GENAIDECL="notok"
  #   echo "PDF file $f seems to use a non-standard text for the Declaration on Generative AI"
  #fi
  /bin/rm "$temp_file"
done
if [[ $GENAIDECL == "notok" ]] ; then
  echo " ===> Make sure that paper PDFs have a Generative AI Declaration conforming https://ceur-ws.org/GenAI/Policy.html"
  echo " "
else
  echo "ok"
  echo " "
fi


echo ""
echo "(*) Use of CEUR-WS.org logo or link or string CEUR Workshop Proceedings before publication"
CEURWSLINKFOUND="notfound"
for f in *.pdf
do
  if [ -f watermark-log.txt ]; then
    if grep -q "$f" watermark-log.txt; then
      continue;
    fi
  fi
  if [[ "$f" == *"reface"*".pdf" || "$f" == *"rganization.pdf" || "$f" == *"ponsors.pdf" || "$f" == *"bstract"*".pdf"  || "$f" == *"ommittee"*".pdf" || "$f" == *"matter"*".pdf" ]]
  then
     continue
  fi
  # PDF files should not have the string "(CEUR-WS.org)" on the first two pages
  pdf2txt.py -m 2 "$f" | grep -E '(CEUR-WS.org)|CEUR Workshop Proceedings' 2>&1 > /dev/null
  if [[ $? == 0 ]];
  then
     CEURWSLINKFOUND="found"
     echo "PDF file $f uses 'CEUR-WS.org' or 'CEUR Workshop Proceedings' before publication"
  fi
done
if [[ $CEURWSLINKFOUND == "found" ]] ; then
  echo " ===> Use the latest CEURART template from https://ceur-ws.org/Vol-XXX/, which does not have a footnote with the CEUR-WS logo; Do not use the string 'CEUR Workshop Proceedings' in the header or footer of papers"
  echo " "
else
  echo "ok"
  echo " "
fi


echo ""
echo "(*) Libertinus font in paper PDFs"
NONLIBERTINUSFOUND="no"
for f in *.pdf
do
  # Files created with Windows Word/LibreOfffice apparently use CIDFont+F instead Libertinus as font name (?)
  # We use two methods for Libertinus detection. First, 'strings | grep FontName' extracts it if it is used as a PDF
  # command. Second, pdffonts is used when the fonts are embedded differently. 
  strings "$f" | grep FontName | grep -q -E 'Libertinus|CIDFont.F5'
  if [[ $? != 0 ]];
  then
     if [[ "$f" != *"reface"*".pdf" && "$f" != *"rganization.pdf" &&"$f" != *"ponsors.pdf"  && "$f" != *"ommittee"*".pdf" ]]
     then
       pdffonts 2> /dev/null $f | grep -q -E 'Libertinus|CIDFont.F5'
       if [[ $? != 0 ]];
       then
          NONLIBERTINUSFOUND="found"
          echo "PDF file $f does not use Libertinus font family"
       fi
     fi
  fi
done
if [[ $NONLIBERTINUSFOUND == "found" ]] ; then
  echo " ===> Make sure that paper PDFs use the Libertinus font family; instructions to install Libertinus fonts are included in https://ceur-ws.org/Vol-XXX/CEUR-Template-1col.odt; paper PDFs should all use Libertinus fonts, prefaces that have no paper character do not necessarily need to use Libertinus; do not use Word/MS365 but rather use LibreOffice and its PDF exporter"
  echo " "
else
  echo "ok"
  echo " "
fi

echo ""
echo "(*) Duplicate PDF files"
DUPPDFSFILES=`find . -name '*.pdf' ! -empty -type f -exec md5sum {} + | sort | uniq -w32 -dD`
if [ "$DUPPDFSFILES" != "" ]
then echo " ";
     echo " ==========> ERROR (P2) with duplicate PDF files!!!!"
     find . -name '*.pdf' ! -empty -type f -exec md5sum {} + | sort | uniq -w32 -dD
  echo " "
else
  echo "ok"
  echo " "

fi

echo ""
echo "(*) Leftover elements from CEURART in the footer of page 1"
NOLEFTOVER="yes"
for f in *.pdf
do
  # PDF files should not have leftover elements from the CEURART template in the footer
  pdf2txt.py -m 2 "$f" | grep -E '0000-0000-0000-0000|Woodstock.*22|0000-0002-0877-7063.*0000-0001-7116-9338.*0000-0002-9421-8566'  2>&1 > /dev/null
  if [[ $? == 0 ]];
  then
     NOLEFTOVER="no"
     echo "PDF file $f seems to have some leftover elements from the footer of the CEURART template on page 1 such as ORCIDs or the event name"
  fi
done
if [[ $NOLEFTOVER == "no" ]] ; then
  echo " ===> Make sure that paper PDFs have correct data in the footnote section of page 1"
  echo " "
else
  echo "ok"
  echo " "
fi

# disabled for now
#echo ""
#echo "(*) Check on one-column style"
#ALLONECOLUMN="yes"
#for f in *.pdf
#do
#  if [[ "$f" == *"reface"*".pdf" || "$f" == *"rganization.pdf" || "$f" == *"ponsors.pdf" || "$f" == *"bstract"*".pdf"  || "$f" == *"ommittee"*".pdf" || "$f" == *"matter"*".pdf" ]]
#  then
#     continue
#  fi
  # PDF files should not have leftover elements from the CEURART template in the footer
#  check-columns "$f"  2>&1 > /dev/null
#  if [[ $? != 0 ]];
#  then
#     ALLONECOLUMN="no"
#     echo "PDF file $f seems to be in two-column format"
#  fi
#done
#if [[ $ALLONECOLUMN == "no" ]] ; then
#  echo " ===> Make sure that paper PDFs are in 1-column CEURART format, see https://ceur-ws.org/Vol-XXX/"
#  echo " "
#else
#  echo "ok"
#  echo " "
#fi

