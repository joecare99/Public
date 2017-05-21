unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Image1: TImage;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure Panel2Paint(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Panel2Paint(Sender: TObject);
var
  P: TPoint;
begin
  P := Point(Image1.Left - TControl(Sender).Left, Image1.Top - TControl(Sender).Top);
  TPanel(Sender).Canvas.Draw(P.X, P.Y, Image1.Picture.Bitmap);
end;


end.

