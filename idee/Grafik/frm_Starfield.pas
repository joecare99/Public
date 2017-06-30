unit frm_Starfield;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  unt_starfield2,
  unt_starfield,
  StdCtrls,
  unt_marmor3, XPMan;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;
    XPManifest1: TXPManifest;
    procedure FormShow(Sender: TObject);
    procedure ScrollBar2Change(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

uses Unt_3dPoint;
{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  unt_starfield2.execute
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 unt_starfield.execute;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  unt_marmor3.Execute ;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  ScrollBar1.Position :=round(unt_3dpoint.ausl*100)-50;
  ScrollBar2.Position :=round((unt_3dpoint.ausl-0.2)*120);
end;

procedure TForm1.ScrollBar1Change(Sender: TObject);
begin
  unt_3dpoint.ausl:=0.5+ScrollBar1.Position /100;
end;

procedure TForm1.ScrollBar2Change(Sender: TObject);
begin
  unt_3dpoint.zoom:=0.2+ScrollBar2.Position /120;
end;

end.
