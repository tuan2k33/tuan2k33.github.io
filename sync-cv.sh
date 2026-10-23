#!/bin/bash
# Publish the 2-page resume (EN page + VI page) as cv-nguyen-quoc-tuan.pdf (both pages), -en.pdf and -vi.pdf, then push.
set -e

SRC="/mnt/c/Users/Admin/Downloads/hoso/Resume_NguyenQuocTuan.pdf"
DIR="$(cd "$(dirname "$0")" && pwd)"
ALL="$DIR/cv-nguyen-quoc-tuan.pdf"
STAMP="$DIR/.cv-source.sha256"
SITE="https://tuan2k33.github.io"

if [ ! -f "$SRC" ]; then
  echo "✗ Không tìm thấy $SRC"
  exit 1
fi

uv run --quiet --with pypdf python - "$SRC" "$DIR" <<'PY'
import sys
from pypdf import PdfReader, PdfWriter

src, out = sys.argv[1:3]
r = PdfReader(src)
assert len(r.pages) == 2, f"expected 2 pages (EN, VI), got {len(r.pages)}"
for i, lang in ((0, "en"), (1, "vi")):
    w = PdfWriter()
    w.add_page(r.pages[i])
    w.write(f"{out}/cv-nguyen-quoc-tuan-{lang}.pdf")
PY

cp "$SRC" "$ALL"
echo "$HASH" > "$STAMP"
cd "$DIR"
git add .
git commit -q -m "Update CV (EN and VI)"
git push -q
echo "✓ Đã cập nhật CV: $SITE/cv-nguyen-quoc-tuan.pdf, -en.pdf và -vi.pdf"
