unit Frm_OleContMain;

{ OleCont, plattformneutral: Ein OLE-Container (nur Windows/Delphi) wird
  durch eine Bild-Vorschau ersetzt. "Insert Object..." waehlt eine Datei;
  Bilder werden angezeigt, andere Dateien mit dem Standardprogramm
  geoeffnet. Gleiches Lernziel - fremde Inhalte einbetten - ohne OLE. }

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  OleCtnrs, Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls;

type
  TMainForm = class(TForm)
   {$IFDEF FPC}
    PreviewImage: TImage;
   {$ELSE}
    OleContainer1: TOleContainer;
   {$ENDIF}
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Edit1: TMenuItem;
    InsertObject1: TMenuItem;
    Exit1: TMenuItem;
    procedure Exit1Click(Sender: TObject);
    procedure InsertObject1Click(Sender: TObject);
  private
    { Private declarations }
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

procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.InsertObject1Click(Sender: TObject);
{$IFDEF FPC}
var
  Dlg: TOpenDialog;
{$ENDIF}
begin
{$IFDEF FPC}
  { Eine Datei waehlen: Bilder in der Vorschau, sonst extern oeffnen. }
  Dlg := TOpenDialog.Create(Self);
  try
    Dlg.Filter :=
      'Alle Dateien (*.*)|*.*|Bilder (*.png;*.jpg;*.bmp;*.gif)|*.png;*.jpg;*.jpeg;*.bmp;*.gif';
    if Dlg.Execute then
    begin
      try
        PreviewImage.Picture.LoadFromFile(Dlg.FileName);
      except
        if not OpenDocument(Dlg.FileName) then
          ShowMessage('Konnte ' + Dlg.FileName + ' nicht anzeigen.');
      end;
    end;
  finally
    Dlg.Free;
  end;
{$ELSE}
  with OleContainer1 do
  begin
    if InsertObjectDialog then
      DoVerb(PrimaryVerb);
  end;
{$ENDIF}
end;

end.
