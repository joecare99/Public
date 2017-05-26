unit frm_MyClockDef;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, ExtCtrls, ButtonPanel, cmp_OneClock, Buttons, Unt_Config;

type

  { TfrmMyClockDef }

  TfrmMyClockDef = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ButtonPanel1: TButtonPanel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Config1: TConfig;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    SpeedButton1: TSpeedButton;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    Splitter1: TSplitter;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Select(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure UpdateDesigner(Sender: TObject);
  private
    { private declarations }
    FClocks: array of TOneClock;
    FCbxTime: array of TComboBox;
    FoldWidth, FoldHeight: integer;
    FNoUpdate:boolean;
    FDataPath: string;
    procedure onCbxTimeChange(Sender: TObject);
    procedure OnClockClick(Sender: TObject);
  public
    { public declarations }
  end;

var
  frmMyClockDef: TfrmMyClockDef;

implementation

{$R *.lfm}

{ TfrmMyClockDef }

procedure TfrmMyClockDef.FormCreate(Sender: TObject);
var
  i: integer;
begin
  TOneClock.FillModeList(ComboBox1.Items);
  UpdateDesigner(Sender);
  FDataPath := 'Data';
  for i := 0 to 2 do
    if DirectoryExists(FDataPath) then
      break
    else
      FDataPath := '..' + DirectorySeparator + FDataPath;
  FDataPath := FDataPath + DirectorySeparator + 'MyClocks';
  if not DirectoryExists(FDataPath) then
    mkdir(FDataPath);
end;

procedure TfrmMyClockDef.SpeedButton1Click(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to high(FClocks) do
  begin
    FreeAndNil(FClocks[i]);
    FreeAndNil(FCbxTime[i]);
  end;
  setlength(FClocks, 0);
  setlength(FCbxTime, 0);
  FoldWidth := 0;
  FoldHeight := 0;
  UpdateDesigner(Sender);
end;

procedure TfrmMyClockDef.ComboBox1Change(Sender: TObject);
var
  i: integer;
  NewMode: TEnumMyClockMode;
begin
  NewMode := TEnumMyClockMode(
      ptrint(ComboBox1.Items.Objects[ComboBox1.ItemIndex]));
  for i := 0 to high(FClocks) do
    FClocks[i].Mode := NewMode;
  if NewMode in [emcm_DelVelo, emcm_Velocity] then
    for i := 0 to high(FClocks) do
      FClocks[i].speed:=MyTimeRecord((random(4)*4-7)*0.125,(random(8)*2-7)*0.125);
end;

procedure TfrmMyClockDef.ComboBox2Select(Sender: TObject);
var
  Section: string;
  i, idx: integer;
begin
  Section := 'DefDim(' + IntToStr(SpinEdit1.Value) + ',' + IntToStr(SpinEdit2.Value) + ')';
  for i := 0 to high(FClocks) do
  begin
    idx := FCbxTime[i].Items.IndexOfObject(
      TObject(ptrint(Config1.getvalue(section, ComboBox2.Text + '.' + IntToStr(i), 0))));
    FCbxTime[i].ItemIndex := idx;
    FClocks[i].Mode:=emcm_Position;
    onCbxTimeChange(FCbxTime[i]);
  end;
end;

procedure TfrmMyClockDef.BitBtn1Click(Sender: TObject);
var
  Section: string;
  lStr: TStrings;
  i, idx: integer;
begin
  Section := 'DefDim(' + IntToStr(SpinEdit1.Value) + ',' + IntToStr(SpinEdit2.Value) + ')';
  lStr := TStringList.Create;
  try
    lStr.Values['Width'] := SpinEdit1.Text;
    lStr.Values['Height'] := SpinEdit2.Text;
    lStr.Values['Count'] := IntToStr(high(FClocks) + 1);
    for i := 0 to high(FClocks) do
    begin
      Config1.setvalue(section, ComboBox2.Text + '.' + IntToStr(i), ptrint(
        FCbxTime[i].Items.Objects[FCbxTime[i].ItemIndex]));
      lStr.Values[IntToStr(i)] :=
        IntToStr(ptrint(FCbxTime[i].Items.Objects[FCbxTime[i].ItemIndex]));
    end;
    lStr.SaveToFile(FdataPath + DirectorySeparator + ComboBox2.Text + '(' +
      IntToStr(SpinEdit1.Value) + ',' + IntToStr(SpinEdit2.Value) + ').txt');
  finally
    FreeAndNil(lstr);
  end;
  idx := ComboBox2.items.IndexOf(ComboBox2.Text);
  if idx = -1 then
  begin
    ComboBox2.Items.Add(ComboBox2.Text);
    config1.setvalue(Section, 'LCount', ComboBox2.Items.Count);
    for i := 0 to ComboBox2.Items.Count - 1 do
      config1.setvalue(Section, 'idx.' + IntToStr(i), ComboBox2.Items[i]);
  end
  else
    ComboBox2.ItemIndex:=idx;
end;

procedure TfrmMyClockDef.BitBtn2Click(Sender: TObject);
var
  lStr: TStrings;
  i, idx: Integer;

begin
  OpenDialog1.FileName:=FDataPath+DirectorySeparator+ComboBox2.Text+ '(' +
      IntToStr(SpinEdit1.Value) + ',' + IntToStr(SpinEdit2.Value) + ')'+'.txt';
  if FileExists(OpenDialog1.FileName) or  OpenDialog1.Execute then
    begin
      lStr := TStringList.Create;
        try
         lstr.LoadFromFile(OpenDialog1.FileName);

          FnoUpdate:=true;
      SpinEdit1.Value              := strtoint(lStr.Values['Width']);
    SpinEdit2.value              := strtoint(lStr.Values['Height']);
      FnoUpdate:=False;
      if (SpinEdit1.Value<>FoldWidth) or (SpinEdit2.Value <>FoldHeight) then
         SpeedButton1Click(sender);
    if  IntToStr(high(FClocks) + 1) = lStr.Values['Count'] then
      for i := 0 to high(FClocks) do
   begin
    idx := FCbxTime[i].Items.IndexOfObject(
      TObject(ptrint(strtoint(lStr.Values[ IntToStr(i)]))));
    FCbxTime[i].ItemIndex := idx;
    onCbxTimeChange(FCbxTime[i]);
  end;
        finally
            FreeAndNil(lstr);
        end;
    end;
end;

procedure TfrmMyClockDef.UpdateDesigner(Sender: TObject);

  procedure CreateNewClock(I, NewX, NewY: integer);
  begin
    begin
      FClocks[i] := TOneClock.Create(self);
      FClocks[i].Parent := Panel2;
      FClocks[i].top := NewY * 40;
      FClocks[i].Left := NewX * 40;
      FClocks[i].Width := 40;
      FClocks[i].Height := 40;
      FClocks[i].InternalTimer := True;
      if ComboBox1.ItemIndex >=0 then
      FClocks[i].Mode := TEnumMyClockMode(
        ptrint(ComboBox1.Items.Objects[ComboBox1.ItemIndex]))
      else
        FClocks[i].Mode := emcm_ActTime;
      FClocks[i].tag := i;
      FClocks[i].OnClick := @OnClockClick;
      FCbxTime[i] := TComboBox.Create(self);
      FCbxTime[i].Parent := Panel3;
      FCbxTime[i].top := NewY * 40;
      FCbxTime[i].Left := NewX * 70;
      FCbxTime[i].Width := 70;
      FCbxTime[i].Height := 20;
      FCbxTime[i].tag := i;
      TOneClock.FillPDTmList(FCbxTime[i].Items);
      FCbxTime[i].onChange := @onCbxTimeChange;
    end;
  end;

var
  i, NewX, NewY, OldX, oldY: integer;
  Section: string;
begin
  if FNoUpdate then exit;
  if SpinEdit1.Value * SpinEdit2.Value > High(FClocks) + 1 then
  begin
    setlength(FClocks, SpinEdit1.Value * SpinEdit2.Value);
    setlength(FCbxTime, SpinEdit1.Value * SpinEdit2.Value);
    for i := High(FClocks) downto 0 do
    begin
      NewX := i mod SpinEdit1.Value;
      NewY := i div SpinEdit1.Value;
      if (NewX > FOldWidth - 1) or (NewY > FOldHeight - 1) then
        CreateNewClock(i, NewX, NewY)
      else
      begin
        FClocks[i] := FClocks[NewX + NewY * FoldWidth];
        FClocks[i].Tag := i;
        FCbxTime[i] := FCbxTime[NewX + NewY * FoldWidth];
        FCbxTime[i].Tag := i;
      end;
    end;
    FoldWidth := SpinEdit1.Value;
    FoldHeight := SpinEdit2.Value;
  end
  else if SpinEdit1.Value * SpinEdit2.Value < High(FClocks) + 1 then
  begin
    for i := 0 to High(FClocks) do
    begin
      OldX := i mod FoldWidth;
      oldY := i div FoldWidth;
      NewX := i mod SpinEdit1.Value;
      NewY := i div SpinEdit1.Value;
      if (oldX > SpinEdit1.Value - 1) or (OldY > SpinEdit2.Value - 1) then
      begin
        FreeAndNil(FClocks[i]);
        FreeAndNil(FCbxTime[i]);
        if NewY < Spinedit2.Value then
        begin
          FClocks[i] := FClocks[NewX + NewY * FoldWidth];
          FClocks[i].Tag := i;
          FCbxTime[i] := FCbxTime[NewX + NewY * FoldWidth];
          FCbxTime[i].Tag := i;
        end;
      end
      else
      if (NewY < Spinedit2.Value) and ((newx <> oldx) or (newy <> oldy)) then
      begin
        FClocks[i] := FClocks[NewX + NewY * FoldWidth];
        FClocks[i].Tag := i;
        FCbxTime[i] := FCbxTime[NewX + NewY * FoldWidth];
        FCbxTime[i].Tag := i;
      end;
    end;
    setlength(FClocks, SpinEdit1.Value * SpinEdit2.Value);
    setlength(FCbxTime, SpinEdit1.Value * SpinEdit2.Value);
    FoldWidth := SpinEdit1.Value;
    FoldHeight := SpinEdit2.Value;
  end;
  Section := 'DefDim(' + IntToStr(SpinEdit1.Value) + ',' + IntToStr(SpinEdit2.Value) + ')';
  combobox2.items.Clear;
  for i := 0 to config1.getvalue(Section, 'LCount', 0)-1 do
    begin
      if combobox2.items.indexof(config1.getvalue(Section, 'idx.' + IntToStr(i), '')) =-1 then
        combobox2.items.add(config1.getvalue(Section, 'idx.' + IntToStr(i), ''));
    end;
end;

procedure TfrmMyClockDef.OnClockClick(Sender: TObject);
begin
  if Sender.InheritsFrom(TOneClock) then
    ActiveControl := FCbxTime[TOneClock(Sender).Tag];
end;

procedure TfrmMyClockDef.onCbxTimeChange(Sender: TObject);
var
  cbx: TComboBox;
  tt: TMyTimeRecord;
begin
  if Sender.InheritsFrom(TComboBox) then
  begin
    cbx := TComboBox(Sender);
    if cbx.ItemIndex >= 0 then
      tt.SetPDefTime(TEnumPredefTimes(ptrint(cbx.Items.Objects[cbx.ItemIndex])));
    FClocks[cbx.tag].DestTime := tt;
    tt.SetValues(0.8, 0.8);
    FClocks[cbx.tag].speed := tt;
    FClocks[cbx.tag].Delay := 0;
  end;
end;

end.
