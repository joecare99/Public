unit Frm_OLEWord1Main;

{ OleWord1, plattformneutral: Statt Microsoft Word per OLE-Automation
  fernzusteuern (nur Windows/Delphi), erzeugt das Demo eine Textdatei und
  oeffnet sie mit dem Standardprogramm des Systems (z. B. LibreOffice oder
  Word). Gleiches Lernziel - externe Anwendung ansteuern - ohne COM. }

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
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TMainForm = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$IFnDEF FPC}
uses ComObj;   // Declares the CreateOleObject function
{$ENDIF}

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TMainForm.Button1Click(Sender: TObject);
{$IFDEF FPC}
var
  FileName: string;
  F: TextFile;
begin
  { Textdatei erzeugen und mit dem Standardprogramm oeffnen. }
  FileName := IncludeTrailingPathDelimiter(GetTempDir) + 'oleword1.txt';
  AssignFile(F, FileName);
  Rewrite(F);
  try
    Writeln(F, 'Hello from Delphi');
  finally
    CloseFile(F);
  end;
  if not OpenDocument(FileName) then
    ShowMessage('Konnte ' + FileName + ' nicht oeffnen.');
end;
{$ELSE}
{ This procedure works with Microsoft Word 95 and
  earlier versions. It does *not* work with the
  newer Word 97, which now uses Visual Basic in
  place of Word Basic. }
var
  V: Variant;
begin
  V := CreateOleObject('Word.Document');
  V.Insert('Hello from Delphi');
  V.FilePrint;
  V.FileSaveAs('C:\Hold.doc');
end;
{$ENDIF}

end.
