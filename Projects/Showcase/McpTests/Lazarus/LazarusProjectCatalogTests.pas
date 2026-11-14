unit LazarusProjectCatalogTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, LazarusProjectContracts;

type
  TLazarusProjectCatalogTest = class(TTestCase)
  published
    procedure ListsOnlyTheFiveShowcaseTargets;
    procedure ResolvesCanonicalFilesWithinShowcaseRoot;
    procedure RejectsPathOutsideShowcaseRoot;
    procedure ExposesNarrowServiceContracts;
  end;

implementation

uses
  SysUtils, LazarusProjectCatalog, LazarusIdeLauncher,
  LazarusBuildTestRunner, VirtualDesktopProcessService;

procedure TLazarusProjectCatalogTest.ListsOnlyTheFiveShowcaseTargets;
var
  Catalog: IShowcaseProjectCatalog;
  Targets: TShowcaseProjectTargets;
begin
  Catalog := TShowcaseProjectCatalog.Create;
  Targets := Catalog.Targets;
  AssertEquals(5, Length(Targets));
  AssertEquals(Ord(sptVirtualDesktop), Ord(Targets[0]));
  AssertEquals(Ord(sptVirtualDesktopTests), Ord(Targets[1]));
  AssertEquals(Ord(sptMcpStdioSidecar), Ord(Targets[2]));
  AssertEquals(Ord(sptMcpTests), Ord(Targets[3]));
  AssertEquals(Ord(sptGameLogicTests), Ord(Targets[4]));
  AssertEquals('VirtualDesktop.lpi', Catalog.ProjectName(sptVirtualDesktop));
  AssertEquals('VirtualDesktopTests.lpi',
    Catalog.ProjectName(sptVirtualDesktopTests));
  AssertEquals('McpStdioSidecar.lpi', Catalog.ProjectName(sptMcpStdioSidecar));
  AssertEquals('McpTests.lpi', Catalog.ProjectName(sptMcpTests));
  AssertEquals('GameLogicTests.lpr', Catalog.ProjectName(sptGameLogicTests));
end;

procedure TLazarusProjectCatalogTest.ResolvesCanonicalFilesWithinShowcaseRoot;
var
  Catalog: IShowcaseProjectCatalog;
  Target: TShowcaseProjectTarget;
  ProjectFile: string;
begin
  Catalog := TShowcaseProjectCatalog.Create;
  for Target := Low(TShowcaseProjectTarget) to High(TShowcaseProjectTarget) do
  begin
    ProjectFile := Catalog.ProjectFile(Target);
    AssertTrue(FileExists(ProjectFile));
    AssertEquals(CanonicalShowcasePath(ProjectFile), ProjectFile);
  end;
  AssertTrue(Catalog.IsTestTarget(sptVirtualDesktopTests));
  AssertTrue(Catalog.IsTestTarget(sptMcpTests));
  AssertTrue(Catalog.IsTestTarget(sptGameLogicTests));
  AssertFalse(Catalog.IsTestTarget(sptVirtualDesktop));
  AssertFalse(Catalog.IsTestTarget(sptMcpStdioSidecar));
end;

procedure TLazarusProjectCatalogTest.RejectsPathOutsideShowcaseRoot;
begin
  try
    CanonicalShowcasePath(ShowcaseRootDirectory + '\..\outside.lpi');
    Fail('Paths outside Showcase root must be rejected.');
  except
    on E: EShowcaseProjectCatalog do
      ;
  end;
end;

procedure TLazarusProjectCatalogTest.ExposesNarrowServiceContracts;
var
  Launcher: ILazarusIdeLauncher;
  Runner: ILazarusBuildTestRunner;
  ProcessService: IVirtualDesktopProcessService;
  Status: TVirtualDesktopProcessStatus;
begin
  Launcher := TLazarusIdeLauncher.Create;
  Runner := TLazarusBuildTestRunner.Create;
  ProcessService := TVirtualDesktopProcessService.Create;
  Status := ProcessService.ProcessStatus;
  if IsWindowsPlatform then
    AssertEquals(Ord(vdpsNotRunning), Ord(Status.State))
  else
    AssertEquals(Ord(vdpsUnsupportedPlatform), Ord(Status.State));
  AssertTrue(Launcher <> nil);
  AssertTrue(Runner <> nil);
end;

initialization
  RegisterTest(TLazarusProjectCatalogTest);

end.
