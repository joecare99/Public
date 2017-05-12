unit Frm_ReadMeMain;

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
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons;

type

  { TMainForm }

  TMainForm = class(TForm)
    Memo1: TMemo;
    BitBtn1: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FDataDir:String;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

const ReadMeFile = 'Readme.Txt';
     DefDataDir ='Data';
{$IFnDEF FPC}
     DirectorySeparator=SysUtils.PathDelim;
{$ENDIF}

procedure TMainForm.FormActivate(Sender: TObject);
var
  FileName: string;
begin
  if ParamCount >= 1
    then FileName := ParamStr(1)
    else FileName := FDataDir+DirectorySeparator+ReadMeFile;
  Memo1.Lines.LoadFromFile(FileName);
  Caption := FileName;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  FDataDir:=DefDataDir;
  for i := 0 to 2 do
    if not DirectoryExists (FDataDir) then
      FDataDir:='..'+DirectorySeparator+FDataDir
    else
      break;
end;

end.
