# Lazarus Virtual Desktop Showcase

This standalone Lazarus project demonstrates a small desktop-style application
built with:

- MVVM separation between the LCL form and application state.
- Constructor-based dependency injection through focused service contracts.
- One Pascal class per source file.
- Movable windows with header bars, activation, edge snapping, tab docking,
  undocking, minimize/restore task strip, and maximize/restore.
- Showcase applications: calculator, calendar, notepad, analog alarm clock,
  unit converter, task list, configuration editor, text viewer, Orbit Dodger,
  and Tile Match.
- File-backed notes, tasks, and configuration under the user workspace.
- `Mvvm.pas` provides `INotifyPropertyChanged` with a consumer list and
  `ICommand` with `CanExecute`, `Execute`, and `TNotifyCanExecuteChanged`
  consumer notifications. ViewModels expose commands instead of requiring
  views to call domain methods directly.

Open `VirtualDesktop.lpi` in Lazarus and run it. The desktop is created in code
so the example stays easy to browse and keeps the view model classes free from
LCL dependencies.

## Structure

`Services.pas` and `DesktopServices.pas` contain service contracts.
`TServiceContainer` is the composition root implementation; applications
receive `IDesktopServices` rather than the concrete container. `ClockService.pas`,
`FileNoteStorage.pas`, `FileTaskRepository.pas`,
`UserWorkspaceService.pas`, and `ConfigurationService.pas` provide concrete
services. View models consume only those contracts, while
`DesktopForm.pas` remains the composition root.

`DesktopWindow.pas` and `DesktopWorkspace.pas` contain the reusable window
and workspace behavior. `DesktopMcpBridge.pas` and
`DesktopMcpShellAdapter.pas` provide a live, transport-neutral in-process MCP
adapter for the running shell. The shell creates and retains the explicitly
desktop-authorized context. At startup it also starts the narrow
`McpLoopbackServer` transport: it binds only `127.0.0.1` on an OS-assigned
port and writes `mcp-connection.json` in the user workspace. The file contains
the endpoint, workspace root, and a fresh token, and is removed when the form
is disposed. A client must send `{"token":"…"}` as its first newline-delimited
JSON message before it can use JSON-RPC. Processing occurs on the LCL timer,
so live shell actions remain on the main thread. Available tools are read-only
`desktop.status`, `desktop.apps.list`, and allowlisted `desktop.apps.open`,
which can open only an application already registered by the shell. The sibling
`../Mcp` project contains the extensible MCP command/registry foundation and a
standard newline-delimited JSON-RPC stdio sidecar. The sidecar supports
`initialize`, `ping`, `tools/list`, and `tools/call`, but remains
workspace-scoped and cannot access the live desktop adapter.

`Source\App`, `Source\MVVM`, `Source\Views`, and `Source\Services` separate
the shell/application composition from MVVM and infrastructure concerns.
Each application is grouped by role; `Source\Games` uses the same separation
for the two games and contains LCL-free deterministic game models and view
models.
`Orbit Dodger` is a timer-driven dodge game; `Tile Match` is a pair-matching
game with delayed mismatch handling. Their runtime views inject a system clock
and random source, while tests use deterministic doubles.

Applications are registered through `DesktopApplication.pas`. The shell owns
only the workspace, services, registry, and launcher; its dock is generated
from that registry, so an added application automatically appears in the
launcher. Calculator, calendar, notepad, and alarm clock each own their view
model and view in a dedicated application class. Additional applications use
the same registry seam.

Desktop windows can be moved, snapped, tab-docked, minimized, restored,
resized using the bottom resize grip, and closed through the header close
button. Closing a tabbed window also removes its tab and task-strip entry.

## Tests

Build and run the headless FPCUnit suites from the respective project
directories. `lazbuild` and the executable names are intentionally
platform-neutral; on Windows, the shell resolves the `.exe` suffix.

```text
C:\lazarus\lazbuild.exe --build-all VirtualDesktopTests.lpi
..\..\..\bin\x86_64-win64\VirtualDesktopTests.exe --all

C:\lazarus\lazbuild.exe --build-all GameLogicTests.lpi
..\..\..\bin\x86_64-win64\GameLogicTests.exe --all

cd ..\McpTests
C:\lazarus\lazbuild.exe --build-all McpTests.lpi
..\..\..\bin\x86_64-win64\McpTests.exe --all
```

The graphical `VirtualDesktop.lpi` project depends on the cross-platform LCL;
its controls are intentionally not part of the headless suites.
All Showcase executables are emitted to
`C:\Projekte\Delphi\bin\$(TargetCPU)-$(TargetOS)` and compiler units to its
`units` subdirectory. The project folders contain source and project metadata,
not build binaries.
