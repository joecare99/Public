unit frm_TestPicturelistMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  ShellCtrls, fra_NavIData, fra_PictureList;

type

  { TFrmTestPictureListMain }

  TFrmTestPictureListMain = class(TForm)
    fraNavIData1: TfraNavIData;
    fraPictureList1: TfraPictureList;
    Panel1: TPanel;
    Panel2: TPanel;
    pnlBottom: TPanel;
    ShellTreeView1: TShellTreeView;
    StatusBar1: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ShellTreeView1SelectionChanged(Sender: TObject);
  private

  public

  end;

var
  FrmTestPictureListMain: TFrmTestPictureListMain;

implementation

{$R *.lfm}

{ TFrmTestPictureListMain }

procedure TFrmTestPictureListMain.FormCreate(Sender: TObject);
begin
  fraNavIData1.Data := fraPictureList1;
end;

procedure TFrmTestPictureListMain.FormDestroy(Sender: TObject);
begin
  fraNavIData1.Data :=nil;
end;

procedure TFrmTestPictureListMain.ShellTreeView1SelectionChanged(Sender: TObject
  );
var
  lFilename: String;
begin
  lFilename:=ShellTreeView1.GetPathFromNode(ShellTreeView1.Selected);
  fraPictureList1.BasePath:=lFilename;
end;

end.

