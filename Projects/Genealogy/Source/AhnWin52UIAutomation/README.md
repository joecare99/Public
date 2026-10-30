# AhnWin52 external UI automation

This is a standalone Free Pascal console utility for metadata-only inspection
and explicit field reads in one approved test executable, plus distinct
guarded person-search, single-tab, and graceful-close actions:

```text
C:\ProgramData\AHNENWIN Test\AHNWIN51.exe
SHA-256: 817C1B1BB23469CD628C52E4A5EA26CB4DB26275B5EC84952717B218605F0AFF
```

The adapter is external to AhnWin. It does not load Delphi/Lazarus form units,
connect to BDE, inspect another process's memory, inject a DLL, install hooks,
read passwords, or directly write Paradox files. A graceful close can trigger
the legacy application's own provider/file side effects, so it requires a
fresh verified test-instance backup/inventory. The target executable path and
hash are pinned in the source. Any mismatch is a hard failure.

## Build and test

Compile the console adapter with the installed Free Pascal 3.2.2 compiler:

```powershell
C:\lazarus\fpc\3.2.2\bin\x86_64-win64\fpc.exe `
  -Fu"C:\Projekte\Delphi\Projekte\Genealogie\Source\AhnWin52UIAutomation" `
  -Fu"C:\lazarus\fpc\3.2.2\units\x86_64-win64\fcl-json" `
  -FE"C:\Users\Mir\.copilot\session-state\bc780dc9-be21-4e10-b7a2-0aab27abfe2f\files" `
  "C:\Projekte\Delphi\Projekte\Genealogie\Source\AhnWin52UIAutomation\AHW52UIAutomation.lpr"
```

Compile and run the synthetic profile tests:

```powershell
$root = "C:\Projekte\Delphi\Projekte\Genealogie\Source\AhnWin52UIAutomation"
$out = "C:\Users\Mir\.copilot\session-state\bc780dc9-be21-4e10-b7a2-0aab27abfe2f\files\ahw52-ui-tests"
C:\lazarus\fpc\3.2.2\bin\x86_64-win64\fpc.exe `
  -Fu"$root" -Fu"$root\tests" `
  -Fu"C:\lazarus\fpc\3.2.2\units\x86_64-win64\fcl-fpcunit" `
  -Fu"C:\lazarus\fpc\3.2.2\units\x86_64-win64\fcl-json" `
  -FU"$out" -FE"$out" "$root\tests\AHW52UIAutomationTests.lpr"
& "$out\AHW52UIAutomationTests.exe" --all --format=plain
```

The tests use only synthetic HWND profiles. They never start AhnWin.

## Safe usage

Before the first launch or input experiment, make and hash-verify the approved
test-instance backup outside the source tree. The user confirmed that the
approved fixture's `par.cfg` contains no credentials and authorized the
previous backup and test run. Still avoid printing or logging configuration
contents, and make a fresh inventory/backup before any new live experiment.
Stop if a future fixture or configuration file has an unknown credential
status.

Check the pinned binary without launching it:

```powershell
$tool = "C:\Users\Mir\.copilot\session-state\bc780dc9-be21-4e10-b7a2-0aab27abfe2f\files\AHW52UIAutomation.exe"
& $tool verify
```

`verify` reads only the executable metadata/hash and sends no UI messages.

Output profiles/results are restricted to this local directory:

```text
C:\Users\Mir\.copilot\session-state\bc780dc9-be21-4e10-b7a2-0aab27abfe2f\files\ahnwin-ui-profiles
```

The utility will create that directory, refuse existing output files, reject
network output paths, and reject any output path inside the test-data
directory. Profiles include visible text from the approved process's visible
windows/controls; that text may include the currently displayed test record.
Store profiles locally and remove them when no longer needed.

New profiles use schema version 2 and include the foreground HWND only when
Windows reports that the foreground belongs to the pinned target process.
Version-1 saved profiles remain readable; their foreground observation is
reported as unavailable. Foreground captions/classes are taken only from the
captured target-process window profile, never from another foreground
application.

### Prepare a controlled search manifest

`prepare-search` creates a versioned, non-executable experiment manifest from a
saved UI profile. It performs no process launch, window query, or input action.
The saved profile must already identify the pinned executable and contain the
validated visible `Auswahl` dialog. The supplied snapshot reference is recorded
for traceability, but the command cannot verify that a backup exists or that
it is complete; manual snapshot verification remains a required precondition.

