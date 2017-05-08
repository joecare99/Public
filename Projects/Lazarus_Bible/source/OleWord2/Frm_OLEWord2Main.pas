unit Frm_OLEWord2Main;

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

uses ComObj;  // Declares the CreateOleObject function

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

{ This procedure works with the newer Word 97,
  which uses Visual Basic in place of the standard
  Word Basic as its controlling language. }
procedure TMainForm.Button1Click(Sender: TObject);
var
  V, X: Variant;
  S: String;
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

end.
