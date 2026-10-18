# AhnWin52 UI automation: next tab and graceful close

## Objective

Extend the external, pinned UI automation tool so it can advance the currently
active AhnWin tab by exactly one page, preserve a metadata-only profile for
explicitly selected field reads, and gracefully close the same approved PID
through the two previously observed confirmation dialogs.

This extension does not launch AhnWin, choose field HWNDs, read controls
automatically, open a dataset directly, or make the legacy close path
read-only.

## Implementation

`Source\AhnWin52UIAutomation\AHW52UIAutomation.lpr` provides two new commands:

- `next-tab --pid PID --profile METADATA.json --allow-input --output PROFILE.json`
  validates the saved metadata profile, pinned executable/PID and main-window
  hierarchy; queries the native tab index/count; refuses invalid/last-tab
  states; sends one `Ctrl+Tab`; then requires the native selection to advance
  by exactly one. It writes the post-action metadata profile without visible
  control text and a sibling `.status.json` containing only phase/index facts.
  If Windows foreground protection blocks activation, it waits up to 30 seconds
  for the user to activate the exact validated main window; it sends no input
  until that window and an active-page control have been verified.
  The existing `read-fields` command remains the field-read mechanism: each
  handle still must be explicitly selected and reconciled with the relevant
  DFM/LFM binding.
- `close --pid PID --profile METADATA.json --allow-close --output RESULT.json`
  posts `WM_CLOSE` only to the validated main-window HWND. It accepts the
  expected AhnWin-exit prompt with Ja/Yes, then declines the backup prompt
  with Nein/No. It checks process ownership, dialog class, visible message
  text when available, and the exact one-Yes/one-No button layout. It never
  force-terminates AhnWin. The result records the profile hash and lifecycle
  phase, not prompt text or genealogy values.
  `--resume-backup` is an explicit recovery mode for a run already known to
  have accepted the exit prompt; it accepts only the still-open backup phase
  and never sends another `WM_CLOSE` or exit confirmation.

The native Windows `#32770` prompt must expose text matching the expected
close/backup prompt. Delphi `TMessageForm` can render its label without a
child HWND; if no prompt text is exposed, the only fallback is that exact
window class, the expected first/second prompt sequence, a blank or
`AHNENWIN 5.1` title, same-process ownership, and exactly one enabled Ja/Yes
and Nein/No button. Any other visible dialog or structure fails closed.

Profile validation no longer assumes the first page sheet is active; it
requires exactly one visible sheet. `NextNativeTabIndex` separately enforces
native selection bounds and no-wrap behavior.

## Safety boundary

The tool is bound to
`C:\ProgramData\AHNENWIN Test\AHNWIN51.exe` and its pinned SHA-256. It operates
only on an existing PID. `next-tab` and `close` each require separate explicit
guards and a fresh metadata profile. No generic click or key-dispatch
interface was added.

Changing to the Details tab may execute its `OnEnter` handler. More
importantly, the legacy close path can activate the Edit tab and enter
provider-backed `anzeigen` logic; it may post data, update Paradox sidecars,
or change configuration files. A pre-run verified full-directory snapshot
and backup plus a post-run full inventory/rollback are mandatory. A “No” to
the backup prompt does not prove that files were unchanged.

## Live verification and current boundary — 2026-10-18

The first guarded close test accepted Ja to exit and Nein to backup, and the
process exited without forced termination. Its post-close inventory differed
in 13 AWD files; all were restored from a fresh, verified 170-file backup,
and the final path/size/SHA-256 comparison matched exactly.

A second fresh test instance (PID 14300) produced a metadata-only profile with
172 HWNDs and no captured text. `next-tab` stopped at the foreground guard;
no keyboard input was sent. The profile after that failure still had 172
windows and no foreground HWND for the target. A guarded close accepted the
exit prompt, but prompt enumeration raced the transition to the backup prompt
and returned Win32 error 1400. The process remained alive at the expected
modal backup phase. The new `--resume-backup` path then validated the disabled
main window and owned Ja/Nein dialog, declined backup, and confirmed normal
process exit. Ten changed/missing AWD files were restored; all 170 paths,
sizes, and hashes match the fresh pre-run backup.

The controller now waits for explicit foreground activation instead of
failing immediately, and requires the exact main-window HWND (not merely the
same process) to be foreground before sending a key. The first input-enabled
run did advance the native index from 1 to 2, but a post-action validator
incorrectly compared a zero page-control handle. Corrected the validator to
re-run `ValidateNextTabProfile` after input, then repeated the operation from
a fresh backup. The final PID 23096 run returned success with
`next-tab-verified`, native index 1 -> 2, 172 -> 194 HWNDs, and zero captured
control text. The output profile and status contain no visible field values.
No genealogy fields were read in either tab/close run.

Final preflight snapshot:
`files\ahnwin-live-ui-20261018-1730\preflight-inventory.json` (170 files;
manifest SHA-256
`DF66F9627018503C5A20C290E92798C52F9F3115015FC3239B02B70E37E0E612`).
After the verified tab transition, graceful close accepted Ja to exit and Nein
to backup; PID 23096 exited without forced termination. Ten changed AWD files
were restored from that preflight; final inventory again matches all 170
preflight paths, sizes, and SHA-256 values exactly. No AhnWin process remains.

## Validation

- Free Pascal 3.2.2 console build: passed.
- Pinned executable path/hash verification: passed.
- UI automation FPCUnit suite: 65/65 passed, including active-tab/profile
  validation, native index bounds/no-wrap, prompt classification and
  Ja/Nein policy.
- Live next-tab: verified exact native transition 1 -> 2; post-action profile
  contains no visible text.
- Guarded close and full backup restoration: live verified; no forced
  termination, field reads, report, or provider test.

Command syntax and the live-run backup/inventory procedure are in
`Source\AhnWin52UIAutomation\README.md`.
