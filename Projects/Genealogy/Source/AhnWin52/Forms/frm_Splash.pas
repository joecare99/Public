unit frm_Splash;

interface

uses
  SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls,ExtCtrls;

type

  { TfrmSplash }

  TfrmSplash=class(TForm)
    lblProgname: TLabel;
    lblAuthor: TLabel;
    lblStreet: TLabel;
    lblPlace: TLabel;
    lblEMail: TLabel;
    imgIcon: TImage;
    lblCopyright: TLabel;
    tmrAutoclose: TTimer;
    imgImage: TImage;
    procedure Timer1OnTimer(Sender : TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end ;

var
  frmSplash: TfrmSplash;

implementation

{$IFDEF FPC}
{$R *.LFM}
{$ELSE}
{$R *.dfm}
{$ENDIF}

procedure TfrmSplash.Timer1OnTimer(Sender : TObject);
begin
  Close;
end;

end.
