unit CalculatorView;

{$mode objfpc}{$H+}

interface

uses
  Classes, Controls, Graphics, StdCtrls, CalculatorViewModel, DesktopWindow,
  DesktopWorkspace;

type
  TCalculatorView = class
  private
    FWorkspace: TDesktopWorkspace;
    FViewModel: TCalculatorViewModel;
    FOnOpened: TNotifyEvent;
    FDisplay: TLabel;
    procedure CalculatorButton(Sender: TObject);
    procedure ViewModelPropertyChanged(Sender: TObject;
      const APropertyName: string);
  public
    constructor Create(AWorkspace: TDesktopWorkspace;
      AViewModel: TCalculatorViewModel; AOnOpened: TNotifyEvent);
    procedure Open;
  end;

implementation

constructor TCalculatorView.Create(AWorkspace: TDesktopWorkspace;
  AViewModel: TCalculatorViewModel; AOnOpened: TNotifyEvent);
begin
  FWorkspace := AWorkspace;
  FViewModel := AViewModel;
  FOnOpened := AOnOpened;
  FViewModel.AddPropertyChanged(@ViewModelPropertyChanged);
end;

procedure TCalculatorView.Open;
const
  Captions: array[0..3, 0..3] of string = (
    ('7', '8', '9', '/'),
    ('4', '5', '6', '*'),
    ('1', '2', '3', '-'),
    ('0', '.', '=', '+'));
var
  Window: TDesktopWindow;
  Row, Col: Integer;
  Button: TButton;
begin
  Window := FWorkspace.CreateWindow('Calculator', 10, 10, 360, 470);
  FDisplay := TLabel.Create(Window.ClientArea);
  FDisplay.Name := 'CalculatorDisplay';
  FDisplay.Parent := Window.ClientArea;
  FDisplay.SetBounds(20, 16, 316, 56);
  FDisplay.Caption := FViewModel.Display;
  FDisplay.Alignment := taRightJustify;
  FDisplay.Font.Size := 24;
  FDisplay.Font.Style := [fsBold];
  FDisplay.Font.Color := RGBToColor(37, 59, 91);
  FDisplay.Color := clWhite;
  FDisplay.Transparent := False;
  for Row := 0 to 3 do
    for Col := 0 to 3 do begin
      Button := TButton.Create(Window.ClientArea);
      Button.Parent := Window.ClientArea;
      Button.SetBounds(20 + Col * 80, 90 + Row * 60, 72, 52);
      Button.Caption := Captions[Row, Col];
      Button.Font.Size := 16;
      Button.Font.Style := [fsBold];
      Button.Tag := Ord(Captions[Row, Col][1]);
      Button.OnClick := @CalculatorButton;
    end;
  Button := TButton.Create(Window.ClientArea);
  Button.Parent := Window.ClientArea;
  Button.SetBounds(20, 344, 316, 42);
  Button.Caption := 'Clear';
  Button.Font.Size := 15;
  Button.Font.Style := [fsBold];
  Button.Tag := Ord('C');
  Button.OnClick := @CalculatorButton;
  if Assigned(FOnOpened) then
    FOnOpened(Self);
end;

procedure TCalculatorView.CalculatorButton(Sender: TObject);
var
  Value: Char;
begin
  Value := Chr(TButton(Sender).Tag);
  FViewModel.InputCommand.Execute(Value);
end;

procedure TCalculatorView.ViewModelPropertyChanged(Sender: TObject;
  const APropertyName: string);
begin
  if (APropertyName = 'Display') and Assigned(FDisplay) then
    FDisplay.Caption := FViewModel.Display;
end;

end.