```powershell
& $tool prepare-search `
  --profile "$out\person-search-profile.json" `
  --snapshot-reference "snapshot-id-from-preflight" `
  --category known-hit `
  --surname "Example" `
  --given-name "Person" `
  --output "$out\prepared-search.json"
```

Supported categories are `known-hit`, `surname-only-prefix`,
`absent-surname`, and `absent-given-name`. The category names describe the
experiment's intended precondition; they do not prove that the fixture
contains or lacks a matching person. Search values are stored only in the
local manifest and may be sensitive. The JSON explicitly sets
`liveExecutionAuthorized` to `false`; no command consumes a manifest to run an
experiment. Each live search still requires the separate guarded command and
explicit `--allow-input`.

The manifest declares the provider outcome classes `not-found`,
`single-candidate`, and `candidate-list`; the manifest reader rejects a
missing (for result schema version 2), malformed, reordered, or altered
outcome list. Version-1 manifests remain readable without that list. These
are not outcomes observed by the external adapter. Visible
UI evidence is captured separately. Result JSON
uses result schema version 2 and records the action phase, whether the bounded
person-search-dialog wait timed out, its configured timeout when applicable,
whether `Auswahl` remains visible, the visible top-level window count, and
target-process foreground HWND/class/caption when available.
Manifest schema versions must be integral values, and the target PID must be
a positive 32-bit integer; fractional or out-of-range values are rejected.
`gridSelectionRead` and `lookupOutcomeInferred` are always false. On a
`--wait-for-dialog` timeout, the adapter writes a result profile with phase
`timeout-waiting-for-dialog` before returning an error; it has not sent input.
The adapter cannot read `TDBGrid` rows or claim a hit from dialog closure.

The preflight for the four `geba` categories is recorded in
`DevOps\AhnWin-Next-Reconstruction-Slices.md`. It requires a new verified
backup/inventory and a fresh same-PID dialog profile before each separately
authorized one-category experiment. The category labels are test
preconditions, not BDE result predictions. The user must report visible
selection independently; dialog closure alone never means a lookup hit.

### Start and inspect

Only the exact pinned executable may be started. This command is not a
read-only action for the database: startup may open or update Paradox sidecar
files. Use it only after the required snapshot/backup precondition is met.

```powershell
$tool = "C:\Users\Mir\.copilot\session-state\bc780dc9-be21-4e10-b7a2-0aab27abfe2f\files\AHW52UIAutomation.exe"
$out = "C:\Users\Mir\.copilot\session-state\bc780dc9-be21-4e10-b7a2-0aab27abfe2f\files\ahnwin-ui-profiles"
& $tool start-and-inspect --output "$out\startup-profile.json"
```

The utility does not enter credentials or dismiss a login dialog. It treats
the splash screen and the initial no-window interval as transient, polling up
to 30 seconds for the visible `AHNENWIN 5.1` main window. On timeout it reports
the PID and leaves the program running rather than terminating it.

For a process already started by the utility, open the person-search dialog
manually in the UI and capture its profile:

```powershell
& $tool inspect --pid 1234 --output "$out\person-search-profile.json"
```

`inspect` attaches only to an executable whose full path and SHA-256 match the
approved instance. It enumerates visible top-level/child HWND metadata and
reads visible control text. Password-style edit controls are recorded only as
password controls; their text is suppressed. Non-windowed VCL controls such as
`TLabel` do not have their Delphi component names available to this external
enumerator.

### Metadata-only discovery and explicit field reads

For a new screen, prefer `inspect-metadata`; unlike `inspect`, it does not
query visible captions or control text. It requires the target application to
already be running and enumerates HWND structure/visibility metadata without
querying captions or control text. It does not launch AhnWin or send UI input:

```powershell
& $tool inspect-metadata --pid 1234 --output "$out\metadata-profile.json"
```

Review this local JSON and match a visible edit/combo control's HWND and
geometry to the statically identified form layout. The enumerator cannot
recover Delphi component names or `DataField` bindings. Do not infer a field
meaning from its position alone.

