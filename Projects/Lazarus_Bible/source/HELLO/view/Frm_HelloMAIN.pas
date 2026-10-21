unit Frm_HelloMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  ViewModelBase, PropertyChangedEventArgs, HelloViewModel;

type
  { TForm1 - die View des Hello-Demos.

    Die View enthaelt keine Logik: sie erzeugt das ViewModel, bindet sich an
    dessen Eigenschaften und leitet Klicks an die Kommandos weiter. }
  TForm1 = class(TForm)
    CloseButton: TButton;
    GreetingLabel: TLabel;
    ClickLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
  private
    FViewModel: THelloViewModel;
    procedure ViewModelPropertyChanged(Sender: TObject;
      const AArgs: TPropertyChangedEventArgs);
    procedure ApplyViewModel;
    procedure DoClose(Sender: TObject);
  public
    property ViewModel: THelloViewModel read FViewModel;
  end;

var
  Form1: TForm1;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TForm1.FormCreate(Sender: TObject);
begin
  FViewModel := THelloViewModel.Create;
  FViewModel.OnPropertyChanged := ViewModelPropertyChanged;
  { Das Kommando zum Beenden wird von der View ausgefuehrt. }
  FViewModel.CloseCommand.OnExecute := DoClose;
  ApplyViewModel;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FViewModel);
end;

procedure TForm1.ViewModelPropertyChanged(Sender: TObject;
  const AArgs: TPropertyChangedEventArgs);
begin
  ApplyViewModel;
end;

procedure TForm1.ApplyViewModel;
begin
  if FViewModel = nil then
    Exit;
  GreetingLabel.Caption := FViewModel.Greeting;
  ClickLabel.Caption := Format('Klicks: %d', [FViewModel.ClickCount]);
  CloseButton.Enabled := FViewModel.CloseCommand.CanExecute;
end;

procedure TForm1.DoClose(Sender: TObject);
begin
  Close;
end;

procedure TForm1.CloseButtonClick(Sender: TObject);
begin
  FViewModel.CloseCommand.Execute;
end;

end.
