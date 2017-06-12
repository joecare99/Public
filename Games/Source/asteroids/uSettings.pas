Unit uSettings;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

Interface
Uses Classes, ComCtrls, Controls, Dialogs, ExtCtrls, Forms, StdCtrls;

Type tSettings = Class(tForm)
    Box_Stop: tCheckBox;
    Box_FirstP: tCheckBox;
    Box_Beep: tCheckBox;
    Box_Limit: tCheckBox;
    Box_Accel: tCheckBox;
    Box_ShowParts: tCheckBox;
    Box_ShowFPS: tCheckBox;
    LabelBlink: tLabel;
    LabelSparks: tLabel;
    TrackBar_Blink: tTrackBar;
    TrackBar_Sparks: tTrackBar;
    Panel_Color1: tPanel;
    Panel_Color2: tPanel;
    PanelKeys: tPanel;
    BtnKeys: tButton;
    ColorDialog: tColorDialog;
    Procedure Form_Close(Sender: tObject; Var Action: tCloseAction);
    Procedure Form_Create(Sender: tObject);
    Procedure Form_Destroy(Sender: tObject);
    Procedure Form_Show(Sender: tObject);
    Procedure Form_KeyDown(Sender: tObject; Var Key: Word; Shift: tShiftState);
    Procedure Form_KeyPress(Sender: tObject; Var Key: Char);
    Procedure Click_Stop(Sender: tObject);
    Procedure Click_FirstP(Sender: tObject);
    Procedure Change_Blink(Sender: tObject);
    Procedure Change_Sparks(Sender: tObject);
    Procedure Click_Color(Sender: tObject);
    Procedure Click_Beep(Sender: tObject);
    Procedure Click_Limit(Sender: tObject);
    Procedure Click_Accel(Sender: tObject);
    Procedure Click_Keys(Sender: tObject);
    Procedure Click_Info(Sender: tObject);
  private
  public
    KeyLeft, KeyRight,
      KeyAccel, KeyFire: Integer;
    FullScreen: Boolean;
    Procedure UpdateColors;
  End;

Var Settings: tSettings;

  function GetDataDir: string;
  function GetSettingsDir: string;

const
  SBaseDir = 'Data';
  SSettingFile = 'Asteroids.ini';
  CHighScoreFile = 'Asteroids.hsc';

Implementation
Uses
  {$IFDEF FPC}
  LCLIntf, LCLType,
  {$ELSE}windows,
  {$EndIF}
  Graphics, IniFiles, SysUtils, uGame, uMain, uKeys, uInfo;

var
  FDataDir, FSettingsDir: string;


