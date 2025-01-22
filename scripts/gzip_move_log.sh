#!/bin/sh

export Y_GZIP=`date -d "-7 day" +%Y`
export M_GZIP=`date -d "-7 day" +%m`
export D_GZIP=`date -d "-7 day" +%d`
parent_folder="/data"

for subfolder in "$parent_folder"/*; do
    if [ -d "$subfolder" ]; then
         echo "changing to $subfolder"
         cd $subfolder/$Y_GZIP/$M_GZIP/$D_GZIP
         echo "Now in $(pwd)"
             for sub_folder in "$subfolder/$Y_GZIP/$M_GZIP/$D_GZIP"/*; do
                 if [ -d "$sub_folder" ]; then
                     cd $sub_folder
                     echo "Now in $(pwd)"
                        for file in *log; do
                            if [ -f "$file" ]; then
                                gzip $file
                                echo "$file"
                                echo "gzip $file done"
                            fi
                        done
                 fi
             done
    fi
done
