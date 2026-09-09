unit LazarusProjectCatalog;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, LazarusProjectContracts;

type
  TShowcaseProjectCatalog = class(TInterfacedObject, IShowcaseProjectCatalog)
  public
    function Targets: TShowcaseProjectTargets;
    function ProjectName(const ATarget: TShowcaseProjectTarget): string;
    function ProjectFile(const ATarget: TShowcaseProjectTarget): string;
    function IsTestTarget(const ATarget: TShowcaseProjectTarget): Boolean;
  end;

implementation

function TShowcaseProjectCatalog.Targets: TShowcaseProjectTargets;
begin
  Result := nil;
  SetLength(Result, 5);
  Result[0] := sptVirtualDesktop;
  Result[1] := sptVirtualDesktopTests;
  Result[2] := sptMcpStdioSidecar;
  Result[3] := sptMcpTests;
  Result[4] := sptGameLogicTests;
end;

function TShowcaseProjectCatalog.ProjectName(
  const ATarget: TShowcaseProjectTarget): string;
begin
  case ATarget of
    sptVirtualDesktop:
      Result := 'VirtualDesktop.lpi';
    sptVirtualDesktopTests:
      Result := 'VirtualDesktopTests.lpi';
    sptMcpStdioSidecar:
      Result := 'McpStdioSidecar.lpi';
    sptMcpTests:
      Result := 'McpTests.lpi';
    sptGameLogicTests:
      Result := 'GameLogicTests.lpr';
  else
    raise EShowcaseProjectCatalog.Create('Unknown Showcase project target.');
  end;
end;

function TShowcaseProjectCatalog.ProjectFile(
  const ATarget: TShowcaseProjectTarget): string;
begin
  case ATarget of
    sptVirtualDesktop:
      Result := CanonicalShowcasePath(ShowcaseRootDirectory +
        '\VirtualDesktop\VirtualDesktop.lpi');
    sptVirtualDesktopTests:
      Result := CanonicalShowcasePath(ShowcaseRootDirectory +
        '\VirtualDesktopTests\VirtualDesktopTests.lpi');
    sptMcpStdioSidecar:
      Result := CanonicalShowcasePath(ShowcaseRootDirectory +
        '\Mcp\McpStdioSidecar.lpi');
    sptMcpTests:
      Result := CanonicalShowcasePath(ShowcaseRootDirectory +
        '\McpTests\McpTests.lpi');
    sptGameLogicTests:
      Result := CanonicalShowcasePath(ShowcaseRootDirectory +
        '\VirtualDesktopTests\GameLogicTests.lpr');
  else
    raise EShowcaseProjectCatalog.Create('Unknown Showcase project target.');
  end;

  if not FileExists(Result) then
    raise EShowcaseProjectCatalog.Create('Allowlisted Showcase project is missing.');
end;

function TShowcaseProjectCatalog.IsTestTarget(
  const ATarget: TShowcaseProjectTarget): Boolean;
begin
  case ATarget of
    sptVirtualDesktopTests, sptMcpTests, sptGameLogicTests:
      Result := True;
    sptVirtualDesktop, sptMcpStdioSidecar:
      Result := False;
  else
    raise EShowcaseProjectCatalog.Create('Unknown Showcase project target.');
  end;
end;

end.
