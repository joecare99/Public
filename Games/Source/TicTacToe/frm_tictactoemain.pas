unit frm_TicTacToeMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { TfrmTicTacToe }

  TfrmTicTacToe = class(TForm)
    Button1: TButton;
    btnFirst: TButton;
    btnRestart: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    pnlPlayfield: TPanel;
    procedure ButClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PCstarts(Sender: TObject);
    procedure Restart(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

type
  TicTacToe = array [0..2] of array [0..2] of byte;

var
  frmTicTacToe: TfrmTicTacToe;
  Matrix: TicTacToe = ((0, 0, 0), (0, 0, 0), (0, 0, 0));
  Buttons: array [0..2] of array [0..2] of TButton;

implementation

{$R *.lfm}

procedure ShowMatrix();
var
  x, y: byte;
begin
  for x := 0 to 2 do
    for y := 0 to 2 do
    begin
      case (Matrix[y][x]) of
        0:
        begin
          Buttons[y][x].Enabled := True;
          Buttons[y][x].Caption := '';
        end;
        1:
        begin
          Buttons[y][x].Enabled := False;
          Buttons[y][x].Caption := 'X';
        end;
        2:
        begin
          Buttons[y][x].Enabled := False;
          Buttons[y][x].Caption := 'O';
        end;
      end;
    end;
end;

procedure AI(var m: TicTacToe; ai: byte);
var
  hi, x, y, _x, _y, d: smallint;
begin
  hi := ai - 1;
  if (hi = 0) then
    hi := 2;

  if (m[1][1] = 0) then
  begin
    m[1][1] := ai;
    exit;
  end; // Wenn möglich, mittleres Feld belegen

  for d := 0 to 2 do
  begin // Falls notwendig, Gegner blocken
    if (m[d][d] = ai) then
      continue;
    for x := 0 to 2 do
      for y := 0 to 2 do
      begin
        if ((x = y) and (x = d)) or (m[y][x] = ai) then
          continue;
        if (d = 1) then
        begin
          _x := 2 * d - x;
          _y := 2 * d - y;
        end
        else
        begin
          _x := 2 * x - d;
          _y := 2 * y - d;
        end;
        if (word(_x) > 2) or (word(_y) > 2) or (m[_y][_x] = ai) then
          continue;
        if (m[d][d] + m[y][x] + m[_y][_x] = hi * 2) then
        begin
          if (m[d][d] = 0) then
            m[d][d] := ai
          else if (m[y][x] = 0) then
            m[y][x] := ai
          else
            m[_y][_x] := ai;
          exit;
        end;
      end;
  end;

  for x := 0 to 2 do
    for y := 0 to 2 do
    begin // Ein freies Feld belegen - Ecken zuerst
      _x := x * 2;
      if (_x = 4) then
        _x := 1;
      _y := y * 2;
      if (_y = 4) then
        _y := 1;
      if (m[_y][_x] = 0) then
      begin
        if (_x + _y = 0) and (m[2][2] = 0) and ((m[1][2] = hi) or (m[2][1] = hi)) then
        begin
          m[2][2] := ai;
          exit;
        end; // bei spezieller Belegung 22 00 vorziehen
        if (_x = 0) and (_y = 2) and (m[0][2] = 0) and
          ((m[0][1] = hi) or (m[1][2] = hi)) then
        begin
          m[0][2] := ai;
          exit;
        end; // bei spezieller Belegung 02 20 vorziehen
        m[_y][_x] := ai;
        exit;
      end;
    end;
end;

function Winner(const m: TicTacToe): smallint;
var
  hi, x, y, _x, _y, d: smallint;
begin
  Result := -1;
  for d := 0 to 2 do
  begin
    if (m[d][d] = 0) then
      continue;
    for x := 0 to 2 do
      for y := 0 to 2 do
      begin
        if ((x = y) and (x = d)) or (m[y][x] <> m[d][d]) then
          continue;
        if (d = 1) then
        begin
          _x := 2 * d - x;
          _y := 2 * d - y;
        end
        else
        begin
          _x := 2 * x - d;
          _y := 2 * y - d;
        end;
        if (word(_x) > 2) or (word(_y) > 2) or (m[_y][_x] <> m[d][d]) then
          continue;
        if (m[d][d] = m[_y][_x]) then
        begin
          Result := m[d][d];
          exit;
        end;
      end;
  end;
  for x := 0 to 2 do
    for y := 0 to 2 do
      if (m[y][x] = 0) then
        exit;
  Result := 0;
end;

procedure TfrmTicTacToe.ButClick(Sender: TObject);
label
  found;
var
  x, y: byte;
  w: smallint;
begin
  for x := 0 to 2 do
    for y := 0 to 2 do
      if (Buttons[y][x] = Sender) then
        goto found;
  exit;
  found:
    if (Matrix[y][x] <> 0) then
      exit;
  Matrix[y][x] := 1;
  AI(Matrix, 2);
  btnFirst.Enabled := False;
  ShowMatrix();
  w := Winner(Matrix);
  if (w <> -1) then
  begin
    if (w = 1) then
      ShowMessage('Gewonnen!')
    else if (w = 2) then
      ShowMessage('Verloren!')
    else
      ShowMessage('Unentschieden!');
    Restart(nil);
  end;
end;

procedure TfrmTicTacToe.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to 8 do
    Buttons[i div 3][i mod 3] := Tbutton(FindComponent('Button'+inttostr(i+1)));
end;

procedure TfrmTicTacToe.PCstarts(Sender: TObject);
begin
  AI(Matrix, 2);
  btnFirst.Enabled := False;
  ShowMatrix();
end;

procedure TfrmTicTacToe.Restart(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to 8 do
  Matrix[i div 3][i mod 3] := 0;
  btnFirst.Enabled := True;
  ShowMatrix();
end;

end.
