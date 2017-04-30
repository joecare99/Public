unit SkinInfoUnit;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  StdCtrls, Forms, Controls, Classes;

type
  TfrmSkinInfo = class(TForm)
    Label1: TLabel;
    SkinName: TLabel;
    Label3: TLabel;
    SkinAuthor: TLabel;
    Label5: TLabel;
    SkinCopyright: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    SkinWebsite: TLabel;
    SkinMail: TLabel;
    Button1: TButton;
    Label2: TLabel;
    DescMem: TMemo;
  end;

var
  frmSkinInfo: TfrmSkinInfo;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

end.
