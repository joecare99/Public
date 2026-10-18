# Unit9 About-dialog date formatting

## Recovered behavior

The IDR listing `Source\Projects_AhnenWin\Unit9.pas` shows
`TForm9.FormActivate` (`005C6C60`) formatting two values with `DateToStr`:

- `GlobalVar_02536924` is inserted into `(Ausgabe vom <date>)`.
- `GlobalVar_0253691C` is inserted into `Letzte Bearbeitung am <date>`.

The separate RTL listing `Source\Projects_AhnenWin\sysutils.pas` shows
`DateToStr` forwarding to `DateTimeToString` with the global date-format
string. `GetFormatSettings` initializes locale data through `InitSysLocale`,
`GetThreadLocale`, and `GetLocaleStr`. No explicit assignment of a fixed
`ShortDateFormat` or `DateSeparator` was found in the retained application
sources. Therefore the display format is locale-dependent; the disassembly
does not support claiming that these labels always use `dd.mm.yyyy`.

The current synthetic test in
`Source\AhnWin52Tests\tst_AHW52_AboutFormTests.pas` sets
`DefaultFormatSettings.ShortDateFormat` to `dd.mm.yyyy` and the separator to
`.` so it can assert deterministic captions. It now snapshots and restores
the global format settings in `finally`, preventing the test from leaking its
locale into later tests.
The focused AboutForm suite passes 4/4 and the full FPCUnit suite passes
549/549 after this isolation fix.

## File-date initialization and the reported epoch-like captions

The independent Unit1 listing at `005D5761` opens `AHNWIN51.exe`, passes its
handle through `FileGetDate` and `FileDateToDateTime`, and stores the result
in `GlobalVar_02536924`. It repeats the same sequence for `awd.db`, storing
to `GlobalVar_0253691C`. The listing does not visibly check either file-open
or file-date result before conversion. Consequently, a date near the
`TDateTime` epoch could indicate an uninitialized/default date or a failed
file-date path, but the caption alone does not identify which. The user
clarified that the display may have been 30.12.1899 rather than 31.12.1899;
30 December 1899 is exactly Delphi's `TDateTime` value `0`. Keep the observed
day uncertain rather than treating either date as an established measurement.

The current `AboutForm.FormCreate` takes a different, guarded route: it uses
`FileAge`, records a missing-file error, and `FormActivate` reports that error
instead of formatting either date. Do not change that behavior based only on
the observed captions.

The two Access Violations reported during the synthetic click-handler attempt
are not explained by these date values: that test did not call `FormCreate`
or `FormActivate`, so it never read or formatted either date. The failing
test and its unverified edits were reverted and have not been rerun. The exact
cause of those test-time Access Violations remains unresolved.

## Boundary

This listing does not establish which locale was active in the supplied
AHNWIN51 executable at runtime, nor whether the two global date values had
time portions that affect the rendered date. Do not hard-code these date
captions to a specific locale or infer a date format from the English/German
UI labels. A runtime-specific display assertion would require an authorized
observation under a known Windows thread locale; this reconstruction does not
launch the application.
