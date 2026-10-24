unit AboutUnit;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}
    
interface

uses
{$IFnDEF FPC}
  jpeg,
{$ELSE}
{$ENDIF}
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    Version: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    OKButton: TButton;
    Label6: TLabel;
    lg: TImage;
    Label9: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label7: TLabel;
    Label8: TLabel;
    procedure CommentsClick(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

uses
  shellapi, DeDeConstants;

function Get_Lang_CPg:String;
//var lng_id:LangId; pg_id:UINT;
begin
  Result := '040904E4'; //Fixed during compilation!!!
end;

procedure TAboutBox.CommentsClick(Sender: TObject);
begin
  ShellExecute(HInstance, 'Open',PChar('mailto:DaFixer@hotmail.com?subject=DeDe'),nil,nil,SW_Normal);
end;

procedure TAboutBox.Label2Click(Sender: TObject);
begin
  ShellExecute(HInstance, 'Open',PChar('www.balbaro.com'),nil,nil,SW_Normal);
end;

procedure TAboutBox.FormActivate(Sender: TObject);
begin
  Version.Caption := 'V' + GlobsCurrDeDeVersion +
    ' Build' + GlobsCurrDeDeBuild;
end;

end.

