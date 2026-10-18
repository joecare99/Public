# Unit1 weekday abbreviation helper corroboration

## Listing evidence

Unit1 `sub_005D7C50` calls `StrToDate`, catches date-conversion exceptions,
and on success maps `DayOfWeek` values 1 through 7 to the fixed German
abbreviations `So`, `Mo`, `Di`, `Mi`, `Do`, `Fr`, and `Sa`. A failed parse
returns an empty string. The independent `TForm1.wt33` listing constructs a
date string from DataModule field values and calls this helper; that
provider-backed caller was not executed.

## Existing reconstruction

The current `Forms\DateWeekdayAbbreviation.pas` already uses `StrToDate`,
returns an empty result on conversion failure, and uses the same fixed
weekday mapping. Its focused tests pin and restore `DefaultFormatSettings`,
cover every weekday, invalid dates, and a distinct short-date format. The
date parser remains locale-sensitive: the listing does not establish the
original program's active `ShortDateFormat`/`DateSeparator` at this call site,
nor prove that Delphi and FPC accept identical date strings. No new code or
provider binding is justified by this corroboration.

## Startup-format evidence check

Searched the retained application `Unit*.pas` listings and `AHNWIN51.dpr`,
plus the current AhnWin52 Pascal/LPR sources, for `ShortDateFormat`,
`DateSeparator`, and related date-format assignments. No application-owned
override was found. The original DPR shows `Application.Initialize`, form
creation, and `Application.Run`, but no explicit date-format assignment.
Matches outside application-owned units were RTL/library references, not
evidence of the value active in the original process. Therefore the active
locale settings and exact `StrToDate` acceptance behavior remain unknown.

The existing weekday suite passes 3/3; its tests explicitly pin and restore
format settings rather than claiming to recover the legacy machine locale.
