#!/bin/bash
set -e

SRC="/mnt/c/Users/Admin/Downloads/hoso/Resume_NguyenQuocTuan.pdf"
DST="$(cd "$(dirname "$0")" && pwd)/cv-nguyen-quoc-tuan.pdf"

if [ ! -f "$SRC" ]; then
  echo "✗ Không tìm thấy $SRC"
  exit 1
fi

if cmp -s "$SRC" "$DST" 2>/dev/null; then
  echo "= CV không đổi, không cần push."
  exit 0
fi

cp "$SRC" "$DST"
cd "$(dirname "$DST")"
git add cv-nguyen-quoc-tuan.pdf
git commit -q -m "Update CV"
git push -q
echo "✓ Đã cập nhật CV trên https://tuan2k33.github.io/"
