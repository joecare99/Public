# Unit3 six-character integer formatter

## Recovered contract

The retained `Projects_AhnenWin\Unit3.pas` listing at `00576EB0` accepts a
32-bit integer and an output string. It converts the integer with `IntToStr`,
concatenates six zero characters before it, then takes six characters starting
at `Length(concatenatedValue) - 5`.

For nonnegative values, this yields six decimal characters with leading zeros
for values shorter than six digits. For values longer than six digits, it
discards leading characters and keeps the last six. The same operation is
applied to signed decimal text without sign-aware handling: `-1` becomes
`0000-1`, `-1234` becomes `0-1234`, and `-12345` becomes `-12345`.
These unusual signed results and truncation are literal consequences of the
assembly sequence, not recommended formatting behavior.

## Synthetic reconstruction

`Source\AhnWin52\Forms\Unit3SixCharacterInteger.pas` implements the exact
string construction and `Copy` range as a pure helper. Focused tests cover
zero-padding, the six-digit boundary, truncation for values above six digits,
negative values, and the minimum signed 32-bit integer.

The retained Unit3 listing does not show a call site for `00576EB0`, so this
note documents the routine contract only and does not claim caller semantics.
The helper is not wired into production code. The focused suite passes 4/4;
the complete FPCUnit suite passes 526/526, and the test project builds.
