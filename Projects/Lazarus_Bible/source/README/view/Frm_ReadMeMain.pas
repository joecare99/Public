unit Frm_ReadMeMain;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons,
  ViewModelBase, PropertyChangedEventArgs, ReadMeViewModel, FormShot;

type
  { TMainReadMeForm - die View des Readme-Demos.

    Zeigt den Inhalt der Readme-Datei an. Das Suchen und Lesen der Datei
    uebernimmt das ViewModel, das Oeffnen der Datei der Prozessdienst. }

  TMainReadMeForm = class(TForm)
    mmText: TMemo;
    btnClose: TBitBtn;
    btnOpen: TButton;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
  private
    FViewModel: TReadMeViewModel;
    procedure ViewModelPropertyChanged(Sender: TObject;
      const AArgs: TPropertyChangedEventArgs);
    procedure ApplyViewModel;
  public
    { Public declarations }
    property ViewModel: TReadMeViewModel read FViewModel;
  end;

var
  MainForm: TMainReadMeForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TMainReadMeForm.FormCreate(Sender: TObject);
begin
  FViewModel := TReadMeViewModel.Create;
  FViewModel.OnPropertyChanged := ViewModelPropertyChanged;
  ApplyViewModel;
end;

procedure TMainReadMeForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FViewModel);
end;

procedure TMainReadMeForm.FormActivate(Sender: TObject);
begin
  FViewModel.Load;
  ApplyViewModel;
end;

procedure TMainReadMeForm.ViewModelPropertyChanged(Sender: TObject;
  const AArgs: TPropertyChangedEventArgs);
begin
  ApplyViewModel;
end;

{ - Uebertragt den Inhalt des ViewModels auf die Oberflaeche. }
procedure TMainReadMeForm.ApplyViewModel;
begin
  if FViewModel = nil then
    Exit;
  mmText.Lines.Text := FViewModel.Content;
  Caption := FViewModel.FileName;
  if (FViewModel.ErrorMessage <> '') and not IsScreenshotMode then
  begin
    ShowMessage(FViewModel.ErrorMessage);
    FViewModel.ErrorMessage := '';
  end;
end;

procedure TMainReadMeForm.btnOpenClick(Sender: TObject);
begin
  FViewModel.OpenCommand.Execute;
end;

end.
