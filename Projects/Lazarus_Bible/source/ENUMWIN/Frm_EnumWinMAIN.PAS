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

  { TfrmEnumWinMain }

  TfrmEnumWinMain = class(TForm)
    lblInfo: TLabel;
    lbxWindows: TListBox;
    lblWinTitles: TLabel;
    btnClose: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure lbxWindowsSelectionChange(Sender: TObject; User: boolean);
    procedure lbxWindowsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEnumWinMain: TfrmEnumWinMain;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

var lStr:TStringList;
{ Windows calls this function, passing in Handle a reference
  to each alive window. Param is not used in this example. }
function EnumWinProc(Handle: HWnd; {%H-}Param: lPAram): Boolean;
  Stdcall;  { Use this, not export, in Windows 95, 98 & NT }
var
  Sz: array[0 .. 132] of Char; {Holds result of GetWindowText}
begin
  Result := True;  { Always successful }
  { Call Windows to obtain each window's caption, and then
    add the returned string to the form's ListBox. }
  if (GetWindowText(Handle, Sz, Sizeof(Sz)) <> 0) and (LPARAM(param)=lparam(lstr)) then
    lStr.AddObject(StrPas(Sz),TObject(Handle));
end;

{ Enumerate all alive windows by passing to Windows the
  address of the preceding callback function. }
procedure TfrmEnumWinMain.FormCreate(Sender: TObject);
begin
  lStr:=TStringList.create;
  try
  lbxWindows.Clear;
  EnumWindows(@EnumWinProc, Lparam(lstr));  { 0 is an unused parameter }
  lbxWindows.Items.AddStrings(lStr);
  finally
    freeandnil(lStr);
  end;
end;

procedure TfrmEnumWinMain.lbxWindowsClick(Sender: TObject);
begin
  lblInfo.caption:= inttostr(Longint(lbxWindows.Items.Objects[lbxWindows.ItemIndex]));
end;

procedure TfrmEnumWinMain.lbxWindowsSelectionChange(Sender: TObject;
  User: boolean);
begin
  lblInfo.caption:= inttostr(Longint(lbxWindows.Items.Objects[lbxWindows.ItemIndex]));
end;

end.
