# Legacy Unit1/Unit9 mapping to current form units

**Status:** Lineage supported; exact source equivalence not established  
**Scope:** Static comparison of the independent AhnWin 5.1 decompilation with
the current AhnWin52 Pascal/LCL forms. No build, application launch, provider,
or database operation was performed for this comparison.

## Findings

| Legacy project entry | Current candidate | Evidence | Assessment |
|---|---|---|---|
| `Unit1` / `TForm1` / `Form1` | `frmAhnenWinMain` / `TForm1` / `Form1` | `AHNWIN51.dpr` registers `Unit1` as `TForm1`; `Unit1.pas` declares that class; `Form1.dfm` streams `Form1: TForm1`. Current `frmAhnenWinMain.pas` declares `unit frmAhnenWinMain` and the same `TForm1` class/global instance; its LFM root is also `Form1: TForm1`. The current main LPR creates `TForm1, Form1`. | **High-confidence main-form lineage; direct rename/version identity not proven.** |
| `Unit9` / `TForm9` / `Form9` | `AboutForm` / `TAboutForm` / `AboutDialog` | `AHNWIN51.dpr` registers `Unit9` as `TForm9`; `Unit9.pas` declares the about-dialog controls and handlers; `Form9.dfm` streams `Form9: TForm9`. Current `AboutForm.pas` and LFM declare/stream `AboutDialog: TAboutForm`, with the same distinctive control names (`Label1..5`, `Label7..10`, `Image1..2`, `Shape1`, `Timer1`) and corresponding Activate/Show/Create/Click/MouseDown/Timer handlers. The current main LPR creates `TAboutForm, AboutDialog`. | **High-confidence About-form lineage; direct rename/version identity not proven.** |

## Differences that prevent treating these as drop-in replacements

- The legacy resources identify version 5.1 (`Form1.dfm` and `Form9.dfm`);
  current LFM resources identify version 5.2. Form captions, dimensions, and
  layout differ.
- The current main form is an FPC/LCL reconstruction, with refactored frame
  ownership and behavior. Matching class/instance names do not establish
  parity with all legacy event handlers.
- About-form `FormActivate` differs materially: the legacy listing formats
  date values from global state; current `AboutForm` reads local file dates
  during creation and reports a read failure through an injected message
  service. The current `FormClick`, `FormMouseDown`, and timer methods act on
  `Self`; the legacy listings reference the global `Form9` instance.
- The current About LFM binds `OnKeyDown` and `OnMouseDown`; the legacy Form9
  DFM binds Activate/Click/Create/Show but does not stream those two events.
  The legacy key handler is present as a commented listing, so method
  existence alone does not prove resource reachability.

## Native-build consequence

The prior blocker description that `Unit1.pas` and `Unit9.pas` are simply
missing from the reconstructed source tree is incomplete. Their *current
successor candidates* exist under the names `frmAhnenWinMain` and
`AboutForm`. The legacy `AHNWIN51.dpr`, however, has stale relative paths and
expects the old unit/file/resource identities and AhnWin 5.1 composition.
The available candidates are not proven drop-in Delphi 9 replacements; do not
change the DPR, copy the independent decompiler listings into the active
project, or use unit aliases to imply source parity.

This mapping does not clear the independent native-build blocker: the
QuickReport package is incomplete in the available RAD Studio libraries
(`QRPrntr.dcu` is missing), and further matching-version dependencies may
remain. Reassess a native build only with the matching original source tree
and compatible licensed dependencies.

## Reproducible source references

- `Source\Projects_AhnenWin\AHNWIN51.dpr`
- `Source\Projects_AhnenWin\Unit1.pas`, `Form1.dfm`
- `Source\Projects_AhnenWin\Unit9.pas`, `Form9.dfm`
- `Source\AhnWin52\frmAhnenWinMain.pas`, `frmAhnenWinMain.lfm`
- `Source\AhnWin52\Forms\AboutForm.pas`, `AboutForm.lfm`
- `FPC\AHW52_Main.lpr`
