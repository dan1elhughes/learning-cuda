#!/usr/bin/env bash

if [ "$#" -lt 1 ]; then
	echo "Usage: $0 <source file>"
	exit 1
fi

file="$1"

nvcc "$file.cu" -o "$file.exe"

echo -e "\n\n\n===\n"

./"$file.exe"
