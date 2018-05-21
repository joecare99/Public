unit Frm_YesNo;

interface

uses
  Windows, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls;

type

  { TfrmYesNoDlg }

  TfrmYesNoDlg = class(TForm)
    btnYes: TBitBtn;
    btnCancel: TBitBtn;
    btnHelp: TBitBtn;
    bvlPromptFrame: TBevel;
    lblPrompt: TLabel;
    procedure btnClick(Sender: TObject);
//  private
    { Private declarations }
//  public
    { Public declarations }
  end;

var
  frmYesNoDlg: TfrmYesNoDlg;

implementation

{$ifdef FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

{ TfrmYesNoDlg }

procedure TfrmYesNoDlg.btnClick(Sender: TObject);
begin
  Close;
end;

end.
