#!/bin/bash
# Split the 2-page resume (EN page + VI page) into cv-nguyen-quoc-tuan-en.pdf and -vi.pdf (the combined cv-nguyen-quoc-tuan.pdf is left alone), then push.
set -e

SRC="/mnt/c/Users/Admin/Downloads/hoso/Resume_NguyenQuocTuan.pdf"
DIR="$(cd "$(dirname "$0")" && pwd)"
STAMP="$DIR/.cv-source.sha256"
SITE="https://tuan2k33.github.io"

if [ ! -f "$SRC" ]; then
  echo "✗ Không tìm thấy $SRC"
  exit 1
fi

HASH=$(sha256sum "$SRC" | cut -d' ' -f1)
if [ "$(cat "$STAMP" 2>/dev/null)" = "$HASH" ]; then
  echo "= CV không đổi, không cần push."
  exit 0
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

echo "$HASH" > "$STAMP"
cd "$DIR"
git add index.html cv-nguyen-quoc-tuan-en.pdf cv-nguyen-quoc-tuan-vi.pdf .cv-source.sha256 sync-cv.sh
git commit -q -m "Update CV (EN and VI)"
git push -q
echo "✓ Đã cập nhật CV: $SITE/cv-nguyen-quoc-tuan-en.pdf và -vi.pdf"
