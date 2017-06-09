unit fra_MouseWheelTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, ExtCtrls, Types;

type

  { TFrame1 }

  TFrame1 = class(TFrame)
    Memo1: TMemo;
    Panel1: TPanel;
    procedure FrameMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Panel1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;

implementation

{$R *.lfm}

{ TFrame1 }

procedure TFrame1.FrameMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  memo1.Lines.add('FrameMouseWheel (%d,%d) %d',[MousePos.x,MousePos.y,WheelDelta]);
  Handled:=true;
end;

procedure TFrame1.Panel1MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  memo1.Lines.add('PanelMouseWheel (%d,%d) %d',[MousePos.x,MousePos.y,WheelDelta]);
  Handled:=true;
end;

end.

