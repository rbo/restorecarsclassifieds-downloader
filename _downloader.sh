#!/usr/bin/env bash

set -e

first=$1
last=$2
incr=${3:-1}


download () {
  i=$1
  filename=$(printf "%06d" $i)
  folder=${filename:0:4};
  # echo "${a:0:3}-${a:3:3}"
  mkdir -p $folder
  echo -n "Download $folder/$filename.pdf.."
  if [ -f "$folder/$filename.pdf" ] ; then
    echo "... Skip file exist"
    return 0;
  fi;
  # curl --fail -s -L -o ${i}.pdf http://restorecarsclassifieds.com/wiki/show_pdf.pdf?n=${i}; 
  content_type=$(curl -s -o ${folder}/${filename}.pdf --write-out "%{content_type}"  http://restorecarsclassifieds.com/wiki/show_pdf.pdf?n=${i})
  if [ "$content_type" != "application/octet-stream" ] ; then
    echo "... Skip wrong content type: $content_type"
    rm ${folder}/${filename}.pdf;
    return 0;
  fi;
  echo;
  return 0;
}

if [ -z $2 ] ; then
  echo "Download from single file $1 ";
  download $1
  exit;
fi;

if [ -z $1 -o -z $2 ] ; then
  echo "Useage $0 <first> <last>";
  exit  1;
fi;



echo "Download from $first..$last ( Incr: $incr )";

for i in $( seq $first $incr $last ) ; do
  download $i
done; 