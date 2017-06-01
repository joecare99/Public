unit frm_WinCub;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}
interface

uses
  SysUtils,
  Classes,
  Graphics,
  Controls,
  StdCtrls,
  ExtCtrls,
  Forms,
  Buttons,
  Cls_ColCub;

type

  { TfrmWinCub }

  TfrmWinCub = class(TForm)
    pnlHost: TPanel;
    btnUp1, btnUp2, btnUp3, btnUp4: TButton;
    btnDown1, btnDown2, btnDown3, btnDown4: TButton;
    btnLeft1, btnLeft2, btnLeft3, btnLeft4: TButton;
    btnRight1, btnRight2, btnRight3, btnRight4: TButton;

    btnShuffle: TButton;

    lblComplett: TLabel;

    pnlSteps: TPanel;
    lblStep1: TLabel;
    lblStep2: TLabel;

    procedure btnDown1Click(Sender: TObject);
    procedure btnLeft1Click(Sender: TObject);
    procedure btnUp1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var {%H-}Action: TCloseAction);
    procedure btnRight1Click(Sender: TObject);
    procedure btnShuffle_Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    pnlCubs: array[1..4, 1..4] of TPanel;
    btnUp: array[1..4] of TButton;
    btnDown: array[1..4] of TButton;
    btnLeft: array[1..4] of TButton;
    btnRight: array[1..4] of TButton;
    FColCub: TColCubEngine;
    FComplete: boolean;

  public

    procedure CompParams;

  published

  end;

var
  frmWinCub: TfrmWinCub;

implementation

resourcestring
  rsLazColorCub = 'ColorCub for Lazarus inspired by E. I. Simay';

{$R *.lfm}
{$R icon.RES}

var
  StdCols: array[1..4] of TColor;

procedure TfrmWinCub.FormCreate(Sender: TObject);
var
  i, j: integer;

const
  sp = 5;

begin
  FColCub := TColCubEngine.Create;
  Caption := rsLazColorCub;
  for i := 1 to 4 do
  begin

    btnUp[i] := TButton(FindComponent('btnUp' + IntToStr(i)));
    btnDown[i] := TButton(FindComponent('btnDown' + IntToStr(i)));
    btnLeft[i] := TButton(FindComponent('btnLeft' + IntToStr(i)));
    btnRight[i] := TButton(FindComponent('btnRight' + IntToStr(i)));

    for j := 1 to 4 do
    begin
      pnlCubs[i, j] := TPanel.Create(Self);
      pnlCubs[i, j].Parent := pnlHost;
    end;
  end;

  FComplete := True;

  Application.Icon.LoadFromResourceName(HInstance, 'BIGCUB');

  FColCub.Cols := 4;
  FColCub.Rows := 4;
  FColCub.Initialize;

  StdCols[1] := clRed;
  StdCols[2] := clLime;
  StdCols[3] := clYellow;
  StdCols[4] := clBlue;

  for i := 0 to 3 do
    for j := 0 to 3 do
    begin
      pnlCubs[j + 1, i + 1].Name := 'pnlCubs_' + IntToStr(j + 1) + '_' + IntToStr(i + 1);
      pnlCubs[j + 1, i + 1].Caption := '';
      pnlCubs[j + 1, i + 1].Width := btnUp1.Width;
      pnlCubs[j + 1, i + 1].Height := btnLeft1.Height;
      pnlCubs[j + 1, i + 1].Color := StdCols[FColCub.Tile[J, i]];
      pnlCubs[j + 1, i + 1].Left := btnUp1.left + (j) * btnUp1.Width + (j) * sp;
      pnlCubs[j + 1, i + 1].Top := btnLeft1.top + (i) * btnLeft1.Height + (i) * sp;
    end;
end;


procedure TfrmWinCub.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(FColCub);
  inherited;
end;

procedure TfrmWinCub.btnUp1Click(Sender: TObject);
var
  i: integer;
begin
  if not FComplete then
   begin
     i := TWinControl(Sender).tag + 1;
     FColCub.MoveCol(i - 1, True);
   end;
  CompParams;
end;

procedure TfrmWinCub.btnDown1Click(Sender: TObject);
var
  i: integer;
begin
   if not FComplete then
  begin
    i := TWinControl(Sender).tag + 1;
        FColCub.MoveCol(i - 1, False);
  end;
   CompParams;
end;

procedure TfrmWinCub.btnLeft1Click(Sender: TObject);
var
  i: integer;
begin
   if not FComplete then
   begin
     i := TWinControl(Sender).tag + 1;
         FColCub.MoveRow(i - 1, True);
       end;
   CompParams;
end;

procedure TfrmWinCub.btnRight1Click(Sender: TObject);
var
  i: integer;
begin
  if not FComplete then
  begin
    i := TWinControl(Sender).tag + 1;
        FColCub.MoveRow(i - 1, False);
    end;
    CompParams;
  end;

procedure TfrmWinCub.CompParams;
var
  i, j: integer;
begin
  lblStep2.Caption := inttostr(FColCub.Moves);
  FComplete := FColCub.IsComplete;
  for i := 0 to 3 do
    for j := 0 to 3 do
      pnlCubs[j + 1, i + 1].Color := StdCols[FColCub.Tile[J, i]];
  btnShuffle.Enabled := FComplete;
  lblComplett.Visible := FComplete;
end;


procedure TfrmWinCub.btnShuffle_Click(Sender: TObject);
var

  i, j: integer;

begin
  FComplete := False;
  Randomize;
  FColCub.Shuffle;
  for i := 0 to 3 do
    for j := 0 to 3 do
      pnlCubs[j + 1, i + 1].Color := StdCols[FColCub.Tile[J, i]];
  btnShuffle.Enabled := FComplete;
  lblComplett.Visible := FComplete;
  lblStep2.Caption := inttostr(FColCub.Moves);
end;

end.
