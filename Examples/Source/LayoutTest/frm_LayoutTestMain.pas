unit frm_LayoutTestMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, ActnList;

type

  { TForm1 }

  TForm1 = class(TForm)
    actViewVertical: TAction;
    ActViewHorizontal: TAction;
    ActionList1: TActionList;
    pnlClient: TPanel;
    pnlDetail: TPanel;
    pnlBottom: TPanel;
    pnlTop: TPanel;
    btnViewHorizontal: TSpeedButton;
    btnViewVertical: TSpeedButton;
    Splitter1: TSplitter;
    procedure ActViewHorizontalExecute(Sender: TObject);
    procedure actViewVerticalExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure pnlDetailClick(Sender: TObject);
    procedure pnlTopClick(Sender: TObject);
    procedure btnViewHorizontalClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.actViewVerticalExecute(Sender: TObject);
begin
  if pnlDetail.align <> alBottom then
    begin
     pnlDetail.Align:=alBottom;
     Splitter1.Align:=alBottom;
    end;
  FormResize(Sender);
end;

procedure TForm1.ActViewHorizontalExecute(Sender: TObject);
begin
    if pnlDetail.align <> alRight then
      begin
     pnlDetail.Align:=alRight;
  Splitter1.Align:=alRight;
      end;
  FormResize(Sender);
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  if pnlDetail.Align = alRight then
    pnlDetail.Width:=(ClientWidth -Splitter1.Width) div 2
  else
  if pnlDetail.Align = alBottom then
    pnlDetail.Height:=(Clientheight -Splitter1.Height -pnlTop.height-pnlBottom.Height-10) div 2;
end;

procedure TForm1.pnlDetailClick(Sender: TObject);
begin

end;

procedure TForm1.pnlTopClick(Sender: TObject);
begin

end;

procedure TForm1.btnViewHorizontalClick(Sender: TObject);
begin

end;

end.

