unit tst_AHW52_FokoAbbreviationViewerTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52FokoAbbreviationViewer = class(TTestCase)
  published
    procedure TestFormShowLoadsLinesFromApplicationDirectory;
    procedure TestUnboundCounterIncrement;
    procedure TestUnboundCounterDecrement;
  end;

implementation

uses
  Classes, Forms, StdCtrls, SysUtils, Unit38;

procedure TTestAHW52FokoAbbreviationViewer.
  TestFormShowLoadsLinesFromApplicationDirectory;
var
  abbreviationForm: TForm38;
  fixtureLines: TStringList;
  fileName: string;
  fileCreated: Boolean;
begin
  Application.Initialize;
  fileName := ExtractFilePath(ParamStr(0)) + 'foko.abk';
  if FileExists(fileName) then
    raise Exception.CreateFmt('Refusing to overwrite existing test input "%s".',
      [fileName]);

  abbreviationForm := TForm38.CreateNew(nil);
  abbreviationForm.Memo1 := TMemo.Create(abbreviationForm);
  abbreviationForm.Memo1.Lines.Add('Stale text to be cleared');
  fixtureLines := TStringList.Create;
  fileCreated := False;
  try
    fixtureLines.Add('First synthetic abbreviation');
    fixtureLines.Add('Second synthetic abbreviation');
    fileCreated := True;
    fixtureLines.SaveToFile(fileName);

    abbreviationForm.FormShow(abbreviationForm);

    AssertEquals(2, abbreviationForm.Memo1.Lines.Count);
    AssertEquals('First synthetic abbreviation',
      abbreviationForm.Memo1.Lines[0]);
    AssertEquals('Second synthetic abbreviation',
      abbreviationForm.Memo1.Lines[1]);
  finally
    fixtureLines.Free;
    abbreviationForm.Free;
    if fileCreated and FileExists(fileName) and not DeleteFile(fileName) then
      raise Exception.CreateFmt('Unable to remove synthetic input "%s".',
        [fileName]);
  end;
end;

procedure TTestAHW52FokoAbbreviationViewer.TestUnboundCounterIncrement;
var
  abbreviationForm: TForm38;
begin
  abbreviationForm := TForm38.CreateNew(nil);
  try
    GlobalVar_0061DFA8 := 10;
    abbreviationForm._PROC_0053A185(abbreviationForm);
    AssertEquals('Increment callback should add one.', 11,
      GlobalVar_0061DFA8);
  finally
    GlobalVar_0061DFA8 := 0;
    abbreviationForm.Free;
  end;
end;

procedure TTestAHW52FokoAbbreviationViewer.TestUnboundCounterDecrement;
var
  abbreviationForm: TForm38;
begin
  abbreviationForm := TForm38.CreateNew(nil);
  try
    GlobalVar_0061DFA8 := 10;
    abbreviationForm._PROC_0053A1B4(abbreviationForm);
    AssertEquals('Decrement callback should subtract one.', 9,
      GlobalVar_0061DFA8);
  finally
    GlobalVar_0061DFA8 := 0;
    abbreviationForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52FokoAbbreviationViewer);

end.
