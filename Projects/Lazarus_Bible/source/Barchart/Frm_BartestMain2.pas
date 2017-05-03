unit Frm_BartestMain2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, BarChart;

type
  TMainForm = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    BarChart1: TBarChart;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  BarChart1 := TBarChart.Create(Self);
  BarChart1.Parent := Self;
  with BarChart1 do
  begin
    Left := 20;
    Top := 20;
    Width := 375;
    Height := 200;
    Data.Add(FloatToStr(65.0));
    Data.Add(FloatToStr(45.0));
    Data.Add(FloatToStr(95.0));
    Data.Add(FloatToStr(76.0));
    Data.Add(FloatToStr(51.0));
    Data.Add(FloatToStr(90.0));
  end;
end;

end.
