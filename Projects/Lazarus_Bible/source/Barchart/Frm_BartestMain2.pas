unit Frm_BartestMain2;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}
interface

uses
 Messages,
 SysUtils,
 Classes,
 Graphics,
 Controls,

  Forms,
 Dialogs,
 ExtCtrls,
 BarChart,
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf,
  LCLType,
  LMessages
{$ENDIF};

type

  { TfrmBarTestMain2 }

  TfrmBarTestMain2 = class(TForm)
    BarChart1: TBarChart;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public

  end;

var
  frmBarTestMain2: TfrmBarTestMain2;

implementation

{$IFDEF FPC}
{$R *.LFM}
{$ELSE}
{$R *.DFM}
{$ENDIF}

procedure TfrmBarTestMain2.FormCreate(Sender: TObject);

begin
  with BarChart1 do
  begin
    data.Clear;
    Data.Add(FloatToStr(65.0));
    Data.Add(FloatToStr(45.0));
    Data.Add(FloatToStr(95.0));
    Data.Add(FloatToStr(76.0));
    Data.Add(FloatToStr(51.0));
    Data.Add(FloatToStr(90.0));
  end;
end;

end.
