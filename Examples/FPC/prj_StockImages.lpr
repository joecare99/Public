program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  { you can add units after this }, Frm_StockImageTest;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrm_StockImageTestMain, Frm_StockImageTestMain);
  Application.Run;
end.

