{
  Compile resource file from DOS before running this program:
    brc32 -r errmsg.rc
}

unit Frm_StrresMAIN;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TMainForm = class(TForm)
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
  MainForm: TMainForm;

implementation

{$R *.DFM}
{$R errmsg.res errmsg.rc}    { Load string table resource }

const
  maxErrorNumber = 6;

function TMainForm.ErrorCancel(ErrNum: Word): Boolean;
var
  ErrMsg: String;
  ErrStr: array[0 .. 63] of Char;
begin
  if LoadString(HInstance, ErrNum, ErrStr, 63) <= 0 then
    StrPCopy(ErrStr, 'Unknown problem');  { ErrStr := '...'; }
  ErrMsg := 'Error #:' + IntToStr(ErrNum) + ' ' + StrPas(ErrStr);
  ErrorCancel :=
    MessageDlg(ErrMsg, mtError, [mbRetry, mbCancel], 0) = mrCancel
end;

procedure TMainForm.BitBtn1Click(Sender: TObject);
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
