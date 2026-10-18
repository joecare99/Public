# Unit3 six-character space-padded integer formatter

## Recovered contract

The retained `Projects_AhnenWin\Unit3.pas` listing at `00576F54` accepts an
integer and output string. It concatenates six spaces with `IntToStr(value)`,
then copies six characters starting at `Length(concatenatedValue) - 5`.

This right-aligns ordinary short decimal strings in a six-character result,
but is not sign-aware and truncates values longer than six characters. For
example, `0` becomes five spaces followed by `0`, `-1` becomes four spaces
followed by `-1`, and `1234567` becomes `234567`.

No call site for this routine appears in the retained Unit3 listing; its
contract is documented without inferring a specific application use. The
focused suite passes 3/3; the complete FPCUnit suite passes 529/529, and the
test project builds.

## Synthetic reconstruction

`Source\AhnWin52\Forms\Unit3SixCharacterSpaceInteger.pas` preserves the
concatenation and copy range directly. Focused tests cover space alignment,
the six-character boundary, truncation, and signed values. The helper is not
wired into production code.
