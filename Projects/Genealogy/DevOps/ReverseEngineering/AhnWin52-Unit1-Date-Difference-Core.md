# Unit1 validated date-difference core

## Recovered boundary

`TForm1.Proc_005D3B50` in the current Pascal reconstruction has two distinct
parts:

1. Locale-sensitive `StrToDate` validation, fallback year parsing, and
   exception handling.
2. For two accepted dates, integer parsing of the original day/month/year
   strings, component-wise borrowing, and German `J`/`M`/`T` output.

The first part stays in the form method and remains locale-dependent. Only
the second part is extracted into
`Forms\Unit1DateDifferenceCore.pas` as
`BuildUnit1ValidatedDateDifferenceText`. The caller still performs the same
two `StrToDate` calls before invoking the helper, and passes the same integer
components parsed from the source strings. `OnlyYears` still selects just the
year fragment.

The helper preserves the listing's order and formulas:

- Start with `Day2-Day1`, `Month2-Month1`, and `Year2-Year1`.
- If day difference is negative, decrement the month difference and use
  `DaysInAMonth(Year1, Month1)-Day1+Day2`.
- If the month difference is then negative, decrement the year difference
  and add 12 months.
- Emit only positive components, in year/month/day order, with the exact
  legacy suffixes and spacing.

This is intentionally not a conventional elapsed-age calculation; for
example, the component borrow rules and omission of nonpositive fragments are
preserved rather than normalized.

## Synthetic tests and validation

Seven focused tests exercise equal dates, same-month day differences,
month/year borrowing, leap-February borrowing, year-only output, and omission
of a negative year component. The tests call only the integer helper with
synthetic values; they do not invoke `StrToDate`, the form method, datasets,
or a UI route.

The focused helper tests pass 7/7. The full FPCUnit suite passes 572/572.
`AhnWin52Tests.lpi` builds, and `AHW52_Main.lpi` builds in Debug mode.

## Limits

Inputs are contractually expected to have passed the form's existing
locale-sensitive validation. The helper does not validate date components or
reproduce the original RTL's `StrToDate`/exception behavior. Active Delphi
date-format settings remain unresolved; no parser or provider caller was
executed.
