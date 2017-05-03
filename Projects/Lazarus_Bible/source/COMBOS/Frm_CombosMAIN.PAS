unit Frm_CombosMAIN;

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
  Forms, Dialogs, StdCtrls, Buttons;

type
  TMainForm = class(TForm)
    SimpleCB: TComboBox;
    DropDownCB: TComboBox;
    DropDownListCB: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    CancelBitBtn: TBitBtn;
    OKBitBtn: TBitBtn;
    CloseBitBtn: TBitBtn;
    procedure CancelBitBtnClick(Sender: TObject);
    procedure OKBitBtnClick(Sender: TObject);
    procedure CloseBitBtnClick(Sender: TObject);
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

procedure TMainForm.CancelBitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.OKBitBtnClick(Sender: TObject);
var
  S1, S2, S3: string;
begin
  S1 := SimpleCB.Text;
  S2 := DropDownCB.Text;
  S3 := DropDownListCB.Text;
  ShowMessage('Your selections are: ' +
    S1 + ', ' + S2 + ', ' + S3);
end;

procedure TMainForm.CloseBitBtnClick(Sender: TObject);
begin
  OKBitBtn.Click;  { Simulate OK button click }
  Close;           { End program }
end;

end.