To read values, select only the exact field-control HWNDs from that fresh
metadata profile. The command revalidates the pinned executable, PID, control
class, parent, geometry, visibility, and profile structure; permits at most 16
visible `Edit`/`TEdit`/`TDBEdit`/mask-edit/combo controls; and refuses password,
hidden, label, grid, or memo controls. It reads no unselected control and
sends no input:

```powershell
& $tool read-fields `
  --pid 1234 `
  --profile "$out\metadata-profile.json" `
  --handles "123456,123457" `
  --allow-read `
  --output "$out\selected-fields.json"
```

Handles may be decimal or `0x`-prefixed hexadecimal. `--allow-read` is a
required explicit opt-in. Field values are written only to a new JSON under
the local profile directory; they are not printed to the console. Treat this
output as potentially sensitive, review it locally, and do not paste it into
source, tests, commits, or the Wiki. A read operation is not proof of a
database/provider contract and does not distinguish unsaved edits from stored
values. Never use this feature to enumerate a grid or extract records in bulk.

### Advance exactly one tab and close AhnWin

These commands are separate guarded actions. They require the already-running
approved PID and a fresh metadata-only profile; neither command starts AhnWin.
Before either command, create and verify a fresh complete backup/inventory of
the test directory. This is especially important for `close`: the legacy close
path can revisit the edit tab, access provider-backed data, and update sidecar
files. The command does not make that application path read-only.

Capture a metadata-only profile, then advance one tab with the validated
main-window `Ctrl+Tab` action:

```powershell
& $tool inspect-metadata --pid 1234 --output "$out\before-next-tab.json"
& $tool next-tab `
  --pid 1234 `
  --profile "$out\before-next-tab.json" `
  --allow-input `
  --output "$out\details-tab-profile.json"
```

The command queries the native tab selection/count, refuses to wrap from the
last tab, sends exactly one `Ctrl+Tab`, and verifies that the native selection
advanced by one. It writes only metadata (no control text) to the output
profile. If the selection is ambiguous, changes by more than one, or cannot be
verified, it stops without sending another key. Match the visible controls to
the relevant DFM/LFM before selecting any handles for `read-fields`; tab
position alone is not a field binding. A sibling
`details-tab-profile.json.status.json` records the last completed action phase
and native tab indexes in case post-action verification fails. Windows may
refuse foreground activation from a background automation process. In that
case the command waits up to 30 seconds and prints a prompt; manually activate
the approved AhnWin main window during that interval. It sends no key unless
the exact validated main window is foreground and a validated control inside
the active page owns keyboard focus.

After the selected field reads are complete, capture a fresh metadata profile
and explicitly request graceful shutdown:

```powershell
& $tool inspect-metadata --pid 1234 --output "$out\before-close.json"
& $tool close `
  --pid 1234 `
  --profile "$out\before-close.json" `
  --allow-close `
  --output "$out\close-result.json"
```

The close command posts `WM_CLOSE` only to the validated main window. It
accepts exactly the expected exit prompt with **Ja/Yes**, then declines the
backup prompt with **Nein/No**. Native prompts must expose and match their
message text. A Delphi `TMessageForm` can render its message in a non-windowed
label; when that text is not exposed, the command permits only the known
`TMessageForm` in the expected sequence, with exactly one enabled Ja/Yes and
one enabled Nein/No button, owned by the approved process and titled blank,
`AHNENWIN 5.1`, or the observed generic `Bestätigung`. Any other visible
window, prompt text, class, or button layout stops automation. It never
force-terminates the process. The result file
records only the PID, input-profile hash, phase, and chosen actions; no dialog
or genealogy text is saved.

If a run stops after recording `exit-confirmation-accepted` because the
application transitioned to its backup prompt before that prompt could be
enumerated, capture a fresh metadata-only profile and resume only that known
second phase with the explicit `--resume-backup` switch. This mode requires
the main window to be disabled and the validated backup prompt to be present;
it never sends another `WM_CLOSE` or confirms the exit prompt again:

```powershell
& $tool inspect-metadata --pid 1234 --output "$out\backup-prompt.json"
& $tool close `
  --pid 1234 `
  --profile "$out\backup-prompt.json" `
  --allow-close `
  --resume-backup `
  --output "$out\close-resumed-result.json"
```

After the process exits, compare a fresh recursive inventory against the
pre-run manifest and restore any authorized test-copy changes only from the
verified backup. A successful close is not evidence that provider/table files
were unchanged.

### Guarded person search

