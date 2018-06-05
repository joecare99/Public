unit frm_MouseAndKeyExMain;

{$IFDEF FPC}
{$mode Delphi}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Grids, ExtCtrls, StdCtrls;

type

  { TfrmMouseAndKeyExMain }

  TfrmMouseAndKeyExMain = class(TForm)
    btnSelectCells: TButton;
    btnMoveMouse: TButton;
    btnEnterHello: TButton;
    btnScrollDownUp: TButton;
    edtDemofield: TEdit;
    stgDemoGrid: TStringGrid;
    procedure btnSelectCellsClick(Sender: TObject);
    procedure btnMoveMouseClick(Sender: TObject);
    procedure btnEnterHelloClick(Sender: TObject);
    procedure btnScrollDownUpClick(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
  private

  public
    procedure SelectCells(Data: PtrInt);
    procedure MoveToCorner(Data: PtrInt);
    procedure SendKeys(Data: PtrInt);
    procedure ScrollUpDown(Data: PtrInt);
  end; 

var
  frmMouseAndKeyExMain: TfrmMouseAndKeyExMain;

implementation

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

uses
  MouseAndKeyInput, LCLType;

{ TfrmMouseAndKeyExMain }

procedure TfrmMouseAndKeyExMain.FormDblClick(Sender: TObject);
begin
  Caption := Caption + ' DblClicked';
end;

procedure TfrmMouseAndKeyExMain.SelectCells(Data: PtrInt);
begin
  stgDemoGrid.SetFocus;
  Application.ProcessMessages;
  MouseInput.Down(mbLeft, [], stgDemoGrid, 10, 10);
  MouseInput.Up(mbLeft, [], stgDemoGrid, 200, 100);
end;

procedure TfrmMouseAndKeyExMain.MoveToCorner(Data: PtrInt);
begin
  MouseInput.Move([], frmMouseAndKeyExMain, 0, 0, 1000);
  MouseInput.DblClick(mbLeft, []);
end;

procedure TfrmMouseAndKeyExMain.SendKeys(Data: PtrInt);
begin
  edtDemofield.SetFocus;
  Application.ProcessMessages;
  KeyInput.Apply([ssShift]);
  KeyInput.Press(VK_H);
  KeyInput.Unapply([ssShift]);
  KeyInput.Press(VK_E);
  KeyInput.Press(VK_L);
  KeyInput.Press(VK_L);
  KeyInput.Press(VK_O);
end;

procedure TfrmMouseAndKeyExMain.ScrollUpDown(Data: PtrInt);
var
  I: Integer;
begin
  ActiveControl := stgDemoGrid;
  for I := 1 to 12 do
  begin
    if I < 6 then
      MouseInput.ScrollDown([], stgDemoGrid, 10, 10)
    else
      MouseInput.ScrollUp([], stgDemoGrid, 10, 10);
    Sleep(30);
  end;
end;

procedure TfrmMouseAndKeyExMain.btnSelectCellsClick(Sender: TObject);
begin
  Application.QueueAsyncCall(SelectCells, 0);
end;

procedure TfrmMouseAndKeyExMain.btnMoveMouseClick(Sender: TObject);
begin
  Application.QueueAsyncCall(MoveToCorner, 0);
end;

procedure TfrmMouseAndKeyExMain.btnEnterHelloClick(Sender: TObject);
begin
  Application.QueueAsyncCall(SendKeys, 0);
end;

procedure TfrmMouseAndKeyExMain.btnScrollDownUpClick(Sender: TObject);
begin
  Application.QueueAsyncCall(ScrollUpDown, 0);
end;

end.

