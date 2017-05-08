unit Frm_OptionsMain;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, Inidata, StdCtrls, Buttons,
  IniFiles, ComCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
    TabbedNotebook1: TPageControl;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Edit1: TEdit;
    Edit2: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ts1: TTabSheet;
    ts2: TTabSheet;
    ts3: TTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    FDataDir:String;
    procedure LoadOptions;
    procedure SaveOptions;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
const DirectorySeparator='\';
{$ELSE}
  {$R *.lfm}
{$ENDIF}

const
  DataDefDir = 'Data';  { The stream's Directory }
  fileName = 'test.ini';  { The stream's file name }

  procedure TMainForm.LoadOptions;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(FDataDir+DirectorySeparator+ FileName);
  try
    LoadDataFromINI(MainForm, IniFile);
  finally
    IniFile.Free;
  end;
end;

procedure TMainForm.SaveOptions;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(FDataDir+DirectorySeparator+ FileName);
  try
    SaveDataToINI(MainForm, IniFile);
  finally
    IniFile.Free;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  FDataDir:=DataDefDir;
  for i := 0 to 3 do
    if not DirectoryExists(FDataDir) then
      FDataDir:='..'+DirectorySeparator+FDataDir
    else
      break;
  RegisterINIDataProp('TCheckBox', 'State');
  RegisterINIDataProp('TRadioButton', 'Checked');
  RegisterINIDataProp('TEdit', 'Text');
  LoadOptions;
end;

procedure TMainForm.BitBtn1Click(Sender: TObject);
begin
  SaveOptions;
end;

end.
