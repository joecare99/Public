Unit frm_logicConf;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

Interface

Uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls, Spin, Grids;

Type
  TFrmLogicConf = Class(TForm)
    StringGrid1: TStringGrid;
    Panel1: TPanel;
    StaticText1: TStaticText;
    SpinEdit1: TSpinEdit;
    Bevel1: TBevel;
    SpeedButton1: TSpeedButton;
    StaticText2: TStaticText;
    SpinEdit2: TSpinEdit;
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    Procedure SpinEdit1Change(Sender: TObject);
    Procedure SpeedButton1Click(Sender: TObject);
  private
    FSuccess:Tnotifyevent;
    procedure FillEmptyCells;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Property OnSuccess:Tnotifyevent read FSuccess write FSuccess;
    Procedure Clear;
  End;

Var
  FrmLogicConf: TFrmLogicConf;

Implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

Procedure TFrmLogicConf.SpeedButton1Click(Sender: TObject);
Begin
  StringGrid1.FixedRows := 1 - StringGrid1.FixedRows;
  If StringGrid1.FixedRows = 1 Then
    Begin
      bevel1.Style := bsRaised;
    End
  Else
    Begin
      bevel1.Style := bsLowered;
    End;
End;

procedure TFrmLogicConf.BitBtn1Click(Sender: TObject);
begin
  if assigned(FSuccess) then
    fsuccess(sender);
  close;
end;

procedure TFrmLogicConf.FillEmptyCells;
var
  j: Integer;
  i: Integer;
begin
  for I := 0 to stringgrid1.colCount - 1 do
    for j := 0 to stringgrid1.rowCount - 1 do
      if stringgrid1.Cells[i, j] = '' then
        stringgrid1.Cells[i, j] := inttostr(i+1) + '.' + inttostr(j);
end;

Procedure TFrmLogicConf.SpinEdit1Change(Sender: TObject);
Var
  VV: Integer;
Begin
  If TryStrToInt(spinedit1.Text, VV) Then
    StringGrid1.ColCount := vv;
  FillEmptyCells;
End;

procedure TFrmLogicConf.SpinEdit2Change(Sender: TObject);
Var
  VV: Integer;
Begin
  If TryStrToInt(spinedit2.Text, VV) Then
    StringGrid1.RowCount := vv+1;
  FillEmptyCells;
end;

procedure TFrmLogicConf.clear ;
var
  I: Integer;
  J: Integer;
begin
  //
  spinedit1.Value := 6;
  spinedit2.Value := 6;
  SpinEdit1Change(self);
  SpinEdit2Change(self);
  for I := 0 to spinedit1.Value - 1 do
   for J := 0 to spinedit2.Value  do
     StringGrid1.Cells[i,j]:='';
end;

End.

