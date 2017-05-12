unit Frm_SyscolorMAIN;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls,
  Frm_AboutDlg, IniFiles, Menus;

const
  maxColors = 19;           { Number of Windows system colors }
  redMask = $000000FF;         { Red value extraction mask }
  greenMask = $0000FF00;       { Green value extraction mask }
  blueMask = $00FF0000;        { Blue value extraction mask }
  iniFileName = 'SysColor.Ini';{ Located in Windows directory }

type
  TMainForm = class(TForm)
    BlueEdit: TEdit;
    BlueLabel: TLabel;
    BlueSB: TScrollBar;
    ClearBitBtn: TBitBtn;
    CloseBitBtn: TBitBtn;
    ColorEdit: TEdit;
    ColorLabel: TLabel;
    FileAbout: TMenuItem;
    FileExit: TMenuItem;
    FileMenu: TMenuItem;
    GreenEdit: TEdit;
    GreenLabel: TLabel;
    GreenSB: TScrollBar;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    RedEdit: TEdit;
    RedLabel: TLabel;
    RedSB: TScrollBar;
    ResetAllBitBtn: TBitBtn;
    ResetBitBtn: TBitBtn;
    SaveBitBtn: TBitBtn;
    SaveCheckBox: TCheckBox;
    SetBitBtn: TBitBtn;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    Shape9: TShape;
    Shape10: TShape;
    Shape11: TShape;
    Shape12: TShape;
    Shape13: TShape;
    Shape14: TShape;
    Shape15: TShape;
    Shape16: TShape;
    Shape17: TShape;
    Shape18: TShape;
    Shape19: TShape;
    procedure ClearBitBtnClick(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure FileAboutClick(Sender: TObject);
    procedure FileExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ResetAllBitBtnClick(Sender: TObject);
    procedure ResetBitBtnClick(Sender: TObject);
    procedure SaveBitBtnClick(Sender: TObject);
    procedure SaveCheckBoxClick(Sender: TObject);
    procedure SBChange(Sender: TObject);
    procedure SetBitBtnClick(Sender: TObject);
    procedure ShapeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    IniFile: TIniFile;
    IniItemList: TStringList;
    EditControls: array[0 .. 2] of TEdit;
    ScrollBars: array[0 .. 2] of TScrollBar;
    Shapes: array[0 .. maxColors - 1] of TShape;
    CurrentShape: TShape;
    procedure UpdateColor;
    procedure InitSysColorArray;
    procedure ChangeSystemColors;
    procedure SetScrollBars(C: TColor);
    procedure LoadSettings;
    procedure SaveSettings;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

type
{ Holds current system colors }
  SysColorRec = record
    OriginalColor: TColor;  { Color on starting program }
    CurrentColor: TColor;   { New color selected by user }
  end;

var
{ Array of SysColorRec values }
  SysColorArray: array[0 .. maxColors - 1] of SysColorRec;

{ Update sample colors from scrollbar positions }
procedure TMainForm.UpdateColor;
begin
{ Update color edit box (the large sample window) }
  ColorEdit.Color :=
    RGB(RedSB.Position, GreenSB.Position, BlueSB.Position);
{ Update labeled Shape color box and SysColorArray }
  if CurrentShape <> nil then with CurrentShape do
  begin
    Brush.Color := ColorEdit.Color;
    SysColorArray[Tag - 1].CurrentColor := Brush.Color;
  end;
end;

{ Load system colors into the SysColor array }
procedure TMainForm.InitSysColorArray;
var
  I: Integer;
begin
  for I := 0 to maxColors - 1 do with SysColorArray[I] do
  begin
    OriginalColor := GetSysColor(I);
    CurrentColor := OriginalColor;
    Shapes[I].Brush.Color := OriginalColor;
  end;
end;

{ Change system colors to values in SysColorArray }
procedure TMainForm.ChangeSystemColors;
var
  I: Integer;
  InxArray: Array[0 .. maxColors - 1] of Integer;
  ClrArray: Array[0 .. maxColors - 1] of TColor;
begin
  for I := 0 to maxColors - 1 do
  begin
    InxArray[I] := I;
    ClrArray[I] := SysColorArray[I].CurrentColor;
  end;
  SetSysColors(maxColors, InxArray[0], ClrArray[0]);
end;

{ Initialize TObject control arrays }
procedure TMainForm.FormCreate(Sender: TObject);
var
  I: Integer;
begin
{ Construct IniFile object instance }
  IniFile := TIniFile.Create(iniFileName);
{ Miscellaneous initializations }
  CurrentShape := nil;  { No selected labeled color shape }
{ Assign object references to easy-access arrays }
  EditControls[0] := RedEdit;
  EditControls[1] := GreenEdit;
  EditControls[2] := BlueEdit;
  ScrollBars[0] := RedSB;
  ScrollBars[1] := GreenSB;
  ScrollBars[2] := BlueSB;
{ Assign Shape color box object references to Shapes array }
  for I := 0 to maxColors - 1 do
    Shapes[I] := TShape(FindComponent('Shape' + IntToStr(I + 1)));
{ Create item list from Labels for Ini file read/write }
  IniItemList := TStringList.Create;
  with IniItemList do
  for I := 0 to maxColors - 1 do
    Add(TLabel(FindComponent('Label' + IntToStr(I + 1))).Caption);
{ Load current colors and possible Ini file settings }
  InitSysColorArray;  { Initialize SysColor array }
  LoadSettings;       { Load SysColor.Ini settings if present }
end;

{ Save settings if SaveCheckBox selected }
procedure TMainForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if SaveCheckBox.Checked then
    SaveSettings;  { Save settings in SysColor.Ini }
end;

{ Last chance to clean up }
procedure TMainForm.FormDestroy(Sender: TObject);
begin
  IniItemList.Free;
  IniFile.Free;
end;

{ Set scrollbar positions to match color C }
procedure TMainForm.SetScrollBars(C: TColor);
begin
{ The following assignments also update Edit boxes }
  RedSB.Position := C and redMask;
  GreenSB.Position := (C and greenMask) shr 8;
  BlueSB.Position := (C and blueMask) shr 16;
end;

{ Update values in Edit boxes for ScrollBar changes }
procedure TMainForm.SBChange(Sender: TObject);
begin
  with Sender as TScrollBar do
    EditControls[Tag].Text := IntToStr(Position);
  UpdateColor;
end;

{ Update scrollbar positions for Edit box changes }
procedure TMainForm.EditChange(Sender: TObject);
begin
  with Sender as TEdit do
    ScrollBars[Tag].Position := StrToInt(Text);
end;

{ Select color shape on mouse down event }
procedure TMainForm.ShapeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  P: TLabel;   { Pointer to matching TLabel object }
begin
  CurrentShape := TShape(Sender);  { Save clicked Shape }
  P := TLabel(FindComponent('Label' + IntToStr(CurrentShape.Tag)));
  if P <> nil then
    ColorLabel.Caption := P.Caption;  { Show color name }
  SetScrollBars(CurrentShape.Brush.Color);  { Synch scroll bars }
end;

{ Load colors and options from SysColor.Ini if present }
procedure TMainForm.LoadSettings;
var
  IniValueList: TStringList;
  I: Integer;
begin
  IniValueList := TStringList.Create;
  try
  { [SysColor] settings }
    IniFile.ReadSectionValues('SysColor', IniValueList);
    for I := 0 to IniValueList.Count - 1 do
    with SysColorArray[I] do
    begin
      CurrentColor := StrToInt(
        IniValueList.Values[IniItemList[I]]);
      OriginalColor := CurrentColor;
    end;
  { [Options] settings }
    SaveCheckBox.Checked :=
      IniFile.ReadBool('Options', 'Save settings', False);
  finally
    IniValueList.Free;
  end;
  ChangeSystemColors;
  InitSysColorArray;
end;

{ Create or update SysColor.Ini color settings only }
procedure TMainForm.SaveSettings;
var
  I: Integer;
begin
{ [SysColor] settings }
  for I := 0 to IniItemList.Count - 1 do
    IniFile.WriteString('SysColor', IniItemList[I],
      IntToStr(SysColorArray[I].CurrentColor));
end;

{ Write check box setting to SysColor.Ini }
procedure TMainForm.SaveCheckBoxClick(Sender: TObject);
begin
  IniFile.WriteBool('Options', 'Save settings',
    SaveCheckBox.Checked);
end;

{ File|About command event handler }
procedure TMainForm.FileAboutClick(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

{ File|Exit command event handler }
procedure TMainForm.FileExitClick(Sender: TObject);
begin
  Close;
end;

{ Clear association between system color and sample }
procedure TMainForm.ClearBitBtnClick(Sender: TObject);
begin
  ColorLabel.Caption := 'None';
  CurrentShape := nil;
end;

{ Save button click handler }
procedure TMainForm.SaveBitBtnClick(Sender: TObject);
begin
  SaveSettings;
end;

{ Set system colors to user selections }
procedure TMainForm.SetBitBtnClick(Sender: TObject);
begin
  ChangeSystemColors;
end;

{ Reset system colors to values saved at start of program }
procedure TMainForm.ResetBitBtnClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to maxColors - 1 do with SysColorArray[I] do
  begin
    CurrentColor := OriginalColor;
    Shapes[I].Brush.Color := OriginalColor;
  end;
  ClearBitBtn.Click;  { Clear sample color selection }
end;

{ Reset program colors and also Windows system colors }
procedure TMainForm.ResetAllBitBtnClick(Sender: TObject);
begin
  ResetBitBtn.Click;  { Reset to startup color set }
  SetBitBtn.Click;    { Reset Windows to use the set }
end;

end.

{ -------------------------------------------------------------
  Copyright (c) 1991,1993,1995 by Tom Swan. All rights reserved.
  Revision 1.00    Date: 2/1/1991
  Revision 1.01    Date: 2/27/1991
  1. Changed all cm_Exit constants to cm_Quit
  2. Changed all CMExit procedure names to CMQuit
  3. Added length argument to all TStatic object inits
  Revision 1.02    Date: 5/11/1991
  1. Changed all PostQuitMessage calls to CloseWindow
  2. Added TColorScrollBar object
  3. Enabled (limited) keyboard use of controls
  4. Added hot key letters to buttons
  5. Moved most string constants to string table resource
  Revision 2.00    Date: 10/21/1992
  1. Minor revisions for Borland 7.0
  2. Adjusted some dimensions for 1024x768 resolution displays
  3. Modified About box to use Borland Custom Controls
  Revision 3.0     Date: 6/6/1995
  1. Major rewrite for Delphi 1.0
  2. Redesigned interface using visual components
  3. Read and write Syscolor.Ini with TIniFile object
  4. Added [Options] section to Syscolor.Ini
  5. No longer prompts to save changes
  6. Deleted command-line options
  7. Deleted NonStop operation
  8. Added Save Settings on Exit checkbox
  ------------------------------------------------------------- }

