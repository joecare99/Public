# Unit30 source-dialog global close target

## Recovered behavior

The DFM binds `BitBtn1.OnClick` to `TForm30.BitBtn1Click`. The complete
`Projects_AhnenWin\Unit30.pas` listing at `005601E8` loads the global
`TForm30` instance and calls `TCustomForm.Close` on that object. The current
Pascal implementation, `Form30.Close`, preserves this target.

The existing synthetic test closed a form that was also assigned to the
global variable, so it did not distinguish the global target from the event
receiver. `TestCancelButtonClosesGlobalFormInsteadOfReceiver` now creates two
in-memory forms, assigns one as global `Form30`, invokes the handler on the
other, and verifies that only the global target receives `OnClose`.

## Boundary

This verifies the handler's target selection only. It does not instantiate the
streamed form, open the source tables, or execute the source-editing handler.
Unit29's search action remains provider-backed, and its save button delegates
to the shared persistence path; neither is covered by this close test.

## Adjacent Unit29/Unit30 action screen

The DFM-bound Unit29 actions were checked against the complete retained
listings and the current synthetic tests:

| Action | Listing evidence | Current boundary |
| --- | --- | --- |
| `ListBox1Click` | Copies `ItemIndex` to the shared selected-source index | Synthetic test covers selected and unselected values |
| `ListBox1DblClick` | Copies the selected title, updates global Unit30 caption, and shows global Unit30 | Synthetic test covers selected title, caption, and show target |
| `SpeedButton1Click` | Clears the saved index, selects item zero, and assigns `mrCancel` to global Unit29 | Synthetic test covers state and global target |
| `Button2Click` | Opens/selects indexes on source datasets, scans and compares records, then calls `anzeigen` | Provider-backed; retain listing-only |
| `FormActivate` | Restores the index and traverses the source dataset to populate the list | Provider-backed; retain listing-only |
| `Button1Click` | Delegates to `TForm1.Lb_speich` | Shared persistence; retain listing-only |

Unit30's cancel button, Enter navigation, and counter callbacks already have
synthetic coverage. The other DFM-bound substantive route, `FormShow`, calls
`FindKey` and populates labels from provider-backed source fields; `BitBtn2`
contains dataset `FindKey`, `Delete`, `Edit`, and `Append` operations. Their
lookup, write, cancellation, and error contracts are not safe to approximate.

There are no pending todos without prerequisites. The next useful source-list
slice therefore requires new authoritative evidence for the relevant provider
contract or a separately approved disposable synthetic fixture that defines
the expected source-edit behavior. Until then, do not execute the search,
editor activation, save, or edit routes.

## Validation

- Focused `TTestAHW52SourceDialog`: 2/2 passed.
- Full FPCUnit suite: 589/589 passed.
- No database/provider, original application, report, or file action ran.
