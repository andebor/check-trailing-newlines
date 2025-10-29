#!/bin/sh -l

ERRORS=0

git config --global --add safe.directory /github/workspace

for f in $(git ls-files '*.csv')
do
  amount=$(grep -cv '[^[:blank:]]' $f)
  if [[ $amount -gt 1 ]]; then
    total_lines=$(wc -l < $f | xargs)
    line=$((total_lines - amount))
    echo "::error file=$f,line=$line,endLine=$total_lines::File has $amount extra trailing newlines at the end."
    ERRORS=1
  fi
done

if [ $ERRORS -eq 1 ]; then
  echo "Files above have more than one trailing newline at the end."
  exit 1
fi

echo "No files with trailing newlines found."
