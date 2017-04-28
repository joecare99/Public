unit frmfv2maintest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, cls_fv2Forms, cls_fv2Controls, cls_Fv2StdCtrls,
  cls_fv2Dialogs;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    Label1: TLabel;
    Memo1: TMemo;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

end.

