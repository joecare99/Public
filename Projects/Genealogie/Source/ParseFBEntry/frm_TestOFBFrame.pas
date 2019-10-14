unit frm_TestOFBFrame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, ActnList, StdActns, fra_OFBView;

type

  { TFrmTestOFBViewMain }

  TFrmTestOFBViewMain = class(TForm)
    actDoSomething: TAction;
    actFileLoad: TAction;
    actFileOpen: TFileOpen;
    actFileSave: TAction;
    actFileSaveAs: TFileSaveAs;
    alsXMLFile: TActionList;
    btnOpen: TBitBtn;
    btnLoad: TBitBtn;
    btnSave: TBitBtn;
    btnClose: TBitBtn;
    edtFilename: TComboBox;
    ilsOdfFile: TImageList;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    pnlBottom: TPanel;
    fraOFBView:TFraOFBView;
    SaveDialog1: TSaveDialog;
    procedure actFileOpenAccept(Sender: TObject);
    procedure actFileOpenBeforeExecute(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  FrmTestOFBViewMain: TFrmTestOFBViewMain;

implementation

{$R *.lfm}

{ TFrmTestOFBViewMain }

procedure TFrmTestOFBViewMain.FormCreate(Sender: TObject);
begin
  fraOFBView:=TFraOFBView.Create(self);
  fraOFBView.Parent := self;
  fraOFBView.Align:=alClient;
end;

procedure TFrmTestOFBViewMain.actFileOpenAccept(Sender: TObject);
begin
  edtFilename.Text:= actFileOpen.Dialog.FileName;
  fraOFBView.LoadFile(edtFilename.Text);
end;

procedure TFrmTestOFBViewMain.actFileOpenBeforeExecute(Sender: TObject);
begin

end;

procedure TFrmTestOFBViewMain.BitBtn1Click(Sender: TObject);
begin
   fraOFBView.Previous(sender);
end;

procedure TFrmTestOFBViewMain.BitBtn2Click(Sender: TObject);
begin
   fraOFBView.First(sender);
end;

procedure TFrmTestOFBViewMain.BitBtn3Click(Sender: TObject);
begin
   fraOFBView.next(sender);
end;

procedure TFrmTestOFBViewMain.BitBtn4Click(Sender: TObject);
begin
   fraOFBView.Last(sender);
end;

end.

