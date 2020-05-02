#!/usr/bin/env bash

set -e

build_pdf () {
  
  output=$1
  first=$2
  last=$3
  input=""
  echo -n "Build $output:"
  if [ -f "$output" ] ; then
    echo " Skip file exist"
    return 0;
  fi;

  echo -n " args"
  for i in $( seq $first $last ) ; do 
    filename=$(printf "%06d" $i)
    folder=${filename:0:4};
    input="$input $folder/$filename.pdf";
  done;
  echo -n " pdf"
  cpdf -merge -o $output $input 2>>/dev/null
  if [ $? -ne 0 ]; then
    return 0
  fi;
  echo " $(du -sh $output)";
}

cat _books.csv | while read line ; do 
  IFS=';' read -r -a array <<< "$line"
  # echo ${array[@]};
  # echo "fist: ${array[0]}"
  # echo "last: ${array[1]}"
  # echo "output: ${array[2]}"
  build_pdf ${array[2]} ${array[0]} ${array[1]}
done

