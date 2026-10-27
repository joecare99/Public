unit Frm_SQLOPENDB;

{ SQLPlay "Datenbank oeffnen", plattformneutral: Statt dbExpress/MySQL
  (Windows-Treiber) wird die BDE-freie DBParadox-Engine benutzt und die
  Paradox-Tabelle Wines.DB aus Data/Wines angeboten. }

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  DbTables, Windows,
{$ELSE}
  sqldb, DBParadoxConnection, LCLIntf, LCLType, LMessages,
{$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Db;

type

  { TOpenForm }

  TOpenForm = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Bevel1: TBevel;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Bevel2: TBevel;
    Label2: TLabel;
    ComboBox2: TComboBox;
{$IFDEF FPC}
    Session: TDBParadoxConnection;
{$ELSE}
    Session: TSQLConnection;
{$ENDIF}
    SQLTransaction1: TSQLTransaction;
    procedure FormActivate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OpenForm: TOpenForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

{ Sucht den Datenordner Data/Wines, ausgehend vom Programmverzeichnis. }
function FindDataDir: string;
var
  Dir: string;
  I: Integer;
begin
  Dir := 'Data' + PathDelim + 'Wines';
  for I := 0 to 5 do
    if DirectoryExists(Dir) then
      Exit(Dir)
    else
      Dir := '..' + PathDelim + Dir;
  Result := 'Data' + PathDelim + 'Wines';
end;

procedure TOpenForm.FormActivate(Sender: TObject);
begin
  {$IFDEF FPC}
  { Paradox-Ordner und die enthaltene Tabelle anbieten. }
  Session.DatabaseName := FindDataDir;
  Session.LoginPrompt := False;
  ComboBox1.Items.Clear;
  ComboBox1.Items.Add(Session.DatabaseName);
  ComboBox1.ItemIndex := 0;
  ComboBox1Change(Sender);
  {$ELSE}
  Session.GetAliasNames(ComboBox1.Items);
  {$ENDIF}
end;

procedure TOpenForm.ComboBox1Change(Sender: TObject);
begin
  {$IFDEF FPC}
  { In Data/Wines liegt die Tabelle Wines.DB. }
  ComboBox2.Items.Clear;
  ComboBox2.Items.Add('Wines');
  ComboBox2.ItemIndex := 0;
  {$ELSE}
  Session.GetTableNames(ComboBox1.Text, '*.*',
    False, False, ComboBox2.Items);
  ComboBox2.ItemIndex := 0;
  {$ENDIF}
end;

end.
