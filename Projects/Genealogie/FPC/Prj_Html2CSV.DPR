program Prj_Html2CSV;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  frm_html2csvMAIN in '..\source\Html2csv\frm_html2csvMAIN.pas' {SDIAppForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TSDIAppForm, SDIAppForm);
  Application.Run;
end.
 
