#!/bin/bash

#set -x  # echo on

# Usage:
#  $ "./generate-image-list-markdown.sh" --path="/tmp" > README.md

urlencode() {
    local data
    if [[ $# != 1 ]]; then
        echo "Usage: $0 string-to-urlencode"
        return 1
    fi
    data="$(curl -s -o /dev/null -w %{url_effective} --get --data-urlencode "$1" "")"
    if [[ $? != 3 ]]; then
        echo "Unexpected error" 1>&2
        return 2
    fi
    echo "${data##/?}"
    return 0
}

save_ifs=$IFS
path="."

for i in "$@"
do
case $i in
    -p=*|--path=*)
        path="${i#*=}"
        shift # past argument=value
        ;;
    --default)
        shift # past argument with no value
        ;;
    *)
          # unknown option
    ;;
esac
done

IFS=$(echo -en "\n\b")

my_files=$(ls -1 "$path")
#       -1     list one file per line.  Avoid '\n' with -q or -b

for my_file in ${my_files[@]}; do
  extension="${my_file##*.}"
  filename="${my_file%.*}"
  if [ "$extension" == "png" ]; then
	   echo -e "- [$filename]("$(urlencode "$my_file")")\n"
  fi
done

IFS=$save_ifs
