unit frm_MDIPretestMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ActnList, ExtCtrls, Buttons, StdCtrls, formpanel, titlebar, buttonsbar;

type

  { TForm1 }

  TForm1 = class(TForm)
    ActionList1: TActionList;
    BitBtn1: TBitBtn;
    FormPanel1: TFormPanel;
    FormPanel2: TFormPanel;
    LabeledEdit1: TLabeledEdit;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    Panel1: TPanel;
    ScrollBox1: TScrollBox;
    StatusBar1: TStatusBar;
    StatusBar2: TStatusBar;
    TabControl1: TTabControl;
    ToolBar1: TToolBar;
    procedure FormPanel1Click(Sender: TObject);
    procedure FormPanel2Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormPanel1Click(Sender: TObject);
begin
  FormPanel1.BringToFront;
end;

procedure TForm1.FormPanel2Click(Sender: TObject);
begin
  Formpanel2.BringToFront;
end;

end.

