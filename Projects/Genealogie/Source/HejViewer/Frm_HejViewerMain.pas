unit Frm_HejViewerMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, fra_AWHejView,cls_HejData, fra_IndIndex;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    ComboBox1: TComboBox;
    fraAWHejView1: TfraAWHejView;
    fraIndIndex1: TfraIndIndex;
    OpenDialog1: TOpenDialog;
    pnlBottom: TPanel;
    pnlTop: TPanel;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure fraAWHejView1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    FGenealogy :TClsHejGenealogy;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  FGenealogy := TClsHejGenealogy.Create;
  fraAWHejView1.Genealogy := FGenealogy;
  fraIndIndex1.Genealogy:= FGenealogy;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FGenealogy);
end;

procedure TForm1.fraAWHejView1Click(Sender: TObject);
begin

end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  OpenDialog1.FileName := ComboBox1.Text;
  if OpenDialog1.Execute then
    begin
      ComboBox1.Text := OpenDialog1.FileName;
      FGenealogy.LoadFromFile(ComboBox1.Text);
    end;
end;

end.

