unit frm_StatusBar;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls, Int_NeedsStatusbar;

type

  { TfrmStatusbar }

  TfrmStatusbar = class(TForm)
    StatusBar1: TStatusBar;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmStatusbar: TfrmStatusbar;

implementation

uses Frm_DockingMain;
{$IFDEF FPC} {$R *.lfm}   {$ELSE} {$R *.dfm}   {$ENDIF}

{ TfrmStatusbar }

procedure TfrmStatusbar.FormCreate(Sender: TObject);
begin
   frmMain.StatusBar1 := StatusBar1;
end;

end.

