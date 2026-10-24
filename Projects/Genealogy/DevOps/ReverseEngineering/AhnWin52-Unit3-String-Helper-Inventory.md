# Unit3 string-helper candidate inventory

## Scope

Reviewed the retained `Source\Projects_AhnenWin\Unit3.pas` listing beginning
with the helper cluster at `00576EB0` and continuing through the GEDCOM event
handlers near `005BEF5C`. A targeted cross-unit scan also checked the string
helpers in Units 1, 13, 17, and 18. The purpose was to identify another
complete, provider-free transformation suitable for standalone
reconstruction, not to activate any legacy caller.

## Candidates already reconstructed

The pure helper cluster at the start of the listing is already represented by
standalone, tested helpers:

| Address | Behavior | Reconstruction |
|---|---|---|
| `00576EB0` | Six-character zero-padded/suffix integer formatter | `Unit3SixCharacterInteger` |
| `00576F54` | Six-character space-padded/suffix integer formatter | `Unit3SixCharacterSpaceInteger` |
| `00576FF8` | Source-text normalization with fixed slices and byte comparisons | `Unit3SourceTextNormalizer` |
| `00577544` | Month-token to two-digit month mapping with fallback | `Unit3MonthAbbreviation` |

Their current scope and edge cases are documented in the corresponding
`AhnWin52-Unit3-*.md` notes. These adapters remain standalone and are not
wired into provider-backed routes.

The byte-level special mappings from `TForm1.ucase`/`TForm3.ucase` are now
implemented as the standalone `Forms\Unit1ByteUppercase.pas` helper. It maps
`$E4->$C4`, `$F6->$D6`, and `$FC->$DC`; all other bytes are passed individually
through `SysUtils.UpperCase`, matching the original call shape. Focused tests
cover each mapping, mixed byte order, ASCII fallback, and empty input. The
helper is not wired into any legacy form or provider-backed route. Exact
Delphi-versus-FPC `UpperCase` behavior for other high bytes remains unverified;
only the three explicit mappings are confirmed against the executable.

## Cross-unit corroboration

The `Unit3` source-text normalizer at `00576FF8` has independently matching
implementations in `Unit13` at `00563A0C` and `Unit18` at `00545A0C`. Their
assembly listings repeat the same ordered branches and fixed-position
operations: trimmed `..` clears the result; `HK`, `vo.r`, and `na.ch` use the
same slices; the fallback removes leading dot/space bytes using
`Copy(value, 2, 9)`, then applies the same digit, period-removal, and
space-insertion rules. This cross-unit match corroborates the existing
reconstruction. It does not establish that the separate form callers are
safe to activate.

Unit19 also contains independent copies of three existing helper contracts:
`00550AB8` repeats the six-character zero-padded integer suffix operation,
and `00550BFC` repeats the byte-wise uppercase conversion with explicit
`$E4->$C4`, `$F6->$D6`, and `$FC->$DC` mappings plus an `UpperCase` fallback.
The six comparison/output bytes were read from the previously supplied
executable at their IDR literal addresses. These are corroborations only; the
Unit19 database/report callers remain inactive.

The adjacent Unit19 routine `00550B5C` is a distinct, complete pure helper:
it prepends three spaces to `IntToStr(value)` and copies three characters from
`Length(value)-2`. It is reconstructed separately as
`Unit19ThreeCharacterSpaceInteger`; do not substitute the six-character
Unit3 formatter. Focused tests cover the exact three-character behavior.

## Additional cross-unit helper screen

A follow-up scan compared the small standalone helper routines in
`Unit1.pas`, `Unit13.pas`, `Unit19.pas`, and `Unit26.pas`. The following
listings independently repeat existing helper contracts:

| Listing address | Corroborated behavior |
|---|---|
| Unit1 `005D3148` | Six-character zero-prefixed integer suffix |
| Unit13 `005637C4` | Six-character zero-prefixed integer suffix |
| Unit13 `00563868` | Byte-wise uppercase with the three explicit German-byte mappings and `UpperCase` fallback |
| Unit19 `00550AB8` | Six-character zero-prefixed integer suffix |
| Unit19 `00550BFC` | Byte-wise uppercase with the same three mappings and fallback |
| Unit26 `0054F810` | Six-character zero-prefixed integer suffix |

These repeated copies strengthen existing reconstructions but do not justify
duplicate helper units or production wiring. Unit1's adjacent
`005D39D8` calls `FloatToStr` and right-aligns its output; its exact parameter
contract and locale-specific formatting are not resolved. `005D3A70` combines
`StrToDate`, `DaysInAMonth`, string inputs, and swallowed conversion
exceptions; without the original date-format settings and fully established
caller contract, it is not a deterministic helper boundary. Neither routine
was ported or executed.

The remaining nearby Unit13 internal routines were also screened:
`0056897C` through `00569010` mutate the shared
`gvar_011AE35C` array; `0056CAD4` scans and changes shared array state; and
`0057316C`/`00573314` access canvas/form objects, rendering mode globals, and
other Unit13 methods. They are not standalone transformations and were not
ported or invoked.

Unit1 `005D7C50` independently corroborates the current weekday-abbreviation
helper: it calls `StrToDate`, catches parse exceptions, then maps
`DayOfWeek` 1–7 to `So`, `Mo`, `Di`, `Mi`, `Do`, `Fr`, and `Sa`. It is not a
new pure parsing contract because the active date format remains locale
dependent. Evidence and this boundary are documented in
`AhnWin52-Unit1-Weekday-Abbreviation-Corroboration.md`.

