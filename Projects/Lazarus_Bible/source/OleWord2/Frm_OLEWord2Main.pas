unit Frm_OLEWord2Main;

{ OleWord2, plattformneutral: Statt Word per OLE-Automation zu steuern
  (nur Windows/Delphi), erzeugt das Demo eine Textdatei und oeffnet sie mit
  dem Standardprogramm. Gleiches Lernziel ohne COM. }

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
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
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
uses ComObj;  // Declares the CreateOleObject function
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
  FileName := IncludeTrailingPathDelimiter(GetTempDir) + 'oleword2.txt';
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
{ This procedure works with the newer Word 97,
  which uses Visual Basic in place of the standard
  Word Basic as its controlling language. }
var
  V, X: Variant;
begin
  V := CreateOleObject('Word.Document');
  X := V.Range(0, 0);
  X.InsertBefore('Hello from Delphi');
  X.Font.Name := 'Arial';
  X.Font.Size := 18;
  X.InsertParagraphAfter;
  V.Printout;
  V.SaveAs('C:\Hold.doc');
end;
{$ENDIF}

end.