The search command needs the profile captured from the same running process,
an explicit `--allow-input`, both input options, and a fresh profile match.
The observed `Auswahl` dialog exposes exactly two visible VCL `TEdit` child
windows and one enabled VCL `TButton` labelled `suchen`; the additional
`TBitBtn` is not a search target. The dialog's captured HWND owner must be a
top-level window in the same process. Delphi may use either the visible main
form or an application-owned hidden window as that owner; the saved profile
pins whichever one is observed. The visible main form is identified as
`TForm1`, because the live application also exposes a `TApplication` window
with the same caption. The adapter orders the edits by screen position, then
revalidates the window hierarchy before sending each action.

```powershell
& $tool person-search `
  --pid 1234 `
  --profile "$out\person-search-profile.json" `
  --surname "Beispiel" `
  --given-name "Anna" `
  --allow-input `
  --output "$out\search-result.json"
```

`--dry-run` validates the profile and reports field lengths without sending
input; the CLI still requires `--allow-input` as an explicit command guard.
A real search sets the two visible fields with `WM_SETTEXT` and checks
readback. In the recovered AhnWin DFM, `Edit2.OnExit` is bound to a handler
that calls the same `Button1Click` routine used by `suchen`. The adapter
therefore triggers that recovered search path by moving focus away from the
given-name edit; it does not send `BM_CLICK`. The dialog normally closes during
that exit handler, so a closed dialog is recorded as the observed trigger
result, not as a dispatched button click.
When launching the command itself makes the modal dialog disappear,
`--wait-for-dialog` keeps the one-shot command active for up to 30 seconds so
the user can reopen `Auswahl`; it proceeds only after the live window profile
matches and otherwise exits without sending input.
This is not identical to keyboard typing: Delphi `OnKeyPress` handlers are not
invoked by `WM_SETTEXT`. If readback, focus, window ownership, process identity,
or selector geometry differs, the command stops before triggering the edit-exit search. The result
JSON contains the prior input-field values and a post-action UI profile. It
records progress atomically (`validated-no-input`, `about-to-set-*`, `*-set`,
`about-to-trigger-search-on-edit2-exit`, and
`search-triggered-by-edit2-exit-dialog-closed`). An error therefore leaves the
last completed/intended phase available. It does not infer which grid row was
selected or reveal grid contents that Windows does not expose as control text.

Do not use this command for record creation, editing, deletion, saving,
printing, or export. The approved interactive search result and any sidecar
changes must be compared against the pre-experiment inventory before using
them as reconstruction evidence.

## Scope limits for additional observations

This is not yet a general AhnWin observation framework:

- `person-search`, `next-tab`, and `close` are distinct guarded actions with
  separate selectors and result semantics. The person-search validator is
  specific to the `TForm3` `Auswahl` dialog, two edits, the `suchen` button,
  and the recovered `Edit2.OnExit` route.
- `inspect` enumerates other visible windows, but its saved profile contains
  visible control text. That text may include genealogy data. Do not use it
  for a new screen unless that local output is explicitly acceptable; never
  publish or commit profiles containing displayed records.
- `prepare-search` and its result schema apply only to person search. They do
  not describe Unit14, reports, or other dialogs.
- `start-and-inspect` launches the pinned executable and may cause startup
  side effects. It is not a read-only preflight.

Before adapting this tool to another screen, define one exact observation
category and trace its DFM/LFM binding and caller path. For further extension,
keep metadata-only capture as the default and add a separate read-only result
schema only for the approved terminal categories. `inspect-metadata` and
`read-fields` provide limited read-only primitives for explicitly selected
visible edit/combo HWNDs. Any input action must remain a separate, explicitly
guarded command with a validated per-screen control profile. Do not reuse the
person-search selectors, manifests, or result semantics for another dialog.

For Unit14, a new profile must identify the `ListBox1`/`Form33` route without
recording place text; the person-search profile cannot do that. For report
observations, first establish the caller's database effects and whether it
invokes a destructive producer. The current Table27 protocol finds no safe
`spitzbas` route because it empties and rebuilds Table27. Adding a generic
button-click command would not clear that gate.

Every new live run still requires separate scope approval, a fresh verified
disposable test-instance snapshot and backup, process/window identity checks,
and before/after inventory comparison. Prior person-search authorization
does not authorize a different screen or action.
