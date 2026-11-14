program Prj_TstHTMLParser2;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE} 
  Interfaces,
{$ENDIF}
  DefaultTranslator, SysUtils, Types,
  Forms,
  frm_tsthtmlparser2 in '..\source\TstHTMLParser\Frm_TstHTMLParser2.pas' {Form2},
  dm_RNZAnzeigen in '..\source\RNZAnzeigen\dm_RNZAnzeigen.pas' {dmRNZAnzeigen},
  Cmp_Parser in '..\source\html2csv\Cmp_Parser.pas',
  unt_CDate in 'c:\unt_cdate.pas';

{$R *.res}

function GetApplicationName: string;
begin
  Result := 'RNZ-Anzeigen';
end;

function GetVendorName: string;
begin
  Result := 'JC-Soft';
end;

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  OnGetApplicationName:=@GetApplicationName;
  OnGetVendorName:=@GetVendorName;
  Application.CreateForm(TdmRNZAnzeigen, dmRNZAnzeigen);
  Application.CreateForm(TfrmTstHtmlParser2Main, frmTstHtmlParser2Main);
  Application.Run;
end.
