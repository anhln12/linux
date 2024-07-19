Bài viết này sẽ hướng dẫn các bạn, tạo 1 câu hỏi (Confirmation Prompt) để người dùng xác nhận (Yes/No) trong lập trình Shell Script (Bash)
```
#!/bin/bash
read -r -p "Are you sure? [y/N] " response
response=${response,,}    # tolower
if [[ "$response" =~ ^(yes|y)$ ]]
then
    echo "You have entered y"
else
    echo "You have entered n"
fi
```
