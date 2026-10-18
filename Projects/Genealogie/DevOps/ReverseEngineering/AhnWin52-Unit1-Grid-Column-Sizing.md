# Unit1 grid column sizing

## Recovered behavior

The complete `TForm1.gridanp` listing at `Projects_AhnenWin\Unit1.pas:005D3EF8`
reads each grid's current `Width`, calculates column widths with `Round(width *
factor / 10)`, then calls `TCustomGrid.SetColWidths`. It performs no dataset,
file, global-state, dialog, or printer operations.

The retained listing's original-control offsets map to current frame-owned
grids through the current LFM/resources:

| Original grid | Current control | Columns and factors |
|---|---|---|
| `StringGrid1` | `PersonEditFrame.StringGrid1` | 1–5: 1.3, 4.5, 1.1, 1.1, 1.4 |
| `StringGrid2` | `PersonEditFrame.StringGrid2` | 1–5: 1.3, 4.5, 1.1, 1.1, 1.4 |
| `StringGrid3` | `RelationshipsFrame.StringGrid3` | 0–4: 1.3, 4.5, 1.2, 1.2, 1.5 |
| `StringGrid4` | `SiblingsFrame.StringGrid4` | 0–4: 1.3, 4.5, 1.2, 1.2, 1.5 |
| `StringGrid5` | `PersonEditFrame.StringGrid5` | 0–3: 1.3, 5.3, 1.2, 1.6 |

The FPC method body previously contained only the commented disassembly and
therefore changed no column widths. It now applies the listing's assignments
to the equivalent controls in their current frames. The resize test now uses
the streamed form so the complete control graph is present. A focused
synthetic test sets independent grid widths and verifies every assigned
column, unchanged leading columns for grids 1 and 2, and banker's rounding for
the exact 4.5 and 1.5 cases. The resize suite passes 2/2.

## Limits and safety boundary

The original listing loads some factors as 80-bit `Extended` constants and
others as `Single`; the current 64-bit FPC target represents `Extended` as
`Double`. The source expressions and `Round` operation are retained, but
bit-for-bit parity at every floating-point tie across the original Delphi
Win32 runtime is not established. The tests verify representative current
FPC results, not the original application's runtime.

No production UI, database/provider, genealogy data, or original executable
was opened or exercised. The test calls `gridanp` directly on a streamed
form and synthetic dimensions; the production resize/provider routes remain
unrun.
