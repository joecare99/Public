unit Frm_Toolbar1MAIN;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls;

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

{$R *.DFM}

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

