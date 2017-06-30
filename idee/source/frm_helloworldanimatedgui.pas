unit Frm_HelloWorldAnimatedGUI;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TFrmHelloWorldAnim }

  TFrmHelloWorldAnim = class(TForm)
    lblTextAnimate: TLabel;
    tmrAnimate: TTimer;
    procedure lblTextAnimateClick(Sender: TObject);
    procedure tmrAnimateTimer(Sender: TObject);
  private
    { private declarations }
    FDirection: boolean;
  public
    { public declarations }
  end;

var
  FrmHelloWorldAnim: TFrmHelloWorldAnim;

implementation

{$R *.lfm}

{ TFrmHelloWorldAnim }

procedure TFrmHelloWorldAnim.lblTextAnimateClick(Sender: TObject);
begin
  FDirection:=not FDirection;
end;

procedure TFrmHelloWorldAnim.tmrAnimateTimer(Sender: TObject);
begin
  if FDirection then
    lblTextAnimate.Caption:=
      copy(lblTextAnimate.Caption,length(lblTextAnimate.Caption),1)+
      copy(lblTextAnimate.Caption,1,length(lblTextAnimate.Caption)-1)
  else
  lblTextAnimate.Caption:=
    copy(lblTextAnimate.Caption,2,length(lblTextAnimate.Caption)-1)+
    copy(lblTextAnimate.Caption,1,1);
end;

end.

