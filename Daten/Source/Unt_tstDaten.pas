unit Unt_tstDaten;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  DBTables, Windows,
{$ELSE}
  sqldb, LCLIntf, LCLType, LMessages,
{$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db,  ExtCtrls, DBCtrls, Grids, DBGrids;

type
  TForm1 = class(TForm)
    Query1: TSQLQuery;
    Database1: TDatabase;
//    Session1: TSession;
    UpdateSQL1: TSQLQuery;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    DataSource1: TDataSource;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

end.
