unit Frm_BartestMain;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
 {$IFnDEF FPC}
  Windows, Messages, chart, series,
{$ELSE}
  LCLIntf, LCLType, TAGraph, TASeries, TATools, TADataTools ,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons,  ExtCtrls, Menus, TeEngine, TeeProcs;

type

  { TfrmBarChartMain }

  TfrmBarChartMain = class(TForm)
    BitBtn1: TBitBtn;
    Chart1: TChart;
    {$IFDEF FPC}
    ChartToolset1: TChartToolset;
    ChartToolset1DataPointDistanceTool1: TDataPointDistanceTool;
    {$ENDIF}
    Series1: TBarSeries;
    Series2: TBarSeries;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBarChartMain: TfrmBarChartMain;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TfrmBarChartMain.FormCreate(Sender: TObject);
var i:integer;
begin
  for I := 0 to 10 do
    begin
     Series1.AddY(random*500);
     Series2.AddY(random*500-300);
    end;
end;

procedure TfrmBarChartMain.Timer1Timer(Sender: TObject);
var i:integer;
begin
  for I := 0 to 10 do
    begin
      {$IFNDEF FPC}
      Series1.YValues.Value[i]:=random*500;
      Series2.YValues.Value[i]:=random*500-300;
      {$ELSE}
      Series1.SetYValue(i,random*500);
      Series2.SetYValue(i,random*500-300);
      {$ENDIF}
    end;
  chart1.invalidate;
end;

end.
