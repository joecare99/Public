unit frm_testEzyTrPanelMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    CheckBox1: TCheckBox;
    Image1: TImage;
    Image2: TImage;
    Panel1: TPanel;
    ToggleBox1: TToggleBox;
    procedure CheckBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image2Click(Sender: TObject);
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

procedure TForm1.Image2Click(Sender: TObject);
begin

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Panel1.ControlStyle := Panel1.ControlStyle - [csOpaque] + [csParentBackground];
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin
  panel1.Visible:=CheckBox1.checked;
end;

end.

