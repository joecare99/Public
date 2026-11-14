unit Frm_TelnameMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons,
  PropertyChangedEventArgs, TelnameViewModel;

type
  TfrmTelnameMain = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    CloseBitBtn: TBitBtn;
    NamesBitBtn: TBitBtn;
    NumberBitBtn: TBitBtn;
    NameEdit: TEdit;
    NumbEdit: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NumberBitBtnClick(Sender: TObject);
    procedure NamesBitBtnClick(Sender: TObject);
    procedure NumbEditKeyPress(Sender: TObject; var Key: Char);
    procedure NameEditKeyPress(Sender: TObject; var Key: Char);
    procedure NameEditChange(Sender: TObject);
    procedure NumbEditChange(Sender: TObject);
  private
    FViewModel: TTelnameViewModel;
    procedure ViewModelPropertyChanged(Sender: TObject;
      const AArgs: TPropertyChangedEventArgs);
    procedure ApplyViewModel;
  public
    property ViewModel: TTelnameViewModel read FViewModel;
  end;

var
  frmTelnameMain: TfrmTelnameMain;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TfrmTelnameMain.FormCreate(Sender: TObject);
begin
  ClientWidth := 620;
  ClientHeight := 440;
  Position := poScreenCenter;
  Caption := 'Telefonname und Nummer';
  Label1.Caption := 'Telefonnummer';
  Label2.Caption := 'Telefonname';
  ListBox1.SetBounds(24, 64, 264, 336);
  ListBox1.Anchors := [akLeft, akTop, akBottom];
  Label2.SetBounds(320, 40, 130, 17);
  NameEdit.SetBounds(320, 64, 276, 28);
  NameEdit.Anchors := [akLeft, akTop, akRight];
  Label1.SetBounds(320, 132, 130, 17);
  NumbEdit.SetBounds(320, 156, 276, 28);
  NumbEdit.Anchors := [akLeft, akTop, akRight];
  NumberBitBtn.SetBounds(320, 200, 180, 34);
  NumberBitBtn.Caption := 'In Nummer umwandeln';
  NumberBitBtn.Glyph.Clear;
  NamesBitBtn.SetBounds(320, 260, 180, 34);
  NamesBitBtn.Caption := 'Buchstaben erzeugen';
  NamesBitBtn.Glyph.Clear;
  CloseBitBtn.SetBounds(492, 400, 104, 32);
  CloseBitBtn.Anchors := [akRight, akBottom];
  FViewModel := TTelnameViewModel.Create;
  FViewModel.OnPropertyChanged := ViewModelPropertyChanged;
  NameEdit.OnChange := NameEditChange;
  NumbEdit.OnChange := NumbEditChange;
  OnDestroy := FormDestroy;
  ApplyViewModel;
end;

procedure TfrmTelnameMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FViewModel);
end;

procedure TfrmTelnameMain.ViewModelPropertyChanged(Sender: TObject;
  const AArgs: TPropertyChangedEventArgs);
begin
  if AArgs.PropertyName = 'Names' then
  begin
    ListBox1.Items.BeginUpdate;
    try
      ListBox1.Items.Assign(FViewModel.Names);
    finally
      ListBox1.Items.EndUpdate;
    end;
  end;
  if (AArgs.PropertyName = 'ErrorMessage') and
    (FViewModel.ErrorMessage <> '') then
    ShowMessage(FViewModel.ErrorMessage);
  ApplyViewModel;
end;

procedure TfrmTelnameMain.ApplyViewModel;
begin
  if FViewModel = nil then
    Exit;
  if NameEdit.Text <> FViewModel.NameText then
    NameEdit.Text := FViewModel.NameText;
  if NumbEdit.Text <> FViewModel.NumberText then
    NumbEdit.Text := FViewModel.NumberText;
  NumberBitBtn.Enabled := FViewModel.ConvertNameCommand.CanExecute;
  NamesBitBtn.Enabled := FViewModel.GenerateNamesCommand.CanExecute;
end;

procedure TfrmTelnameMain.NameEditChange(Sender: TObject);
begin
  if FViewModel <> nil then
    FViewModel.NameText := NameEdit.Text;
end;

procedure TfrmTelnameMain.NumbEditChange(Sender: TObject);
begin
  if FViewModel <> nil then
    FViewModel.NumberText := NumbEdit.Text;
end;

procedure TfrmTelnameMain.NumberBitBtnClick(Sender: TObject);
begin
  FViewModel.ConvertNameCommand.Execute;
  NumbEdit.SetFocus;
end;

procedure TfrmTelnameMain.NamesBitBtnClick(Sender: TObject);
begin
  FViewModel.GenerateNamesCommand.Execute;
  ListBox1.SetFocus;
end;

procedure TfrmTelnameMain.NumbEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    FViewModel.GenerateNamesCommand.Execute;
    Key := #0;
  end;
end;

procedure TfrmTelnameMain.NameEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    FViewModel.ConvertNameCommand.Execute;
    Key := #0;
  end;
end;

end.
