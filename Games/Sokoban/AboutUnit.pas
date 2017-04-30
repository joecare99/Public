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
    Panel1: TPanel;
    Comments: TLabel;
    OKButton: TButton;
    Image1: TImage;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ActSkinLab: TLabel;
    ActLevLab: TLabel;
    Label4: TLabel;
    Label5: TLabel;
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
