#!/bin/sh -l

if [ $# -eq 0 ]
  then
    echo "Missing required filter pattern argument"
    exit 1
fi


ERRORS=0
filter_pattern=$1
allowed_newlines=${2:-1}

git config --global --add safe.directory /github/workspace

cmd="git ls-files $filter_pattern"

for f in $($cmd)
do
  amount=$(grep -cv '[^[:blank:]]' $f)
  if [[ $amount -gt $allowed_newlines ]]; then
    total_lines=$(wc -l < $f | xargs)
    line=$((total_lines - amount))
    echo "::error file=$f,line=$line,endLine=$total_lines::File '$f' has $amount extra trailing newlines at the end."
    ERRORS=1
  fi
done

if [ $ERRORS -eq 1 ]; then
  echo "Files above have more than $allowed_newlines trailing newline at the end."
  exit 1
fi

echo "No files with trailing newlines found."
