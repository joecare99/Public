unit fraUdigitframe;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, ExtCtrls;

type

  { TDigitFrame }

  TDigitFrame = class(TFrame)
    RGDigits: TRadioGroup;
    procedure RGDigitsSelectionChanged(Sender: TObject);
  strict private
    FOnSelectionChange: TNotifyEvent;
    function GetDigit: integer;
  public
    property Digit: integer read GetDigit;
    property OnSelectionChange: TNotifyEvent
      read FOnSelectionChange write FOnSelectionChange;
  end;

implementation

{$R *.lfm}

{ TDigitFrame }

procedure TDigitFrame.RGDigitsSelectionChanged(Sender: TObject);
begin
  if Assigned(FOnSelectionChange) then
    FOnSelectionChange(Self);
end;

function TDigitFrame.GetDigit: integer;
begin
  Result := RGDigits.ItemIndex;
end;

end.
