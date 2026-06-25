
### shell script to rename files and folders
# /bin/bash

baseDir="/media/unified/local/adults/Videos/movies"
recurse="n"

for dir in "$baseDir"/*; do
  # echo "checking $dir"
  if [[ -d "$dir" ]]; then
    echo "directory is named $dir"
    for path in "$dir"/*; do
      # filename=$(basename -- "$path")
      filename="${filename%.*}"
      extension="${filename##*.}"
      echo "path name is $path"
      echo "filename is $filename"
      echo "extension is $extension"


      newname=$(echo "$filename" | sed 's/[._-]/ /g')
      echo "newname will be $newname"
    done
  fi
done