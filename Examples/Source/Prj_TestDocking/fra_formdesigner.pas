unit fra_FormDesigner;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls, StdCtrls, ComCtrls, Int_NeedsStatusbar,cla_DomFrame;

type

  { TFraFormDesigner }

  TFraFormDesigner = class(TDomFrame,iNeedsStatusbar)
    Label1: TLabel;
    Panel1: TPanel;
    ScrollBox1: TScrollBox;
    procedure FrameEnter(Sender: TObject);
    procedure FrameMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Panel1Click(Sender: TObject);
    procedure ScrollBox1Enter(Sender: TObject);
    procedure ScrollBox1Resize(Sender: TObject);
  private
    { private declarations }
    Finitialized :boolean;
    FStatusbar: TStatusBar;
    function GetStatusBar: TStatusbar;
    procedure SetStatusbar(AValue: TStatusBar);
  public
    { public declarations }
    constructor Create(AOwner: TComponent); override;
    property Statusbar:TStatusBar read FStatusbar write SetStatusbar;
  end;

implementation

{$R *.lfm}



{ TFraFormDesigner }

procedure TFraFormDesigner.ScrollBox1Resize(Sender: TObject);
begin
  if not Finitialized then
    begin
      Finitialized := True;
    end;
end;

function TFraFormDesigner.GetStatusBar: TStatusbar;
begin
  result := FStatusbar;
end;

procedure TFraFormDesigner.SetStatusbar(AValue: TStatusBar);
begin
  if FStatusbar=AValue then Exit;
  FStatusbar:=AValue;
end;

procedure TFraFormDesigner.FrameMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if assigned(FStatusbar) then
    FStatusbar.Panels[1].Text := format('(%d,%d) %s',[x,y,sender.ClassName]);
end;

procedure TFraFormDesigner.FrameEnter(Sender: TObject);
begin
  if assigned(FStatusbar) then
    begin
      FStatusbar.SimplePanel:=false;
    end;
end;

procedure TFraFormDesigner.Panel1Click(Sender: TObject);
begin

end;

procedure TFraFormDesigner.ScrollBox1Enter(Sender: TObject);
begin

end;

constructor TFraFormDesigner.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetDesigning(false,true);
end;

end.

