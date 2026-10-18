import re
import sys
import zlib
from pathlib import Path


def validate_pdf(path: Path) -> None:
    data = path.read_bytes()
    if not data.startswith(b"%PDF-"):
        raise ValueError("PDF signature is missing")
    if not data.rstrip().endswith(b"%%EOF"):
        raise ValueError("PDF end marker is missing")

    pages = re.findall(rb"/Type\s*/Page\b", data)
    if len(pages) != 2:
        raise ValueError(f"expected 2 pages, found {len(pages)}")

    boxes = re.findall(rb"/MediaBox\s*\[([^\]]+)\]", data)
    expected_boxes = [b"0 0 595 842", b"0 0 842 595"]
    if boxes != expected_boxes:
        raise ValueError(f"unexpected page dimensions/orientation: {boxes!r}")

    if b"Synthetic SynPDF Probe" not in data:
        raise ValueError("document title metadata is missing")

    rendered_streams = []
    for match in re.finditer(rb"stream\r?\n", data):
        start = match.end()
        header = data[max(0, match.start() - 256) : match.start()]
        lengths = list(re.finditer(rb"/Length\s+(\d+)", header))
        if not lengths:
            continue
        stream_length = int(lengths[-1].group(1))
        stream_end = start + stream_length
        if stream_end > len(data):
            continue
        if not data[stream_end:].startswith(b"\nendstream") and not data[
            stream_end:
        ].startswith(b"\r\nendstream"):
            continue
        stream_data = data[start:stream_end]
        if b"FlateDecode" in header:
            try:
                stream_data = zlib.decompress(stream_data)
            except zlib.error:
                continue
        rendered_streams.append(stream_data)

    if sum(b"Synthetic SynPDF page" in stream for stream in rendered_streams) != 2:
        raise ValueError("synthetic canvas text was not rendered on both pages")

    print(
        f"Valid PDF: {path} ({len(data)} bytes, 2 pages, "
        "A4 portrait+landscape, metadata and rendered canvas text)"
    )


if __name__ == "__main__":
    if len(sys.argv) != 2:
        raise SystemExit("Usage: python validate_pdf.py <probe.pdf>")
    validate_pdf(Path(sys.argv[1]))
