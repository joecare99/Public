# Unit22 Tiny-Tafel producer boundary

## Static candidate screen

The original Unit22 DFM binds `SpeedButton1Click` and `SpeedButton2Click`.
The independent `Projects_AhnenWin\Unit2.pas` component map resolves the
first target opened by `SpeedButton1Click` at `$00E0` as Table14 and the next
dataset at `$00E8` as Table15.

The `TOKBottomDlg.SpeedButton1Click` listing (`0054E0D4`) begins by opening
Table14, closing it, calling `TTable.EmptyTable`, reopening Table14, and
opening Table15 before beginning the rest of its work. The producer is thus
provider-backed and destructive before its row-building logic. No complete
pure helper boundary was selected from that path; do not invoke it or treat
the early string operations as a complete reconstruction contract.

`SpeedButton2Click` (`0054F568`) closes the global `OKBottomDlg` form. Existing
synthetic coverage is in
`Source\AhnWin52Tests\tst_AHW52_TinyTafelDialogCancelTests.pas`, along with
two counter-helper tests. The main `SpeedButton1Click` producer remains
listing-only. No table, provider, report, or UI was executed for this screen.

## Gate

Further restoration needs a separately specified synthetic row contract and
test boundary that do not use Table14/15 providers or the destructive
`EmptyTable` call. Do not substitute a guessed in-memory algorithm for the
remainder of the listing.
