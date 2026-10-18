# Unit3 numeric place-prefix reordering

## Recovered contract

The retained `Projects_AhnenWin\Unit3.pas` listing at `0057893C` is a
two-string-parameter transformation. It first copies the input unchanged to
the output. It then checks only the first character against `1234567890`.
If that character is not a digit, the input remains unchanged, including any
leading or trailing whitespace.

For a numeric first character, it finds the first literal space. The output
becomes:

`Copy(input, firstSpace + 1, Length(Trim(input))) + ' ' + Copy(input, 1, firstSpace - 1)`

The listing uses the trimmed length as the copy count but slices the original
input. This preserves some non-obvious legacy results: a digit-leading value
without a space gets a trailing space; and trailing spaces can remain in the
reordered suffix. Only the first space divides the parts. These details are
retained rather than normalized.

The independent listing contains calls from several Unit3 routines, including
the early parsing/report helpers and later GEDCOM-related paths. That supports
the string transformation's use, but does not establish that any complete
caller is safe to activate.

## Synthetic reconstruction

`Source\AhnWin52\Forms\Unit3PlacePrefixReordering.pas` implements the
transformation without database or UI dependencies. Focused tests cover
unchanged nonnumeric input, ordinary reordering, first-space handling, the
no-space trailing delimiter, and leading-whitespace behavior. The helper is
not wired into the inert `PersonSearchForm.Ortdreh` method or provider-backed
callers. The focused suite passes 5/5, and the complete FPCUnit suite passes
522/522.
