unit tst_FVHistList;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, HistList;

type

  { TTestFVHistList }

  TTestFVHistList= class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
    Procedure GenerateTestData;
  published
    procedure TestSetUp;
    procedure TestInsert;
    procedure TestInsert2;
    procedure TestDelete;
  end;

implementation

procedure TTestFVHistList.TestSetUp;
begin
  CheckNotNull(TObject(HistList.HistoryBlock),'Historyblock is assigned');
  CheckEquals(0,HistList.HistoryCount(0),'No Entries');
  CheckEquals(65536,HistList.HistorySize,'HistorySize');
end;

procedure TTestFVHistList.TestInsert;
begin
  HistList.HistoryAdd(1,'Eins');
  CheckEquals(1,HistList.HistoryCount(1),'1 Entrie');
  CheckEquals(65536,HistList.HistorySize,'HistorySize');
  CheckEquals(8,HistList.HistoryUsed,'HistoryUsed1');
  HistList.HistoryAdd(1,'Zwei');
  CheckEquals(2,HistList.HistoryCount(1),'2 Entries');
  CheckEquals(65536,HistList.HistorySize,'HistorySize');
  CheckEquals(15,HistList.HistoryUsed,'HistoryUsed2');
  HistList.HistoryAdd(1,'Drei');
  CheckEquals(3,HistList.HistoryCount(1),'3 Entrie');
  CheckEquals(65536,HistList.HistorySize,'HistorySize');
  CheckEquals(22,HistList.HistoryUsed,'HistoryUsed3');
  HistList.HistoryAdd(1,'Vier');
  CheckEquals(4,HistList.HistoryCount(1),'4 Entries');
  CheckEquals(65536,HistList.HistorySize,'HistorySize');
  CheckEquals(29,HistList.HistoryUsed,'HistoryUsed4');
  checkEquals('Vier',HistoryStr(1,0),'Index 0');
  checkEquals('Drei',HistoryStr(1,1),'Index 1');
  checkEquals('Zwei',HistoryStr(1,2),'Index 2');
  checkEquals('Eins',HistoryStr(1,3),'Index 3');
  checkEquals('',HistoryStr(1,4),'Index 4');
end;

procedure TTestFVHistList.TestInsert2;
var
  i, j: Integer;
begin
  GenerateTestData;
  for i := 0 to 100 do
     for j := 0 to 28 do
        CheckEquals('List['+inttostr(j)+']: Entry['+inttostr(100-i)+']',HistoryStr(j,i));
end;

procedure TTestFVHistList.TestDelete;
begin
  //Todo :
end;

procedure TTestFVHistList.SetUp;
begin
  HistList.InitHistory;
end;

procedure TTestFVHistList.TearDown;
begin
  HistList.DoneHistory;
end;

procedure TTestFVHistList.GenerateTestData;
var
  i, j: Integer;
begin
  for i := 0 to 100 do
     for j := 0 to 28 do
        HistList.HistoryAdd(j,'List['+inttostr(j)+']: Entry['+inttostr(i)+']');
  CheckEquals(63168,HistList.HistoryUsed,'HistoryUsed1');
  HistList.HistoryAdd(30,'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, '+
  'sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, '+
  'sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet '+
  'clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. '+
  'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod '+
  'tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. '+
  'At vero eos et accusam et justo duo dolores et ea rebum. '+
  'Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. '+
  'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod '+
  'tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. '+
  'At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, '+
  'no sea takimata sanctus est Lorem ipsum dolor sit amet.'+LineEnding+LineEnding+
  'Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, '+
  'vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto '+
  'odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te '+
  'feugait nulla facilisi.');
  CheckEquals(63426,HistList.HistoryUsed,'HistoryUsed2');
end;

initialization

  RegisterTest(TTestFVHistList);
end.

