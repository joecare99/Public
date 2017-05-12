unit Frm_RunMeTEST;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, Buttons;

type

  { TTestForm }

  TTestForm = class(TForm)
    ClickMeButton: TButton;
    Label1: TLabel;
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    procedure ClickMeButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FDataDir:String;
  public
    { Public declarations }
  end;

var
  TestForm: TTestForm;

implementation

{$IFnDEF FPC}
uses
  Shellapi;
const
  DirectorySeparator= PathDelim;
{$ELSE}
{$ENDIF}

resourcestring
  ReadMeFile = 'Readme.Txt';
  DefDataDir ='Data';
{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

(* 16-bit version; still works but WinExec is obsolete
procedure TTestForm.ClickMeButtonClick(Sender: TObject);
var
  K: Integer;  { Result of calling WinExec }
begin
  K := WinExec('Readme.Exe Readme.Txt', SW_SHOWNORMAL);
  if K < 32 then
    ShowMessage('Error running README.EXE');
end;
*)

{ 32-bit version; calls ExecuteFile in FMXUtils unit, which
  is located in Delphi's Demos\Doc\Filmanex folder }
procedure TTestForm.ClickMeButtonClick(Sender: TObject);
var
  H: THandle;
  LParameter:string;
begin
 LParameter:=FDatadir+DirectorySeparator+ReadMeFile;
{$IFnDEF FPC}
 H := Shellexecute(Handle,'open','Readme.exe', @LParameter[1], '.',
         SW_SHOWNORMAL);
  if Integer(H) < 32 then
{$ELSE}
  H := ExecuteProcess('Readme.exe',Lparameter,[]);
   if Integer(H) <> 0 then
{$ENDIF}

    ShowMessage('Error running Readme.exe');
end;


procedure TTestForm.FormCreate(Sender: TObject);
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
