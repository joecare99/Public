unit tst_BitView2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry,FileUtil;

type

  { TTestBitView }

  TTestBitView= class(TTestCase)
  private
    FFilefound:integer;
    FDirfound:integer;
    procedure DirectoryEvent(FileIterator: TFileIterator);
    procedure FileFound(FileIterator: TFileIterator);
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
    procedure TestMainForm;
    procedure TestLoadImages;
  end;

implementation

uses Forms,Frm_BitView2MAIN;

procedure TTestBitView.DirectoryEvent(FileIterator: TFileIterator);
begin
  inc(FDirFound);
  if FDirfound > 6000 then
    FileIterator.Stop;
end;

procedure TTestBitView.FileFound(FileIterator: TFileIterator);
begin
  inc(FFileFound);
  frmBitmapViewer2Main.LoadImage(FileIterator.FileName);
  Application.ProcessMessages;
  sleep(10);
  if FFilefound > 500 then
    FileIterator.Stop;
end;

procedure TTestBitView.SetUp;
begin
  if not assigned(frmBitmapViewer2Main) then
  Application.CreateForm(TfrmBitmapViewer2Main,frmBitmapViewer2Main);
end;

procedure TTestBitView.TearDown;
begin
  frmBitmapViewer2Main.hide;
end;

procedure TTestBitView.TestSetUp;
begin
  CheckNotNull(frmBitmapViewer2Main,'BitView Mainform is initialized');
  CheckFalse(frmBitmapViewer2Main.Visible,'MainForm is not visible at the moment');
end;

procedure TTestBitView.TestMainForm;
begin
  CheckFalse(frmBitmapViewer2Main.Visible,'MainForm is not visible at the moment');
  frmBitmapViewer2Main.Show;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmBitmapViewer2Main.Visible,'MainForm is visible now');
  frmBitmapViewer2Main.Cascade;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmBitmapViewer2Main.Visible,'MainForm is visible now');
  frmBitmapViewer2Main.Tile;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmBitmapViewer2Main.Visible,'MainForm is visible now');
  frmBitmapViewer2Main.hide;
  Application.ProcessMessages;
  sleep(100);
  CheckFalse(frmBitmapViewer2Main.Visible,'MainForm is visible now');
end;

procedure TTestBitView.TestLoadImages;

var FileSearcher:TFileSearcher;
begin
  CheckFalse(frmBitmapViewer2Main.Visible,'MainForm is not visible at the moment');
  frmBitmapViewer2Main.Show;
  Application.ProcessMessages;
  sleep(10);
  CheckTrue(frmBitmapViewer2Main.Visible,'MainForm is visible now');
  FileSearcher:=TFileSearcher.Create;
   try
    FileSearcher.OnFileFound:=@FileFound;
    FileSearcher.OnDirectoryEnter:=@DirectoryEvent;
    FileSearcher.OnDirectoryFound := @DirectoryEvent;
    FileSearcher.Search('\', '*.bmp;*.png;*.jpg;*.jpeg', True, False);
  finally
    freeandnil(FileSearcher);
  end;
end;


initialization

  RegisterTest(TTestBitView);
end.

