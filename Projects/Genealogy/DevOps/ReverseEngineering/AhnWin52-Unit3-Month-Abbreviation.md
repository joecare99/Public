# Unit3 month abbreviation helper

## Recovered contract

The retained `Projects_AhnenWin\Unit3.pas` listing at `00577544` is a
two-string-parameter procedure: its first argument is read as an ANSI string,
and its second argument receives the output. It searches that input in the
concatenated token list
`JANFEBMARMÄRAPRMAYMAIJUNJULAUGSEPOCTOKTNOVDECDEZ`. Only positions at the
start of a token map to a month number:

| Token | Result |
|---|---|
| `JAN` | `01` |
| `FEB` | `02` |
| `MAR`, `MÄR` | `03` |
| `APR` | `04` |
| `MAY`, `MAI` | `05` |
| `JUN` | `06` |
| `JUL` | `07` |
| `AUG` | `08` |
| `SEP` | `09` |
| `OCT`, `OKT` | `10` |
| `NOV` | `11` |
| `DEC`, `DEZ` | `12` |

If the position is not a mapped token start, the procedure trims the input
and returns its first two characters. Matching is case-sensitive and occurs
before trimming. The listing text renders the umlaut in `MÄR` as `�`, but a
read-only byte inspection of that literal shows `4D C4 52`; the helper keeps
the middle byte as `$C4`, matching the retained ANSI token bytes.

`TForm3.zsa` calls this helper at seven sites (`00577B8B`, `00577C56`,
`00577D30`, `00577E60`, `00578144`, `005783A2`, and `00578692`). Each
extracts a three-character substring from the date text before the call.
The helper therefore receives month-like tokens in these observed calls; the
fallback remains part of the standalone helper contract.

## Synthetic reconstruction

`Source\AhnWin52\Forms\Unit3MonthAbbreviation.pas` reconstructs the
provider-free transformation. Tests cover all 16 listed tokens, fallback
trimming/truncation (including empty input), case sensitivity, and the
no-trim-before-match behavior. They also retain the original position-based
lookup behavior: a prefix that begins at a token start (`JA`) maps, while a
substring beginning inside a token (`AN`) falls back. The focused suite passes
3/3 and the full FPCUnit suite passes 517/517. This helper has not been wired
into `zsa` or any provider-backed producer. The original `TForm3.zsa` date
parsing and report/data paths remain outside this reconstruction.
