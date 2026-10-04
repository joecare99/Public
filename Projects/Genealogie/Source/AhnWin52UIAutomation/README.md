# AhnWin52 external UI automation

This is a standalone Free Pascal console utility for observing and, after
explicit opt-in, driving the visible person-search dialog of one approved
test executable:

```text
C:\ProgramData\AHNENWIN Test\AHNWIN51.exe
SHA-256: 817C1B1BB23469CD628C52E4A5EA26CB4DB26275B5EC84952717B218605F0AFF
```

The adapter is external to AhnWin. It does not load Delphi/Lazarus form units,
connect to BDE, inspect another process's memory, inject a DLL, install hooks,
read passwords, or write Paradox files. The target executable path and hash
are pinned in the source. Any mismatch is a hard failure.

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
