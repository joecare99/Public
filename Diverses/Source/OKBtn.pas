unit Okbtn;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TForm1 = class(TForm)
    btnOK: TBitBtn;
    Image1: TImage;
    Timer1: TTimer;
    btnUp: TButton;
    btnDown: TButton;
    procedure btnOKClick(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnOKClick(Sender: TObject);
begin
   close
end;

procedure TForm1.FormClick(Sender: TObject);
begin
   messagebox(0,'Hello','test',MB_Taskmodal)
end;

procedure TForm1.btnUpClick(Sender: TObject);
begin
  image1.canvas.Ellipse(random(image1.width),random(image1.height),random(image1.width),random(image1.height))
end;

end.
