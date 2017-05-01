unit AboutUnit;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Jpeg, Windows, ShellApi,
{$ELSE}
 LCLIntf,
{$ENDIF}
  Graphics, Forms, Controls, StdCtrls, Buttons, ExtCtrls, Classes  ;

type
  TAboutBox = class(TForm)
    pnlClient: TPanel;
    lblComments: TLabel;
    OKButton: TButton;
    imgGameGlyph: TImage;
    pnlImage: TPanel;
    lblThisGameIs: TLabel;
    lblSpecialThanks: TLabel;
    lblAuthor: TLabel;
    ActSkinLab: TLabel;
    ActLevLab: TLabel;
    lblLicence: TLabel;
    lblPoint: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    procedure Label6Click(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  end;

var
  AboutBox: TAboutBox;

implementation

uses sysutils;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TAboutBox.Label6Click(Sender: TObject);
var
  HTML_File: string;

{$IFDEF FPC}
const  SW_SHOW = 1;
{$ENDIF}

begin
  HTML_File := 'http://home.versatel.nl/benruyl/sokoban.html';
  {$IFDEF FPC}
  OpenURL(HTML_File);
  {$ELSE}
  shellexecute(Handle, 'open', PChar(HTML_File),
   nil, nil, SW_SHOW);
  {$ENDIF}
end;

procedure TAboutBox.OKButtonClick(Sender: TObject);
begin
  Close;
end;

end.
