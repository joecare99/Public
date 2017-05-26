unit Frm_BaumDrMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls, Spin, XPMan,unt_baum,graph;

type
  TForm4 = class(TForm)
    XPManifest1: TXPManifest;
    Label3: TLabel;
    Label4: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    Panel1: TPanel;
    ProgressBar1: TProgressBar;
    ScrollBar1: TScrollBar;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.BitBtn1Click(Sender: TObject);
begin
  close;
end;

procedure TForm4.BitBtn2Click(Sender: TObject);
var grk,grm:integer;
begin
  InitGraph(grk,grm,bgipath);
  GraphForm.df:=3;
//  gform.Timer1.Enabled := false;
  DoBaumDraw(0,SpinEdit1.Value,SpinEdit2.Value/100,ScrollBar1.Position)

end;

end.
