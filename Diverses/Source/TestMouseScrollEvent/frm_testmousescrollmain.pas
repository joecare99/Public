unit frm_TestMouseScrollMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ButtonPanel,
  fra_MouseWheelTest, fra_MiddleFrame;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonPanel1: TButtonPanel;
    Frame2_1: TFrame2;
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

