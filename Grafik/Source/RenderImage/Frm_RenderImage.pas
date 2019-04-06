unit Frm_RenderImage;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  Buttons;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    PaintBox1: TPaintBox;
    pnlTop: TPanel;
    pnlBottom: TPanel;
    Panel3: TPanel;
    TreeView1: TTreeView;
    procedure BitBtn1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.BitBtn1Click(Sender: TObject);
begin

end;

end.

