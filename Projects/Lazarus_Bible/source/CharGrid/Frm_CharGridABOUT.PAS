unit Frm_CharGridABOUT;

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
  Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type

  { TfrmAboutForm }

  TfrmAboutForm = class(TForm)
    btnOK: TBitBtn;
    pnlClient: TPanel;
    imgProgramIcon: TImage;
    lblProductName: TLabel;
    lblVersion: TLabel;
    lblCopyright: TLabel;
    procedure lblCopyrightClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAboutForm: TfrmAboutForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

{ TfrmAboutForm }

procedure TfrmAboutForm.lblCopyrightClick(Sender: TObject);
begin

end;

procedure TfrmAboutForm.OKButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAboutForm.lblCopyrightClick(Sender: TObject);
begin

end;

end.
 
