#!/bin/bash

# 确保环境变量 MAX_VALUE 已经设置
if [ -z "$MAX_VALUE" ]; then
    echo "MAX_VALUE is not set"
    exit 1
fi

# 备份原始脚本
cp -rp sbatchtasktry02.sh sbatchtasktry02.sh.bak

# 替换 ${MAX_VALUE} 为实际的环境变量值
sed -i "s/\${MAX_VALUE}/$MAX_VALUE/g" sbatchtasktry02.sh

echo $MAX_VALUE
echo $FILENAME

# 使用 nohup 提交作业，并将输出重定向到文件
nohup sbatch sbatchtasktry02.sh >$FILENAME.out 2>&1 &
sleep 5  # 等待几秒确保作业提交信息已经写入文件


cp -rp  sbatchtasktry02.sh.bak sbatchtasktry02.sh

# 从输出文件中提取作业 ID
job_id=$(awk '/Submitted batch job/ {print $4}' $FILENAME.out)

if [ -z "$job_id" ]; then
    echo "Failed to capture job ID."
    # 回滚到原始文件
    cp -rp  sbatchtasktry02.sh.bak sbatchtasktry02.sh
    exit 1
else
    echo "sbatch submission successful, job ID captured: $job_id"
fi

# 创建一个新的作业用于恢复文件，这个作业在前一个作业结束后运行
sbatch --dependency=afterany:$job_id <<-EOF
#!/bin/bash
# 恢复 sbatchtasktry02.sh 文件
sed -i "s/$MAX_VALUE/\${MAX_VALUE}/g" sbatchtasktry02.sh
mv sbatchtasktry02.sh.bak sbatchtasktry02.sh
EOF

