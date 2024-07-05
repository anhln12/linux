#!/bin/bash
while read line
do
owner=$line;
echo $owner
gzip $owner
done < gzip_file.txt
