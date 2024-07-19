Đọc và xử lý tham số trong Shell Script

/bin/bash my-script.sh <param_1> <param_2> ... <param_n>

```
#!/bin/bash
# Path of the script
echo "Script: $0"
# List of the parameter
echo "Parameter:"
echo "- Fruit: $1"
echo "- Flower: $2"
echo "- Vehicle: $3"
```

Đọc toàn bộ tham số trong shell scripts

```
#!/bin/bash
# List all prameters
for PARAM in "$@"
do
echo "Param: $PARAM"
done
```
