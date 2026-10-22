{
  Compile resource file from DOS before running this program:
    brc32 -r errmsg.rc
}

unit Frm_StrresMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}
interface

uses

  SysUtils,
 Messages,
 Classes,
 Graphics,
 Controls,

  Forms,
 Dialogs,
 StdCtrls,
 Buttons,
 ExtCtrls,
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf,
  LCLType,
  LMessages
{$ENDIF};

type
  TfrmStrresMain = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Bevel1: TBevel;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    function ErrorCancel(ErrNum: Word): Boolean;
  public
    { Public declarations }
  end;

var
  frmStrresMain: TfrmStrresMain;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}
{$IFnDEF FPC}
{$R errmsg.res errmsg.rc}    { Load string table resource }
{$ENDIF}

{$IFDEF FPC}
const
  ErrMsgs: array[0..6] of string = (
    'No error. Trust me.',
    'You can''t be serious.',
    'Now you''ve done it.',
    'Your disk files are history.',
    'File not found. In fact, EVERYTHING is missing!',
    'Serious internal error. Don''t tell anyone.',
    'Feature unavailable. And you paid for this?');
{$ENDIF}

const
  maxErrorNumber = 6;

function TfrmStrresMain.ErrorCancel(ErrNum: Word): Boolean;
var
  ErrMsg: String;
  ErrStr: array[0 .. 63] of Char;
begin
{$IFnDEF FPC}
  if LoadString(HInstance, ErrNum, ErrStr, 63) <= 0 then
    StrPCopy(ErrStr, 'Unknown problem');  { ErrStr := '...'; }
  ErrMsg := 'Error #:' + IntToStr(ErrNum) + ' ' + StrPas(ErrStr);
{$ELSE}
  if ErrNum <= High(ErrMsgs) then
    ErrMsg := 'Error #:' + IntToStr(ErrNum) + ' ' + ErrMsgs[ErrNum]
  else
    ErrMsg := 'Error #:' + IntToStr(ErrNum) + ' Unknown problem';
{$ENDIF}
  ErrorCancel :=
    MessageDlg(ErrMsg, mtError, [mbRetry, mbCancel], 0) = mrCancel
end;

procedure TfrmStrresMain.BitBtn1Click(Sender: TObject);
var
  ErrNum: Integer;
  Canceled: Boolean;
begin
  Canceled := False;
  repeat
    ErrNum := 1 + Random(maxErrorNumber);  { Simulate error }
    if ErrNum <> 0 then
      Canceled := ErrorCancel(ErrNum);
  until Canceled;
end;

end.
