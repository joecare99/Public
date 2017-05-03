unit Frm_EnumWinMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}

{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  Windows, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons;

type
  TMainForm = class(TForm)
    ListBox1: TListBox;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    procedure FormCreate(Sender: TObject);
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

{ Windows calls this function, passing in Handle a reference
  to each alive window. Param is not used in this example. }
function EnumWinProc(Handle: HWnd; {%H-}Param: Longint): Boolean;
  Stdcall;  { Use this, not export, in Windows 95, 98 & NT }
var
  Sz: array[0 .. 132] of Char; {Holds result of GetWindowText}
begin
  Result := True;  { Always successful }
  { Call Windows to obtain each window's caption, and then
    add the returned string to the form's ListBox. }
  if GetWindowText(Handle, Sz, Sizeof(Sz)) <> 0 then
    MainForm.ListBox1.Items.Add(StrPas(Sz));
end;

{ Enumerate all alive windows by passing to Windows the
  address of the preceding callback function. }
procedure TMainForm.FormCreate(Sender: TObject);
begin
  EnumWindows(@EnumWinProc, 0);  { 0 is an unused parameter }
end;

end.
