# Unit19 three-character space-padded integer formatter

## Recovered contract

The retained `Projects_AhnenWin\Unit19.pas` listing at `00550B5C` takes a
32-bit integer and an output string. It concatenates three spaces with
`IntToStr(value)`, computes `Length(concatenatedValue) - 2`, and copies three
characters from that one-based position.

The result is right-aligned for short positive decimal values, but the
operation is not sign-aware and truncates longer text. Examples include
`0 -> '  0'`, `12 -> ' 12'`, `1234 -> '234'`, `-1 -> ' -1'`, and
`-123 -> '123'`. The Unit19 caller is report/list logic with database-backed
state; this helper reconstruction does not restore or activate those callers.

## Synthetic reconstruction

`Source\AhnWin52\Forms\Unit19ThreeCharacterSpaceInteger.pas` preserves the
concatenation and copy range directly. Focused tests cover right alignment,
truncation, and the legacy negative-value placement. The helper is standalone
and is not wired into production paths. The test project builds, and the
focused suite passes 3/3.
