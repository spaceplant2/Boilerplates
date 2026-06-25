
### shell script to rename files and folders
# /bin/bash

baseDir="/workspaces/Boilerplates/Shell"
recurse="n"

for dir in "$baseDir"/*; do
  # echo "checking $dir"
  if [[ -d "$dir" ]]; then
    echo "directory is named $dir"
    for path in "$dir"/*; do
      fullname=$(basename -- "$path")
      filename="${fullname%.*}"
      extension="${fullname##*.}"
      echo "dir is $dir"
      echo "path name is $path"
      echo "fullname is $fullname"
      echo "filename is $filename"
      echo "extension is $extension"
      echo ""

      new_filename=$(echo "$filename" | sed 's/[._-]/ /g')
      echo "baseDir is still $baseDir"
      echo "new_filename will be $new_filename"
      echo "final full filename should be $baseDir/$new_filename/$new_filename.$extension"
      echo ""
      echo "***   ===     ***"
      echo ""
    done
  fi
done