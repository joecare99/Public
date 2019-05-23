program Prj_TstHTMLParser;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_TstHTMLParser in '..\source\TstHTMLParser\Frm_TstHTMLParser.pas' {Form2},
  Cmp_Parser in '..\source\html2csv\Cmp_Parser.pas';

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmTestHtmlParsingMain, frmTestHtmlParsingMain);
  Application.Run;
end.
