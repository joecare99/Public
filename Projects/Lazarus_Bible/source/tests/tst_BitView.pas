unit tst_BitView;

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

uses Forms,Frm_BitViewMAIN;

procedure TTestBitView.DirectoryEvent(FileIterator: TFileIterator);
begin
  inc(FDirFound);
  if FDirfound > 6000 then
    FileIterator.Stop;
end;

procedure TTestBitView.FileFound(FileIterator: TFileIterator);
begin
  inc(FFileFound);
  frmBitmapViewerMain.LoadImage(FileIterator.FileName);
  Application.ProcessMessages;
  sleep(10);
  if FFilefound > 500 then
    FileIterator.Stop;
end;

procedure TTestBitView.SetUp;
begin
  if not assigned(frmBitmapViewerMain) then
  Application.CreateForm(TfrmBitmapViewerMain,frmBitmapViewerMain);
end;

procedure TTestBitView.TearDown;
begin
  frmBitmapViewerMain.hide;
end;

procedure TTestBitView.TestSetUp;
begin
  CheckNotNull(frmBitmapViewerMain,'BitView Mainform is initialized');
  CheckFalse(frmBitmapViewerMain.Visible,'MainForm is not visible at the moment');
end;

procedure TTestBitView.TestMainForm;
begin
  CheckFalse(frmBitmapViewerMain.Visible,'MainForm is not visible at the moment');
  frmBitmapViewerMain.Show;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmBitmapViewerMain.Visible,'MainForm is visible now');
  frmBitmapViewerMain.Cascade;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmBitmapViewerMain.Visible,'MainForm is visible now');
  frmBitmapViewerMain.Tile;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmBitmapViewerMain.Visible,'MainForm is visible now');
  frmBitmapViewerMain.hide;
  Application.ProcessMessages;
  sleep(100);
  CheckFalse(frmBitmapViewerMain.Visible,'MainForm is visible now');
end;

procedure TTestBitView.TestLoadImages;

var FileSearcher:TFileSearcher;
begin
  CheckFalse(frmBitmapViewerMain.Visible,'MainForm is not visible at the moment');
  frmBitmapViewerMain.Show;
  Application.ProcessMessages;
  sleep(10);
  CheckTrue(frmBitmapViewerMain.Visible,'MainForm is visible now');
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

