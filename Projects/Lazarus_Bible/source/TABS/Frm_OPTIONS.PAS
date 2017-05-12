unit Frm_OPTIONS;

interface

uses
  Windows, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, Spin, SysUtils, TabsUnit, Dialogs,
  IniData, IniFiles;

type
  TOptionsDialog = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    Bevel1: TBevel;
    MiscGroup: TGroupBox;
    OperationRGroup: TRadioGroup;
    BackupCheckbox: TCheckBox;
    AutoSaveCheckbox: TCheckBox;
    StripCheckbox: TCheckBox;
    ConvertCheckbox: TCheckBox;
    ConfigEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    BackupExtEdit: TEdit;
    InTabEdit: TSpinEdit;
    OutTabEdit: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure InitTabOptions;
    procedure SaveOptions;
    procedure LoadOptions;
  end;

var
  OptionsDialog: TOptionsDialog;

implementation

{$R *.DFM}

{- Initialize options to default values }
procedure TOptionsDialog.InitTabOptions;
begin
  with OptionsDialog do
  begin
    OperationRGroup.ItemIndex := 1;  { Select remove tabs }
    BackupCheckbox.Checked := True;
    AutoSaveCheckbox.Checked := True;
    StripCheckbox.Checked := False;
    ConvertCheckbox.Checked := False;
    ConfigEdit.Text := 'Tabs.Ini';
    InTabEdit.Text := '8';
    OutTabEdit.Text := '8';
    BackupExtEdit.Text := 'Bak';
  end
end;

{- Save options to a configuration file }
procedure TOptionsDialog.SaveOptions;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ConfigEdit.Text);
  try
    SaveDataToINI(OptionsDialog, IniFile);
  finally
    IniFile.Free;
  end;
end;

{- Load options from a configuration file }
procedure TOptionsDialog.LoadOptions;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ConfigEdit.Text);
  try
    LoadDataFromINI(OptionsDialog, IniFile);
  finally
    IniFile.Free;
  end;
end;

procedure TOptionsDialog.FormCreate(Sender: TObject);
begin
  RegisterINIDataProp('TCheckBox', 'State');
  RegisterINIDataProp('TRadioGroup', 'ItemIndex');
  RegisterINIDataProp('TEdit', 'Text');
  RegisterINIDataProp('TSpinEdit', 'Value');
  LoadOptions;
end;

procedure TOptionsDialog.OKBtnClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TOptionsDialog.CancelBtnClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TOptionsDialog.HelpBtnClick(Sender: TObject);
begin
  ShowMessage('Sorry: Not Implemented!');
end;

end.
