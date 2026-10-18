# Unit10 Gregorian Easter computus

## Evidence and scope

The IDR listing in `Source\Projects_AhnenWin\Unit10.pas` contains
`TForm10.rechnen` at `0055A54C`. The routine validates a year in the range
1582–2499, then calculates Gregorian Easter before writing an XML calendar
file. The integer calculation was extracted into
`Source\AhnWin52\Model\GregorianCalendarModel.pas` as
`CalculateGregorianEasterDate`.

This reconstruction covers the pure Easter date calculation and the
subsequent 13-date weekly sequence. It does not reconstruct or invoke the
`ostern.xml` writer, UI state, or browser launch.

## Recovered formula

For a supported year `Y`, the listing computes:

```text
a = Y mod 4
b = Y mod 19
c = Y mod 7
K = Y div 100
Q = ((8*K + 13) div 25) - 2
M = (K - (Y div 400) - 2 + 15 - Q) mod 30
N = (K - (Y div 400) - 2 + 6) mod 7
D = (19*b + M) mod 30
```

It then applies the two epact corrections in listing order:

```text
if D = 29: D := 28
else if D = 28 and b >= 11: D := 27
```

The weekday offset and final date are:

```text
W = (2*a + 4*c + 6*D + N) mod 7
Easter = 21 March Y + D + W + 1 day
```

The underlying assembly uses hexadecimal immediates: `13` is decimal 19,
`1D` is 29, `1C` is 28, and `0B` is 11. These values and operation order
were followed in the standalone helper.

## Validation

The focused model tests assert known dates at the Gregorian reform and
century/leap-century boundaries: 1582-04-18, 1900-04-15, 2000-04-23,
2024-03-31, 2100-03-28, and 2499-03-29. They also check every supported year
to ensure the result is a Sunday within 22 March–25 April and reject years
outside 1582–2499. These computus tests passed before adding the weekly
sequence tests; the current complete FPCUnit suite passes 545/545.

The helper is not wired to the legacy `TForm10.rechnen` path. The XML field
layout and holiday-name/XML behavior remain separate reconstruction work.

## Weekly liturgical-date sequence

After computing Easter, the original routine adds the computed Easter day
offset, then `1`, then subtracts `63` days before entering the date-output
loop. That loop initializes its counter to 1 and repeats while the counter is
not 13; on each pass it emits the current date, then adds seven days. The
standalone `BuildLiturgicalSundayDates` reproduces only that date calculation:
13 dates, Easter minus 63 days through Easter plus 21 days, inclusive.

The fixed-width holiday string contains 18 twelve-character labels:
Septuagesima, Sexagesima, Estomihi, Invocavit, Reminiscere, Oculi, Laetare,
Judica, Palmarum, Ostern, Quasimodo, Misericordia, Jubilate, Cantate, Rogate,
Exaudi, Pfingsten, and Trinitatis. However, the output loop executes only
13 times and reads only the first 13 slots, ending with Jubilate. The remaining
five labels are not emitted by this loop; their intended purpose is unknown
and is not inferred here.

Tests verify the 13-date count, the 2024 sequence endpoints (2024-01-28 through
2024-04-21), Easter at zero-based index 9, all dates on Sunday, and seven-day
spacing for every supported year. The focused calendar-model suite passes
9/9 and the full FPCUnit suite passes 545/545. No output file or application
route is exercised.

## XML document lines recovered as an in-memory slice

The IDR body at `0055A54C` also establishes the emitted row shape. Each loop
pass writes a `<tbl><tab>NAME</tab><tab><rb>dd.mm.yyyy</rb></tab></tbl>` line.
The first 13 fixed-width names are, in order, Septuagesima, Sexagesima,
Estomihi, Invocavit, Reminiscere, Oculi, Laetare, Judica, Palmarum, Ostern,
Quasimodo, Misericordia, and Jubilate. The `Ostern` label is surrounded by
separate `<uesu>` and `</uesu>` lines. The routine also tests for `Pfingsten`,
but that slot is after Jubilate and is never reached by its 13-iteration loop.

`Reports\Unit10EasterXmlRows.pas::BuildUnit10EasterXmlOutputLines` constructs
these 15 in-memory row/wrapper lines. The companion
`BuildUnit10EasterXmlDocumentLines` adds the statically observed declaration,
stylesheet instruction, conversion comment, and outer document tags/title,
for 26 lines total. The title uses the supplied integer year, and dates use a
fixed numeric format; neither requires the legacy
`StrToDate('21.03.' + year)` conversion.

The conversion-comment version required resolving conflicting evidence.
`Projects_AhnenWin\Unit10.pas` and the retained machine-code listing at
`0055A5DF` show `AHNENWIN 5.1 (2013)`, while the current
`Source\AhnWin52\Unit10.pas` Pascal constant says `5.2 (2019)`. A read-only
search of the supplied `C:\ProgramData\AHNENWIN Test\AHNWIN51.exe`
(SHA-256 `817c1b1bb23469cd628c52e4a5ea26cb4db26275b5ec84952717b218605f0aff`)
found the exact 5.1/2013 comment and not the 5.2/2019 variant. This helper
therefore models that supplied AHNWIN51 executable; the source/listing
disagreement remains explicit.

Tests assert the full 2024 row sequence, document header/title/outer tags, and
both supported-year boundaries; years outside 1582–2499 are rejected by the
model. Focused XML tests pass 4/4; the complete FPCUnit suite passes 549/549.
All generated lines are ASCII. The helper does not create or encode a file:
the `ISO-8859-1` declaration does not prove Delphi `TextFile` output bytes.
It also does not reproduce partial-file behavior for invalid years,
`Assign`/`Rewrite`/`WriteLn` errors, UI state, dialogs, or browser navigation.
It is not wired to `TForm10`.
