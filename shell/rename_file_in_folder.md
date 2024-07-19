#! /bin/sh
# 
# Rename Multifiles
MEDIA_DIR='/Users/vinasupport/Movies'
NO=1
# Excecute
cd $MEDIA_DIR
for file in *.mp4; do
    if [[ $NO == 100 ]] 
    then
        break
    fi
    mv "$MEDIA_DIR/$file" "/$MEDIA_DIR/video_$NO.mp4"
    ((NO=NO+1))
done

Lưu ý: biến $NO == 100 tức là chỉ đổi tên 100 file đầu tiên thôi
