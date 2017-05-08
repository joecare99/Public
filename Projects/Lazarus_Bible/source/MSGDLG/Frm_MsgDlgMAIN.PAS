unit Frm_MsgDlgMAIN;

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
  Forms, Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TMainForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Panel1: TPanel;
    Bevel1: TBevel;
    Panel2: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
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

procedure TMainForm.Button1Click(Sender: TObject);
begin
  ShowMessage('Procedure: ShowMessage');
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  ShowMessagePos('Procedure: ShowMessagePos', 10, 20);
end;

procedure TMainForm.Button3Click(Sender: TObject);
var
  TheText, TheCaption: String;
begin
  TheText := 'Function: MessageBox';
  TheCaption := 'MessageBox Demonstration';
  if Application.MessageBox(PChar(TheText), PChar(TheCaption),
    MB_DEFBUTTON1 + MB_ICONEXCLAMATION + MB_OKCANCEL) = IDOK
    then ShowMessage('You selected OK')
    else ShowMessage('You selected Cancel');
end;

procedure TMainForm.Button4Click(Sender: TObject);
var
  W: Word;
  S: String;
begin
  W := MessageDlg('Function: MessageDlg',
    mtInformation, [mbYes, mbNo, mbIgnore], 0);
  case W of
    mrYes:    S := 'Yes';
    mrNo:     S := 'No';
    mrIgnore: S := 'Ignore';
  end;
  ShowMessage('You selected ' + S);
end;

procedure TMainForm.Button5Click(Sender: TObject);
var
  W: Word;
  S: String;
  X, Y: Integer;
begin
  X := 50; Y := 75;
  W := MessageDlgPos('Function: MessageDlgPos',
    mtWarning, mbAbortRetryIgnore, 0, X, Y);
  case W of
    mrAbort:  S := 'Abort';
    mrRetry:  S := 'Retry';
    mrIgnore: S := 'Ignore';
  end;
  ShowMessage('You selected ' + S);
end;

end.
