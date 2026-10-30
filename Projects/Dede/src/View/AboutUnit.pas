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
    Image1: TImage;
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
    BuildLbl: TLabel;
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
  shellapi;

function Get_Lang_CPg:String;
//var lng_id:LangId; pg_id:UINT;
begin
  Result := '040904E4'; //Fixed during compilation!!!
end;

function GetFileVersionBuild: string;
var
  InfoSize, Dummy, ValueSize: DWORD;
  InfoBuffer, ValueBuffer: Pointer;
  FileName, Query: AnsiString;
  DotPosition: Integer;
begin
  Result := 'cant retreive';
  FileName := AnsiString(Application.ExeName);
  InfoSize := GetFileVersionInfoSizeA(PAnsiChar(FileName), Dummy);
  if InfoSize = 0 then
    Exit;

  GetMem(InfoBuffer, InfoSize);
  try
    if not GetFileVersionInfoA(PAnsiChar(FileName), 0, InfoSize, InfoBuffer) then
      Exit;

    Query := '\StringFileInfo\' + AnsiString(Get_Lang_CPg) + '\FileVersion';
    if not VerQueryValueA(InfoBuffer, PAnsiChar(Query), ValueBuffer, ValueSize) then
      Exit;

    Result := string(PAnsiChar(ValueBuffer));
    repeat
      DotPosition := Pos('.', Result);
      if DotPosition = 0 then
        Break;
      Delete(Result, 1, DotPosition);
    until False;
  finally
    FreeMem(InfoBuffer);
  end;
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
  BuildLbl.Caption := 'Build ' + GetFileVersionBuild;
end;

end.
