Unit uHighscores;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

Interface
Uses {$IFDEF FPC} LCLIntf, LCLType, FileUtil,  {$ENDIF}SysUtils, Classes, Dialogs, Forms, ComCtrls, Controls, ExtCtrls,
  StdCtrls;

Type tHighscores = Class(tForm)
    PanelList: tPanel;
    ListView: tListView;
    Procedure Form_Create(Sender: tObject);
    Procedure Form_Destroy(Sender: tObject);
    Procedure Form_KeyPress(Sender: tObject; Var Key: Char);
  private
    procedure ShuffleTab;
    procedure SwapEncTable(k: Integer; j: Integer);
  public
    HscPath: String;
    HscFile: tFileStream;
    EncryptTable,
      DecryptTable: Array[Byte] Of Byte;
    Procedure AddName;
    Procedure Encrypt(Var Data; Size: Integer);
    Procedure Decrypt(Var Data; Size: Integer);
    Function ReadString: String;
    Function ReadInteger: Integer;
    Procedure WriteString(Text: String);
    Procedure WriteInteger(Value: Integer);
    Procedure PrepareTable;
  End;

Var Highscores: tHighscores;

Implementation
Uses {$IFNDEF FPC} Windows,{$ENDIF} uGame, uSettings, uDlg_EnterName;

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

resourcestring
  rsCouldNotRepl = 'Could not replace highscores. Check if %s is write-'
    +'protected.';

Procedure tHighscores.Form_Create(Sender: tObject);
Var Counter, i: Integer;
Begin
  HscPath := GetSettingsDir + CHighScoreFile;
  If FileExists(HscPath) Then
    Begin
      HscFile := tFileStream.Create(HscPath, fmOpenRead Or fmShareDenyWrite);
      With HscFile Do
        Begin
          Read(DecryptTable, 256);
          Counter := ReadInteger;
          For i := 1 To Counter Do
            With ListView.Items.Add Do
              Begin
                Caption := ReadString;
                SubItems.Add(ReadString);
                SubItems.Add(ReadString);
              End;
        End;
      HscFile.Free;
    End;
End;

Procedure tHighscores.Form_Destroy(Sender: tObject);
Var Counter, i: Integer;
Begin
  If FileExists(HscPath)  And (Not SysUtils.DeleteFile(HscPath)) Then
    Begin
      MessageDlg(Format(rsCouldNotRepl, [CHighScoreFile]), mtError, [mbIgnore],
        0);
    End
  Else If (ListView.Items.Count <> 0) Then
    Begin
      HscFile := tFileStream.Create(HscPath, fmCreate Or fmShareExclusive);
      With HscFile Do
        Begin
          PrepareTable;
          Write(DecryptTable, 256);
          Counter := ListView.Items.Count;
          WriteInteger(Counter);
          For i := 0 To (Counter - 1) Do
            With ListView.Items[i] Do
              Begin
                WriteString(Caption);
                WriteString(SubItems[0]);
                WriteString(SubItems[1]);
              End;
        End;
      HscFile.Free;
    End;
End;

Procedure tHighscores.Form_KeyPress(Sender: tObject; Var Key: Char);
Begin
  If (Byte(Key) = VK_Escape) Then
    Close;
End;

Procedure tHighscores.AddName;
Var i, InsertPos: Integer;
Begin
  With ListView Do
    Begin
      InsertPos := Items.Count;
      For i := (Items.Count - 1) Downto 0 Do
        If (Game.Player.Score > StrToInt(Items[i].SubItems[0])) Then
          InsertPos := i;
      With Items.Insert(InsertPos) Do
        Begin
          Caption := Dlg_EnterName.EditName.Text;
          SubItems.Add(IntToStr(Game.Player.Score));
          SubItems.Add(IntToStr(Game.Player.Levels));
          Selected := True;
          Focused := True;
        End;
    End;
End;

Procedure tHighScores.Encrypt(Var Data; Size: Integer);
Var i: Integer;
Begin
  For i := 0 To (Size - 1) Do
    tByteArray(Data)[i] := EncryptTable[tByteArray(Data)[i]];
End;

Procedure tHighScores.Decrypt(Var Data; Size: Integer);
Var i: Integer;
Begin
  For i := 0 To (Size - 1) Do
    tByteArray(Data)[i] := DecryptTable[tByteArray(Data)[i]];
End;

Function tHighScores.ReadString: String;
Var Counter: Byte;
  tmpStr: ShortString;
Begin
  Counter:=0;
  With HscFile Do
    Begin
      Read(Counter, 1);
      Decrypt(Counter, 1);
      SetLength(tmpStr, Counter);
      Read(tmpStr[1], Counter);
      Decrypt(tmpStr[1], Counter);
    End;
  Result := tmpStr;
End;

Function tHighScores.ReadInteger: Integer;
Var tmp: Integer;
Begin
  With HscFile Do
    Begin
      Read(tmp, 4);
      Decrypt(tmp, 4);
    End;
  Result := tmp;
End;

Procedure tHighScores.WriteString(Text: String);
Var Counter: Byte;
  tmpStr: ShortString;
Begin
  With HscFile Do
    Begin
      tmpStr := Copy(Text, 1, 255);
      Counter := Length(tmpStr);
      Encrypt(Counter, 1);
      Write(Counter, 1);
      Encrypt(tmpStr[1], Length(tmpStr));
      Write(tmpStr[1], Length(tmpStr));
    End;
End;


Procedure tHighScores.PrepareTable;
Var i: Integer;

Begin
  RandSeed:=21011971;
  For i := 0 To 255 Do
    Begin
      EncryptTable[i] := i;
      DecryptTable[i] := i;
    end;
  ShuffleTab;
End;

procedure tHighscores.SwapEncTable(k: Integer; j: Integer);
var
  O: Integer;
begin
  O := EncryptTable[K];
  EncryptTable[K] := EncryptTable[J];
  EncryptTable[J] := O;
end;

procedure tHighscores.ShuffleTab;
var
  k: Integer;
  j: Integer;
  i: Integer;
begin
  for i := 0 to 1024 do
  begin
    j := Random(256);
    K := Random(256);
    if j <> k then
    begin
      SwapEncTable(k, j);
      DecryptTable[EncryptTable[K]] := K;
      DecryptTable[EncryptTable[J]] := J;
    end;
  end;
end;

Procedure tHighScores.WriteInteger(Value: Integer);
Begin
  With HscFile Do
    Begin
      Encrypt(Value, 4);
      Write(Value, 4);
    End;
End;


End.

