unit AHW52PersonTextFrame;

{$mode objfpc}{$H+}

interface

uses
  Classes, Controls, Forms, StdCtrls, DBCtrls;

type
  TAHW52PersonTextFrame = class(TFrame)
  published
    Label21: TLabel;
    DBMemo1: TDBMemo;
    procedure DBMemo1Exit(Sender: TObject);
  private
    FOnSaveRequested: TNotifyEvent;
  public
    property OnSaveRequested: TNotifyEvent
      read FOnSaveRequested write FOnSaveRequested;
  end;

implementation

{$R *.lfm}

procedure TAHW52PersonTextFrame.DBMemo1Exit(Sender: TObject);
begin
  if Assigned(FOnSaveRequested) then
    FOnSaveRequested(Sender);
end;

end.
