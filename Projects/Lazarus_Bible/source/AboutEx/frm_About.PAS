unit Frm_ABOUT;

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

  { TAboutForm }

  { TfrmAbout }

  TfrmAbout = class(TForm)
    pnlAboutText: TPanel;
    btnOK: TBitBtn;
    imgProgramIcon: TImage;
    lblProductName: TLabel;
    lblVersion: TLabel;
    lblCopyright: TLabel;
    lblComments: TLabel;
    procedure btnOKClick(Sender: TObject);
     private
    { Private declarations }
     public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$IFnDEF FPC}
{$R *.dfm}
 {$ELSE}
{$R *.lfm}
{$ENDIF}

{ TAboutForm }

{ TfrmAbout }

procedure TfrmAbout.btnOKClick(Sender: TObject);
begin
  Close;
end;

end.
