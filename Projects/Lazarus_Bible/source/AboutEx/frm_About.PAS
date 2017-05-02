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

  TfrmAbout = class(TForm)
    pnlAboutText: TPanel;
    btnOK: TBitBtn;
    imgProgramIcon: TImage;
    lblProductName: TLabel;
    lblVersion: TLabel;
    lblCopyright: TLabel;
    lblComments: TLabel;
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

end.