{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
const DirectorySeparator=SysUtils.PathDelim;
{$ENDIF}

{Tools}

Var HexChar: Array[0..$0F] Of Char = '0123456789ABCDEF';

Function HexToInt(Text: String): Integer;
Begin
  Result := 0;
  While (Length(Text) <> 0) Do
    Begin
      Result := (Result Shl 4) + (Pos(Text[1], HexChar) - 1);
      Delete(Text, 1, 1);
    End;
End;

{Settings}

resourcestring
  cStartUp = 'StartUp';
  cWidth = 'Width';
  cFull = 'FullScreen';

  cSettings = 'Settings';
  cStop = 'Stop';
  cFirstP = 'FirstP';
  cBeep = 'Beep';
  cLimit = 'Limit';
  cAccel = 'Accel';
  cParts = 'Parts';
  cFPS = 'FPS';
  cBlink = 'Blink';
  cSparks = 'Sparks';
  cColor1 = 'Color1';
  cColor2 = 'Color2';

  cKeys = 'Keys';
  cKeyLeft = 'KeyLeft';
  cKeyRight = 'KeyRight';
  cKeyAccel = 'KeyAccel';
  cKeyFire = 'KeyFire';
  rsBlinkDelay = 'blink delay:%s%s';
  rsSparks = 'sparks:%s%s';


  function GetDataDir: string;
  begin
    Result := FDataDir;
  end;

  function GetSettingsDir: string;
  begin
    Result := FSettingsDir;
  end;


Procedure tSettings.Form_Close(Sender: tObject; Var Action: tCloseAction);
Begin
{If (not Application.Terminated) then Action := caNone;}
End;

Procedure tSettings.Form_Create(Sender: tObject);
Var Ini: tIniFile;
  tmpWidth: Integer;
Begin
  Ini := tIniFile.Create(GetSettingsDir+SSettingFile);
  tmpWidth := (Ini.ReadInteger(cStartUp, cWidth, 1024));
  FullScreen := (Ini.ReadInteger(cStartUp, cFull, 0) = 1);

  Box_Stop.Checked := (Ini.ReadInteger(cSettings, cStop, 1) = 1);
  Box_FirstP.Checked := (Ini.ReadInteger(cSettings, cFirstP, 0) = 1);
  Box_Beep.Checked := (Ini.ReadInteger(cSettings, cBeep, 0) = 1);
  Box_Limit.Checked := (Ini.ReadInteger(cSettings, cLimit, 1) = 1);
  Box_Accel.Checked := (Ini.ReadInteger(cSettings, cAccel, 0) = 1);
  Box_ShowParts.Checked := (Ini.ReadInteger(cSettings, cParts, 1) = 1);
  Box_ShowFPS.Checked := (Ini.ReadInteger(cSettings, cFPS, 1) = 1);
  TrackBar_Blink.Position := (Ini.ReadInteger(cSettings, cBlink, 3));
  TrackBar_Sparks.Position := (Ini.ReadInteger(cSettings, cSparks, 032));
  Panel_Color1.Color := (HexToInt(Ini.ReadString(cSettings, cColor1,
    '000000')));
  Panel_Color2.Color := (HexToInt(Ini.ReadString(cSettings, cColor2,
    'FFFFFF')));
  KeyLeft := (Ini.ReadInteger(cKeys, cKeyLeft, VK_Left));
  KeyRight := (Ini.ReadInteger(cKeys, cKeyRight, VK_Right));
  KeyAccel := (Ini.ReadInteger(cKeys, cKeyAccel, VK_Up));
  KeyFire := (Ini.ReadInteger(cKeys, cKeyFire, VK_Space));
  Ini.Free;
  If FullScreen Then
    Begin
      tmpWidth := Screen.Width;
      Main.BorderStyle := bsNone;
      Main.Cursor := -1;
    End
  Else
    Begin
      If (tmpWidth < 0128) Then
        tmpWidth := 0128;
      If (tmpWidth > 1600) Then
        tmpWidth := 1600;
    End;
  Main.ClientWidth := tmpWidth;
  Main.ClientHeight := tmpWidth * 3 Div 4;
  Change_Blink(Sender);
  Change_Sparks(Sender);
  UpdateColors;
End;

Procedure tSettings.Form_Destroy(Sender: tObject);
Var Ini: tIniFile;
Begin
  Ini := tIniFile.Create(getSettingsDir + SSettingFile);
  Ini.WriteInteger(cStartUp, cFull, Byte(FullScreen)); {StartUp}
  If (Not FullScreen) Then
    Ini.WriteInteger(cStartUp, cWidth, (Main.ClientWidth));
  Ini.WriteInteger(cSettings, cStop, Byte(Box_Stop.Checked)); {Settings}
  Ini.WriteInteger(cSettings, cFirstP, Byte(Box_FirstP.Checked));
  Ini.WriteInteger(cSettings, cBeep, Byte(Box_Beep.Checked));
  Ini.WriteInteger(cSettings, cLimit, Byte(Box_Limit.Checked));
  Ini.WriteInteger(cSettings, cAccel, Byte(Box_Accel.Checked));
  Ini.WriteInteger(cSettings, cParts, Byte(Box_ShowParts.Checked));
  Ini.WriteInteger(cSettings, cFPS, Byte(Box_ShowFPS.Checked));
  Ini.WriteInteger(cSettings, cBlink, (TrackBar_Blink.Position));
  Ini.WriteInteger(cSettings, cSparks, (TrackBar_Sparks.Position));
  Ini.WriteInteger(cKeys, cKeyLeft, (KeyLeft));
  Ini.WriteInteger(cKeys, cKeyRight, (KeyRight));
  Ini.WriteInteger(cKeys, cKeyAccel, (KeyAccel));
  Ini.WriteInteger(cKeys, cKeyFire, (KeyFire));
  Ini.Free;
End;

Procedure tSettings.Form_KeyDown(Sender: tObject; Var Key: Word; Shift:
  tShiftState);
Begin
  Case Key Of
    VK_F1: Box_Stop.Checked := Not Box_Stop.Checked;
    VK_F2: Box_FirstP.Checked := Not Box_FirstP.Checked;
    VK_F3: Box_Beep.Checked := Not Box_Beep.Checked;
    VK_F4: Box_Limit.Checked := Not Box_Limit.Checked;
    VK_F5: Box_Accel.Checked := Not Box_Accel.Checked;
    VK_F6: Box_ShowParts.Checked := Not Box_ShowParts.Checked;
    VK_F7: Box_ShowFPS.Checked := Not Box_ShowFPS.Checked;
  End;
End;

Procedure tSettings.Form_KeyPress(Sender: tObject; Var Key: Char);
Begin
  If (Byte(Key) = VK_Escape) Then
    Close;
End;

Procedure tSettings.Form_Show(Sender: tObject);
Begin
{Left := (Screen.Width  + Main.Width ) div 2;				{goto right border}
{Top  := (Screen.Height - Main.Height) div 2;				{goto top}
End;

Procedure tSettings.Click_Stop(Sender: tObject);
Begin
{}
End;

Procedure tSettings.Click_FirstP(Sender: tObject);
Var tmpPos: tPointSingle;
  i: Integer;
Begin
  If (Game = Nil) Then
    Exit;
  If (Not Game.Player.alive) Then
    Exit;
  If Box_FirstP.Checked Then
    With Game Do
      Begin
        With Player.Pos Do
          Begin
            tmpPos.x := 0.5 - x; {save movement}
            tmpPos.y := 0.5 - y;
            x := 0.5; {goto center}
            y := 0.5;
          End;
        For i := 0 To High(Rock) Do
          With Rock[i].Pos Do
            Begin
              x := x + tmpPos.x; {add movement}
              y := y + tmpPos.y;
            End;
        For i := 0 To High(Shot) Do
          With Shot[i].Pos Do
            Begin
              x := x + tmpPos.x; {add movement}
              y := y + tmpPos.y;
            End;
      End;
End;

Procedure tSettings.Change_Blink(Sender: tObject);
Begin
  LabelBlink.Caption := Format(rsBlinkDelay, [#13, IntToStr(
    TrackBar_Blink.Position)]);
End;

Procedure tSettings.Change_Sparks(Sender: tObject);
Begin
  LabelSparks.Caption := Format(rsSparks, [#13, IntToStr(
    TrackBar_Sparks.Position)]);
End;

Procedure tSettings.Click_Color(Sender: tObject);
Begin
  If (Not ColorDialog.Execute) Then
    Exit;
  tPanel(Sender).Color := ColorDialog.Color;
  UpdateColors;
End;

Procedure tSettings.Click_Beep(Sender: tObject);
Begin
{}
End;

Procedure tSettings.Click_Limit(Sender: tObject);
Begin
{}
End;

Procedure tSettings.Click_Accel(Sender: tObject);
Begin
{}
End;

Procedure tSettings.Click_Keys(Sender: tObject);
Begin
  Keys.Show;
End;

Procedure tSettings.Click_Info(Sender: tObject);
Begin
  Info.Show;
End;

Procedure tSettings.UpdateColors;
Var tmpPal: tMaxLogPalette;
Begin
  If (Game = Nil) Then
    Exit; {true when inifile is opened}
  With tmpPal Do
    Begin
      palVersion := $300;
      palNumEntries := 2;
      Cardinal(palPalEntry[0]) := Panel_Color1.Color;
      Cardinal(palPalEntry[1]) := Panel_Color2.Color;
    End;
  Game.Screen.Palette := CreatePalette(pLogPalette(@tmpPal)^);
End;

var i:integer;

initialization
if FileExists(ExtractFilePath(ParamStr(0)) + SSettingFile) then
  FsettingsDir := ExtractFilePath(ParamStr(0))
{$IFDEF MSWINDOWS}
else if FileExists(GetEnvironmentVariable('APPDATA') + DirectorySeparator +
  ChangeFileExt(ExtractFilename(ParamStr(0)), '') + DirectorySeparator + SSettingFile) then
  FsettingsDir := GetEnvironmentVariable('APPDATA') + DirectorySeparator +
    ChangeFileExt(ExtractFilename(ParamStr(0)), '') + DirectorySeparator
else
begin
  FsettingsDir := GetEnvironmentVariable('APPDATA') + DirectorySeparator +
    ChangeFileExt(ExtractFilename(ParamStr(0)), '') + DirectorySeparator;
  if not DirectoryExists(FSettingsDir) then
    CreateDir(FSettingsDir);
end;
{$ELSE}
else if FileExists(GetEnvironmentVariable('HOME')+ DirectorySeparator +'.'+
  ChangeFileExt(ExtractFilename(ParamStr(0)), '') + DirectorySeparator + SSettingFile) then
  FsettingsDir := GetEnvironmentVariable('HOME')+ DirectorySeparator +'.'+
    ChangeFileExt(ExtractFilename(ParamStr(0)), '') + DirectorySeparator
else
begin
  FsettingsDir := GetEnvironmentVariable('HOME')+ DirectorySeparator +'.'+
    ChangeFileExt(ExtractFilename(ParamStr(0)), '') + DirectorySeparator;
  if not DirectoryExists(FSettingsDir) then
    CreateDir(FSettingsDir);
end;
{$ENDIF}
FDataDir := SBaseDir;
for i := 0 to 2 do
  if DirectoryExists(FDataDir) then
    break
  else
    FDataDir := '..' + DirectorySeparator + FDataDir;
End.
