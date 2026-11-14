# Unit3 source-text normalizer

## Unit1 cross-unit confirmation

Unit1's complete `sub_005D31EC` listing independently matches this
transformation: it applies the same ordered `..`, `HK`, `vo.r`, and `na.ch`
branches, then the same trimmed-input guard, repeated `Copy(value, 2, 9)`
leading-byte loop, period removal, and insertion before the first byte below
`':'`. The retained `TForm1` listing calls it from multiple parser/list
paths; those callers remain outside this helper slice.

The current FPC `TForm1.Proc_005D32CC` now delegates to
`NormalizeUnit3SourceText` rather than carrying a second copy of the
transformation. A focused parity test compares the form method to the shared
helper for all four special branches, fixed-length leading trimming, standard
punctuation processing, and blank input. The main-form helper tests pass 4/4;
the standalone normalizer tests pass 7/7. No parser, provider, file, or UI
caller was activated.

## Recovered contract

The retained `Projects_AhnenWin\Unit3.pas` listing at `00576FF8` takes an
input string and output string. The output initially receives the input.
These tests and transformations then occur in this order:

1. If `Trim(input) = '..'`, return an empty string.
2. If the first two characters are exactly `HK`, return `HK ` followed by
   `Copy(input, 4, 7)`.
3. If the case-sensitive substring `vo.r` occurs anywhere, return the first
   two input characters, character four, a space, then `RightStr(input, 4)`.
4. Otherwise, if `na.ch` occurs, return the first two characters, characters
   four and five, a space, then the last four characters.
5. If trimming the input is empty, preserve the original string.
6. Repeatedly remove a leading period or space by assigning
   `Copy(input, 2, 9)`. This removes runs of those characters but also truncates
   the intermediate value to at most nine characters on each pass.
7. If the resulting first byte is at most ASCII `'9'`, return that string.
   Otherwise remove every period, then insert one space before the first byte
   whose value is less than ASCII `':'`. If no such byte exists, insert
   nothing.

The implementation uses literal, case-sensitive searches and byte-valued
character comparisons. It preserves the fixed-position slices and the
repeated nine-character `Copy` limit rather than normalizing malformed inputs
into a cleaner format. A nonempty trimmed string containing only leading dots
or spaces can reduce to an empty output. Empty/whitespace-only input bypasses
that cleanup and remains unchanged.

The retained Unit3 listing calls this helper from multiple parser routines
(for example at `005848B6`, `00584A95`, `00584CD6`, and a series of later
event handlers). This establishes a shared parsing utility, not permission to
reactivate any caller: several caller paths access datasets and mutate state.

## Independent listing corroboration

The retained `Projects_AhnenWin\Unit17.pas` listing at `0053D06C` and
`Projects_AhnenWin\Unit19.pas` listing at `00550DA0` independently repeat the
same string-to-string transformation. Their control-flow order, special
tokens (`..`, `HK`, `vo.r`, `na.ch`), fixed slices, repeated nine-character
copy, byte comparisons, period removal, and first qualifying space insertion
match the Unit3 routine. Neither routine body reads its owning form, global
state, datasets, files, or UI; their callers use them to normalize generated
strings. This independently corroborates the existing helper and does not
justify duplicate implementations or wiring these legacy callers.

## Synthetic reconstruction

`Source\AhnWin52\Forms\Unit3SourceTextNormalizer.pas` reconstructs the
provider-free string transformation. Focused tests cover each special case,
case sensitivity, fixed slices, leading cleanup/truncation, period removal,
space insertion, numeric-leading values, and blank inputs. It is not wired
into production parser or database paths. The focused suite passes 7/7, the
complete FPCUnit suite passes 536/536, and the test project builds.
