unit frm_MemInfoMain;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  {$IFNDEF FPC}
  Windows, TeEngine, Series,TeeProcs, Chart,
  {$ELSE}
    LCLIntf, LCLType, TAGraph, TASeries,
  {$ENDIF}  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,
  Buttons;

type

  { TMainForm }

  TMainForm = class(TForm)
    Button1: TButton;
    BitBtn1: TBitBtn;
    Chart1: TChart;
    Series1: TBarSeries;
    Series2: TBarSeries;
    Series3: TBarSeries;
    Series4: TBarSeries;
    Series5: TBarSeries;
    Series6: TBarSeries;
    Series7: TBarSeries;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation
{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
  uses TAChartUtils;
{$ENDIF}



var
  HeapStatus: THeapStatus;

procedure TMainForm.Button1Click(Sender: TObject);
var Color :TColor;
begin
  HeapStatus := System.GetHeapStatus;
  with HeapStatus do
  begin
    Color := {$IFDEF FPC} clTAColor {$ELSE} clTeeColor {$ENDIF};
//    Add(TotalAddrSpace, 'Total address space', Color);
//    Add(TotalUncommitted, 'Total Uncommitted', Color);
    Series1.Add(TotalCommitted, 'Total Committed', Color);
    Series2.Add(TotalAllocated, 'Total Allocated', Color);
    Series3.Add(TotalFree, 'Total Free', Color);
    Series4.Add(FreeSmall, 'Free Small', Color);
    Series5.Add(FreeBig, 'Free Big', Color);
    Series6.Add(Unused, 'Unused', Color);
    Series7.Add(Overhead, 'Overhead', Color);
  end;
end;

end.
