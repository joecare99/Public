# VirtualDesktop MCP sidecar

`McpStdioSidecar` is a Lazarus/FPC 3.2.2 console sidecar. It reads one
JSON-RPC request per line from stdin and writes one response per line to
stdout. It implements `initialize`, `ping`, `tools/list`, `tools/call`, and
the `notifications/initialized` notification.

Connection details are read from `--token-file <path>`,
`MCP_TOKEN_FILE`, or `VIRTUALDESKTOP_MCP_TOKEN_FILE`. A file may contain a
JSON object with `token`, `endpoint`/`loopbackEndpoint`, and `workspaceRoot`,
key/value lines, or a raw token. Environment fallbacks are `MCP_TOKEN`,
`MCP_LOOPBACK_ENDPOINT`/`MCP_ENDPOINT`, and `MCP_WORKSPACE_ROOT`. Tokens are
loaded but never written to stdout/stderr.

`McpCommand` and `McpRegistry` are the application extension seam. Global
commands use `RegisterGlobalMcpCommand`; desktop/application commands use
`RegisterApplicationMcpCommand`. Commands must use lowercase dot-namespaced
names: `workspace.*` commands have `mcsUserWorkspace` scope, while
`desktop.*` commands have `mcsDesktop` scope. Desktop commands are hidden and
denied unless the command context is constructed with explicit desktop
permission; the standalone sidecar intentionally does not enable it.

Schemas are closed JSON objects (`additionalProperties: false`) and are
validated before a command executes. Workspace paths must be relative,
segment-safe, and cannot traverse Windows reparse points. `EMcpError.ToJson`
and `TMcpCommandResult.ErrorWithCode` provide structured error contracts.
`IMcpDesktopCommandBridge` is a transport-neutral contract. The
`VirtualDesktop` shell supplies its live in-process implementation through
`TDesktopMcpBridge`; the shell shares an explicitly desktop-authorized command
context with the loopback transport only after authentication. It exposes
`desktop.status`, `desktop.apps.list`, and the allowlisted
`desktop.apps.open` action. `TMcpLoopbackServer` binds only `127.0.0.1` on an
OS-assigned port, writes `mcp-connection.json` into the app user workspace,
and removes it during shell disposal. It generates a fresh 256-bit token; a
client must send `{"token":"…"}` as its first newline-delimited message before
JSON-RPC is routed. Lines are capped at 64 KiB and inactive clients expire
after 30 seconds. The token is never logged or sent in a response. The stdio
sidecar remains unprivileged and exposes only `workspace.info` by default.

The current transport and controlled process implementation is Windows-only.
Linux support requires porting the Windows-specific transport, connection-file,
and process paths; installing Linux FPC/Lazarus alone is not sufficient.

## Build and test

From the `Mcp` directory, build the console sidecar with:

```text
lazbuild McpStdioSidecar.lpi
```

From the sibling `McpTests` directory, run its headless FPCUnit suite:

```text
lazbuild McpTests.lpi
./McpTests --all
```

These commands use relative paths and omit platform-specific executable
suffixes.

## Lazarus bridge

When the VirtualDesktop host is running, the authenticated loopback advertises
the allowlisted desktop tools `desktop.status`, `desktop.apps.list`, and
`desktop.apps.open`, plus the Lazarus tools `lazarus.status`,
`lazarus.projects.list`, `lazarus.project.open`, `lazarus.project.build`,
`lazarus.tests.run`, `lazarus.desktop.start`, and `lazarus.desktop.stop`.
Project arguments are symbolic allowlist names, never paths. No shell commands,
compiler arguments, arbitrary paths, or foreign process termination are
accepted. The bridge receives the catalog, launcher, build/test runner, and
process service through constructor injection.

### Live demonstration

1. Start `VirtualDesktop.exe` and wait for
   `%LOCALAPPDATA%\LazarusVirtualDesktop\mcp-connection.json`.
2. Start `McpStdioSidecar.exe --token-file <connection-file>`.
3. Call `tools/list`, then `lazarus.status` and `lazarus.projects.list`.
4. Call `lazarus.project.open` with `{"project":"virtual-desktop"}`,
   `lazarus.project.build` with any allowlisted project, or
   `lazarus.tests.run` with an allowlisted test project such as
   `{"project":"mcp-tests"}`.
5. Call `desktop.status`, `desktop.apps.list`, and
   `desktop.apps.open` with `{"name":"Tile Match"}`.
6. For process ownership, use `lazarus.desktop.start` and
   `lazarus.desktop.stop` from the same authenticated bridge instance.
