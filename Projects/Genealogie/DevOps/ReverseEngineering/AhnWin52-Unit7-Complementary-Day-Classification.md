# Unit7 complementary-day classification

## Recovered boundary

The pure classifier `ClassifyFrenchRepublicanComplementaryDay` isolates the
bounded branch in `TForm7.berechnen` (`Projects_AhnenWin\Unit7.pas`,
`005CEB5C`–`005CECA4`). The listing first distinguishes ordinary days from
text lexically greater than `'30'` and less than `'jrev'`; the exact `'jrev'`
entry is checked in the following branch. Combined, the recognized range is
`DayText > '30'` and `DayText <= 'jrev'`.

These complementary entries are accepted only when the trimmed month is
exactly `Fructidor` and the year combo index is 2, 6, or 10. Other recognized
entries are invalid. The form adds the day combo index for accepted entries;
invalid entries call `ShowMessage('Diesen Tag gibt es nicht.')`, clear `Edit1`,
and exit. The classifier itself has no UI effects. It preserves the original
case-sensitive lexical comparisons and month trimming.

`FrenchRepublicanCalendarForm.berechnen` now delegates only this classification
decision to the helper. Date parsing, date arithmetic, result formatting,
locale behavior, cutoff handling, and the modal message remain in the form.
The supported synthetic UI tests continue to cover leap complementary dates.

## Validation and safety boundary

- The test project builds with FPC 3.2.2.
- Pure classifier tests pass 4/4.
- Existing calendar-form tests pass 14/14.
- The full suite was not run in this continuation; in particular, the known
  About-form click test that produced Access Violations was not rerun.
- An initial attempt to test the invalid form path used a hook for
  `Application.MessageBox`, which does not suppress `ShowMessage`. It opened
  the expected “Diesen Tag gibt es nicht” dialog. That UI test was removed;
  the classifier is tested directly, and the invalid form path was not invoked
  again.

No original application, database, report, or production date was used.
