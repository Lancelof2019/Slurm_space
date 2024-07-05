#!/bin/bash

# 确保传递了一个参数
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <filepath>"
    exit 1
fi

# 使用 AWK 命令计算最大值
max_value=$(awk -F',' 'NR > 1 { if ($1 > max) max = $1; if ($2 > max) max = $2 } END { print max }' "$1")
echo "The community number is :"$max_value
# 使用 sed 提取 'UCEC' 或类似标记
filename=$(basename "$1" | sed -n 's/^\(.*\)_selected_features01\.csv/\1/p')
echo "The cancer_type is:"$filename


export MAX_VALUE=$max_value

export FILENAME=$filename

