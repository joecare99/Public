unit Frm_KeyInfoMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, Buttons, StdCtrls, ExtCtrls;

type
  TMainForm = class(TForm)
    Label2: TLabel;
    CharLabel: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ValueLabel: TLabel;
    ShiftLabel: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Label1: TLabel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    Bevel7: TBevel;
    CloseButton: TBitBtn;
    procedure FormKeyDown({%H-}Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress({%H-}Sender: TObject; var Key: Char);
    procedure FormKeyUp({%H-}Sender: TObject; var {%H-}Key: Word;
      {%H-}Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

const
  ctrl_A = 1;     { ASCII value for Ctrl+A }
  ctrl_Z = 26;    { ASCII value for Ctrl+Z }

  FunctionKeys: array [vk_f1 .. vk_f12] of string[3] =
    ('F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8',
     'F9', 'F10', 'F11', 'F12');

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  s: string;
begin
{- Show integer Key value }
  ValueLabel.Caption := IntToStr(Key);
{- Show Key shift state }
  s := '';
  if ssShift  in Shift then s := s + 'Shift+';
  if ssAlt    in Shift then s := s + 'Alt+';
  if ssCtrl   in Shift then s := s + 'Ctrl+';
  if Length(s) > 0 then
    Delete(s, Length(s), 1); { Delete final '+' }
  ShiftLabel.Caption := s;
{- Do function key labels }
  if Key in [vk_f1 .. vk_f12] then
    CharLabel.Caption := FunctionKeys[Key]
  else
    CharLabel.Caption := '';  { Erase old character label }
{- Disable Spacebar to prevent selecting Close button }
  if Key = vk_space then
    Key := 0;
end;

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Ord(Key) in [ctrl_A .. ctrl_Z] then
    CharLabel.Caption := '^' + Chr(-1 + Ord(Key) + Ord('A') )
  else
    CharLabel.Caption := Key;
  ValueLabel.Caption := IntToStr(Ord(Key));
end;

procedure TMainForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
{- Erase the three labels when user releases key(s) }
  CharLabel.Caption := '';
  ValueLabel.Caption := '';
  ShiftLabel.Caption := '';
end;

end.

