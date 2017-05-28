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
  Forms, Dialogs, StdCtrls, Buttons;

type

  { TMainForm }

  TMainForm = class(TForm)
    mmText: TMemo;
    btnClose: TBitBtn;
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

uses LConvEncoding;

const ReadMeFile = 'Readme.Txt';
     DefDataDir ='Data';
{$IFnDEF FPC}
     DirectorySeparator=SysUtils.PathDelim;
{$ENDIF}

procedure TMainForm.FormActivate(Sender: TObject);
var
  FileName: string;
   s, FFileEncoding:string;
     sf:TFileStream;
begin
  if ParamCount >= 1
    then FileName := ParamStr(1)
    else FileName := FDataDir+DirectorySeparator+ReadMeFile;

    sf:=TFileStream.Create(Filename,fmOpenRead);
    try
      setlength(s,sf.Size);
      sf.ReadBuffer(s[1],sf.Size);
//      s[sf.Size+1]:=#0;
      FFileEncoding := GuessEncoding(s);
      mmText.lines.Text:=ConvertEncoding(s,FFileEncoding,EncodingUTF8);
    finally
      freeandnil(sf);
    end;
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
