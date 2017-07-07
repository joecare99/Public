unit frm_CalcObjectsMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  l, b: single;
begin
  if TryStrToFloat(Edit1.Caption, l) and TryStrToFloat(Edit2.Caption, b) then begin
    Label4.Caption := 'Fläch: ' + FloatToStr(l * b);
    Label5.Caption := 'Umfang: ' + FloatToStr(l * 2 + b * 2);
  end else begin
    Label4.Caption := 'error';
  end;
end;

end.
