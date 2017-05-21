unit frmMainFrametest;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Forms, StdCtrls, fraUdigitframe;

type

  { TfrmFrameNotificationExample }

  TfrmFrameNotificationExample = class(TForm)
    DigitFrame1: TDigitFrame;
    LStatus: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    procedure FrameDigitSelection(Sender: TObject);
  end;

var
  frmFrameNotificationExample: TfrmFrameNotificationExample;

implementation

{$R *.lfm}

{ TfrmFrameNotificationExample }

procedure TfrmFrameNotificationExample.FormCreate(Sender: TObject);
begin
  DigitFrame1.OnSelectionChange := @FrameDigitSelection;
  FrameDigitSelection(nil);
end;

procedure TfrmFrameNotificationExample.FrameDigitSelection(Sender: TObject);
begin
  if (DigitFrame1.Digit = -1) then
    LStatus.Caption := '(no digit yet selected)'
  else
    LStatus.Caption := Format('The latest digit selected in DigitFrame1 is %d',
      [DigitFrame1.Digit]);
end;

end.
