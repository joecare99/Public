Unit uKeys;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

Interface
Uses Controls, Forms, Classes,
  {$IFDEF FPC}
   LCLIntf, LCLType,
  {$ELSE} ComCtrls,
  {$ENDIF}StdCtrls, ExtCtrls, SysUtils;

Type tKeys = Class(tForm)
    Label_KeyLeft: tLabel;
    Label_KeyRight: tLabel;
    Label_KeyAccel: tLabel;
    Label_KeyFire: tLabel;
    Panel_KeyLeft: tPanel;
    Panel_KeyRight: tPanel;
    Panel_KeyAccel: tPanel;
    Panel_KeyFire: tPanel;
    Edit_KeyLeft: tEdit;
    Edit_KeyRight: tEdit;
    Edit_KeyAccel: tEdit;
    Edit_KeyFire: tEdit;
    Procedure Form_Show(Sender: tObject);
    Procedure Edit_Change(Sender: tObject);
    Procedure Edit_KeyDown(Sender: tObject; Var Key: Word; Shift: tShiftState);
    Procedure Edit_KeyUp(Sender: tObject; Var Key: Word; Shift: tShiftState);
  private
  public
    LastKey: Word;
  End;

Var Keys: tKeys;

Implementation
Uses {$IFDEF MSWINDOWS} windows,  {$ELSE}  {$ENDIF} uSettings;

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

{Tools}

Function GetKeyName(Key: Cardinal): String;
Var tmpStr: ShortString;
Begin
  {$IFDEF MSWINDOWS}
  tmpStr[0] := #255;
  Key := MapVirtualKey(Key, 0) Shl 16;
  GetKeyNameText(Key, @tmpStr[1], 255);
  Result := Copy(tmpStr, 1, Pos(#0, tmpStr) - 1);
  {$ELSE}
  Result := '';
  {$ENDIF}
End;

{Key}

Procedure tKeys.Form_Show(Sender: tObject);
Begin
  With Settings Do
    Begin
      LastKey := KeyLeft;
      Edit_Change(Edit_KeyLeft); {put key values into edit boxes}
      LastKey := KeyRight;
      Edit_Change(Edit_KeyRight);
      LastKey := KeyAccel;
      Edit_Change(Edit_KeyAccel);
      LastKey := KeyFire;
      Edit_Change(Edit_KeyFire);
    End;
End;

Procedure tKeys.Edit_Change(Sender: tObject);
Var tmpStr: String;
Begin
  With tEdit(Sender) Do
    Begin {update value and select it}
      tmpStr := IntToStr(LastKey);
      While (Length(tmpStr) < 3) Do
        tmpStr := '0' + tmpStr;
      tmpStr := tmpStr + ' = ' + GetKeyName(LastKey);
      Text := tmpStr;
      SelStart := 0;
      SelLength := Length(Text);
    End;
  If (Sender = Edit_KeyLeft) Then
    Edit_KeyRight.SetFocus
  Else {select next value} If (Sender = Edit_KeyRight) Then
    Edit_KeyAccel.SetFocus
  Else If (Sender = Edit_KeyAccel) Then
    Edit_KeyFire.SetFocus
  Else If (Sender = Edit_KeyFire) Then
    Edit_KeyLeft.SetFocus;
  With Settings Do
    If (Sender = Edit_KeyLeft) Then
      KeyLeft := LastKey
    Else {update keys} If (Sender = Edit_KeyRight) Then
      KeyRight := LastKey
    Else If (Sender = Edit_KeyAccel) Then
      KeyAccel := LastKey
    Else If (Sender = Edit_KeyFire) Then
      KeyFire := LastKey;
End;

Procedure tKeys.Edit_KeyDown(Sender: tObject; Var Key: Word; Shift:
  tShiftState);
Begin
  If (Key = VK_Escape) Then
    Exit; {don't use ESC as key}
  LastKey := Key;
  Edit_Change(Sender);
End;

Procedure tKeys.Edit_KeyUp(Sender: tObject; Var Key: Word; Shift: tShiftState);
Begin
  If (Key = VK_Escape) Then
    Close;
End;

End.
