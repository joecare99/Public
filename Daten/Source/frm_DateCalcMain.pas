unit frm_DateCalcMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, RTTICtrls, Forms, Controls,
  Graphics, Dialogs, Spin, EditBtn, Buttons;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnFloat2DateTime: TBitBtn;
    btnDateTime2Float: TBitBtn;
    CalcEdit1: TCalcEdit;
    DateTimePicker1: TDateTimePicker;
    FloatSpinEdit1: TFloatSpinEdit;
    procedure btnFloat2DateTimeClick(Sender: TObject);
    procedure btnDateTime2FloatClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btnFloat2DateTimeClick(Sender: TObject);
begin
  DateTimePicker1.DateTime:=FloatSpinEdit1.Value;
end;

procedure TForm1.btnDateTime2FloatClick(Sender: TObject);
begin
  FloatSpinEdit1.Value:=DateTimePicker1.DateTime ;
end;

end.

