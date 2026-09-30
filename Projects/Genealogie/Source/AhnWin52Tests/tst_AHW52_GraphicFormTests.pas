unit tst_AHW52_GraphicFormTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, Forms;

type
  TTestAHW52GraphicForm = class(TTestCase)
  private
    FCloseEventCount: Integer;
    procedure RecordFormClose(Sender: TObject; var CloseAction: TCloseAction);
  published
    procedure TestFinishButtonClosesGraphicForm;
  end;

implementation

uses
  Classes, SysUtils, Unit13;

procedure TTestAHW52GraphicForm.RecordFormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  Inc(FCloseEventCount);
  CloseAction := caHide;
end;

procedure TTestAHW52GraphicForm.TestFinishButtonClosesGraphicForm;
var
  graphicForm: TForm13;
begin
  Application.Initialize;
  FCloseEventCount := 0;
  graphicForm := TForm13.CreateNew(nil);
  Unit13.Form13 := graphicForm;
  try
    graphicForm.OnClose := @RecordFormClose;
    graphicForm.SpeedButton2Click(graphicForm.SpeedButton2);

    if FCloseEventCount <> 1 then
      raise Exception.CreateFmt('Expected one close event, got %d.',
        [FCloseEventCount]);
  finally
    Unit13.Form13 := nil;
    graphicForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52GraphicForm);

end.
