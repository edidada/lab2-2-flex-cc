#!/bin/bash

# 创建测试结果文件
echo "# Test Results" > my.md
echo "" >> my.md

# 测试用例1
echo "## Test Case 1" >> my.md
echo '```' >> my.md
./build/scanner test_cases/case_1.c >> my.md
echo '```' >> my.md
echo "" >> my.md

# 测试用例2
echo "## Test Case 2" >> my.md
echo '```' >> my.md
./build/scanner test_cases/case_2.c >> my.md
echo '```' >> my.md
echo "" >> my.md

# 测试用例3
echo "## Test Case 3" >> my.md
echo '```' >> my.md
./build/scanner test_cases/case_3.c >> my.md
echo '```' >> my.md
echo "" >> my.md

# 测试用例4
echo "## Test Case 4" >> my.md
echo '```' >> my.md
./build/scanner test_cases/case_4.c >> my.md
echo '```' >> my.md
echo "" >> my.md

# 测试用例5
echo "## Test Case 5" >> my.md
echo '```' >> my.md
./build/scanner test_cases/case_5.c >> my.md
echo '```' >> my.md

echo "测试结果已保存到 my.md 文件"