Unit1 `005D31EC` also independently duplicates the full source-text normalizer
from Unit3 `00576FF8`. The existing `TForm1.Proc_005D32CC` already represented
that behavior but carried a second implementation; it now delegates to
`NormalizeUnit3SourceText`. Differential tests cover the ordered special
cases and fixed-slice fallback without calling any production parser route.
See `AhnWin52-Unit3-Source-Text-Normalizer.md`.

## Remaining candidates and gates

- The second decompilation tree `Source\Projects_AhnenWin` is explicitly
  marked `Decompiled by IDR v.01.04.2017` in `Unit1.pas`. Its `TForm1.ucase`
  listing at `005D7AA8` was the listing analyzed above. The same tree contains
  a second implementation, `TForm3.ucase` at `00583788` in `Unit3.pas`;
  instruction-level comparison shows the same `$E4`/`$F6`/`$FC` dispatch,
  three one-byte literal comparisons/appends, and `UpperCase` fallback. IDR
  renders the special-case literals as `�`; their bytes were recovered from
  the original executable described below.
- `005772E4` reads and writes a `TDataModule2` component field through virtual
  field accessors. It is not a pure string transform.
- `005773C4` (`TForm3.lieszeil`) reads lines from a text record and changes
  global parser state. Its behavior depends on file input and caller state.
- `00577934` parses with `StrToDate`, decomposes the resulting date, and writes
  global date-part strings and flags. This depends on Delphi date-format
  settings and invalid-date exception behavior, so it is not safe to port as
  a deterministic parser until those runtime settings and failure semantics
  are established.
- `00577834` (`TForm3.zsa`) branches on a global encoding setting and calls
  `Utf8ToAnsi`, `OemToCharA`, or `ansl`; it is encoding/runtime dependent.
- `Unit1`'s `TForm1.ucase` at `005D7AA8` walks the `AnsiString` byte by byte.
  It branches specially on input bytes `$E4`, `$F6`, and `$FC`; for each, it
  compares the one-byte substring with a literal and appends a separate
  literal on a match. Other bytes are converted one at a time with Delphi's
  `UpperCase`. The IDR text renders all six comparison/output literals as
  U+FFFD, but the original executable bytes confirm the mappings:

  | Input byte | Compared literal | Appended output byte |
  |---:|---:|---:|
  | `$E4` | `$E4` | `$C4` |
  | `$F6` | `$F6` | `$D6` |
  | `$FC` | `$FC` | `$DC` |

  `TForm3.ucase` at `00583788` has the same literals and branch structure.
  These are byte-level facts from the executable; the fallback behavior still
  delegates to Delphi `UpperCase`, so reproducing its locale/code-page behavior
  outside the original Delphi runtime is a separate compatibility question.
- `Unit17.TForm17.gebstvn` reads checkboxes and DataModule fields and invokes
  `FindKey`; it composes report text but is not a pure helper.
- `Unit18`'s string-parameter normalizer is the already-correlated duplicate
  described above, not a new helper candidate.
- The later string-parameter handlers from `005BD73C` through `005BEF5C`
  read/write DataModule fields and, in several paths, use `TTable`,
  `FindKey`, `Edit`, `Append`, or `Post`. They are provider-backed import
  operations, not isolated transforms.

## Original executable byte evidence

The user supplied
`C:\ProgramData\AHNENWIN Test\AHNWIN51.exe` for read-only inspection. It is a
PE32 image with preferred image base `$00400000`; its `CODE` section has RVA
`$1000` and raw file offset `$400`. Thus a VA in that section maps to
`$400 + (VA - $00401000)`. The entry bytes at `005D7AA8` and `00583788` match
the corresponding IDR procedure prologues.

| VA referenced by IDR | Meaning | File offset | Literal data bytes |
|---:|---|---:|---|
| `$005D7C10` | compare `$E4` | `$001D7010` | `E4 00` |
| `$005D7C1C` | append uppercase | `$001D701C` | `C4 00` |
| `$005D7C28` | compare `$F6` | `$001D7028` | `F6 00` |
| `$005D7C34` | append uppercase | `$001D7034` | `D6 00` |
| `$005D7C40` | compare `$FC` | `$001D7040` | `FC 00` |
| `$005D7C4C` | append uppercase | `$001D704C` | `DC 00` |
| `$005838F0` | compare `$E4` (TForm3) | `$00182CF0` | `E4 00` |
| `$005838FC` | append uppercase (TForm3) | `$00182CFC` | `C4 00` |
| `$00583908` | compare `$F6` (TForm3) | `$00182D08` | `F6 00` |
| `$00583914` | append uppercase (TForm3) | `$00182D14` | `D6 00` |
| `$00583920` | compare `$FC` (TForm3) | `$00182D20` | `FC 00` |
| `$0058392C` | append uppercase (TForm3) | `$00182D2C` | `DC 00` |

The inspected file was 3,001,856 bytes with SHA-256
`817c1b1bb23469cd628c52e4a5ea26cb4db26275b5ec84952717b218605f0aff`.
The executable was not launched; only PE metadata and bytes at the cited
code/literal addresses were read.

## Decision

The special-byte mapping for `ucase` is recovered from the original
executable and independently confirmed at both IDR routine addresses. The
standalone implementation and all 4 focused tests pass; the full suite passes
540/540. Delphi `UpperCase` fallback parity for other high bytes remains
unverified, and the helper is not wired into legacy callers. Revisit `00577934`
only after the original date-format configuration and exception contract are
known. Do not use a string-only signature as evidence that a procedure is
pure.
