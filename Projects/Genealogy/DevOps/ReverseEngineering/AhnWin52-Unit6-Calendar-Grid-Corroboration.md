# Unit6 calendar-grid corroboration

## Evidence

The complete IDR listing for `TForm6.Kal` at `005CDC40` independently
corroborates the date placement rules already implemented by
`GregorianCalendarModel.BuildCalendarGrids`:

- Three grids cover January–April, May–August, and September–December.
- Each panel begins with its January/May/September first day at column 3.
- `DayOfWeek` returns Sunday as 1; the listing writes to column
  `DayOfWeek - 1`, so rows are Sunday through Saturday.
- The column advances after Saturday, preserving one column per week.
- When a month begins on Sunday, the listing adds two columns before placing
  its first date; this preserves the spacing between adjacent month grids.

The model's supported-year tests already cover all date cells. Added an
independent cross-check over 1582–2499 asserting that the first day of January,
May, and September is at column 3 of its respective panel and at the
`DayOfWeek - 1` row. The Gregorian-calendar model suite passes 10/10 and the
full FPCUnit suite passes 550/550.

## Follow-up: `gridleeren` storage effects and call order

The complete `TForm6.gridleeren` listing at `005CDBE0` is not a conventional
row-major full-grid clear. It reads `StringGrid1.FColCount - 1`, then calls
`TStringGrid.SetCells(ACol, ARow, '')` with `ACol=1..27` and `ARow=0..8`.
The Delphi register-argument order is corroborated by the retained
`Grids.pas` declaration and `SetCells` implementation. The three streamed
grids in `Form6.dfm` each have 28 columns and 7 rows. The retained
`SetCells` path stores cell data in sparse row/column lists; the calls do not
change the grids' declared row count. Consequently, within the visible
0..6 rows it clears columns 1..27 and leaves column 0 (the weekday-label
column) untouched; the extra writes to rows 7 and 8 are outside the streamed
visible grid.

The listing for `TForm6.Kal` calls `gridleeren` first, before reading or
defaulting the year edit and before `StrToInt`; it then rewrites weekday
labels in column 0 before filling dates. The current form instead validates
the ViewModel/year before clearing, then clears every currently visible cell
and redraws the weekday labels. After a successful redraw on the streamed
28-by-7 grids, the visible cell content is equivalent. The direct clear
operation and the invalid-input/error state are not equivalent: the original
preserves column 0 during clearing and has already cleared date cells if
year conversion fails, while the current form retains the old grid on a
rejected year.

The user explicitly accepts this discrepancy as an intentional improvement:
the current atomic redraw keeps the previously valid calendar visible when
the new year is rejected, rather than leaving a cleared/partial grid. This is
a deliberate UX/robustness difference, not a claim of exact legacy UI parity.
No code change is needed. Neither the original application nor a date parser
was run. Locale-sensitive parsing remains a separate unresolved parity
boundary.

## Boundary

This is an independent confirmation of the grid projection, not a port of
`TForm6.Kal`. The legacy routine clears three `TStringGrid`s, reads or fills
the year through UI state, creates `01.01.<year>` and calls `StrToDate`, then
populates cells. Its date-input parsing is locale-sensitive, and its current
year, globals, UI, and invalid-input/dialog behavior are not moved into the
provider-free model. No legacy form or date parser was executed.
