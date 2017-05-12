unit Frm_SQLOPENDB;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  DbTables, Windows,
{$ELSE}
  sqldb, mysql56conn, odbcconn, LCLIntf, LCLType, LMessages,
{$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Db, mysql60conn;

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
    Session: TSQLConnector;
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

procedure TOpenForm.FormActivate(Sender: TObject);
begin
  {$IFDEF FPC}
  Session.GetSchemaNames(ComboBox1.Items);
  {$ELSE}
  Session.GetAliasNames(ComboBox1.Items);
  {$ENDIF}
end;

procedure TOpenForm.ComboBox1Change(Sender: TObject);
begin
  {$IFDEF FPC}
  Session.GetTableNames( ComboBox2.Items,false);
  {$ELSE}
  Session.GetTableNames(ComboBox1.Text, '*.*',
    False, False, ComboBox2.Items);
  {$ENDIF}
  ComboBox2.ItemIndex := 0;
end;

end.
