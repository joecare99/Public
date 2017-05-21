program FrameNotifyingLabel;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, frmMainFrametest, fraUdigitframe
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
		Application.CreateForm(TfrmFrameNotificationExample, 
				frmFrameNotificationExample);
  Application.Run;
end.

