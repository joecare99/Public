unit Frm_Toolbar1MAIN;

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
  TMainForm = class(TForm)
    Panel1: TPanel;
    PromptSB: TSpeedButton;
    ExitSB: TSpeedButton;
    CloseBitBtn: TBitBtn;
    Label1: TLabel;
    Bevel1: TBevel;
    procedure ExitSBClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
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
procedure TMainForm.ExitSBClick(Sender: TObject);
begin
  if not PromptSB.Down then
    Close
  else if MessageDlg('Exit program?',mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
    Close;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  ExitSB.Glyph := CloseBitBtn.Glyph;
end;

end.

