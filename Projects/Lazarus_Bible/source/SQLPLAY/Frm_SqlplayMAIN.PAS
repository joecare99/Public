unit Frm_SqlplayMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  DBTables, Windows,
{$ELSE}
   LCLIntf, LCLType, LMessages,
{$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Grids,
  DBGrids, DBCtrls, SQLTable, DB, sqldb,Frm_SQLOPENDB;

type

  { TMainForm }

  TMainForm = class(TForm)
    DataSource1: TDataSource;
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    Memo1: TMemo;
    Bevel1: TBevel;
    PerformBitBtn: TBitBtn;
    CloseBitBtn: TBitBtn;
    OpenBitBtn: TBitBtn;
    Query1: TSQLQuery;
    procedure OpenBitBtnClick(Sender: TObject);
    procedure PerformBitBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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

procedure TMainForm.OpenBitBtnClick(Sender: TObject);
begin
  if OpenForm.ShowModal = mrOk then
  begin
    Query1.Close;
    try
//      Query1.DatabaseName := OpenForm.ComboBox1.Text;
      Query1.SQL.Clear;
      Query1.SQL.Add('Select * From ' +
        OpenForm.ComboBox2.Text);
      Memo1.Lines := Query1.SQL;
      Query1.Open;
      Memo1.SetFocus;
      PerformBitBtn.Enabled := True;
    except;
      ShowMessage('Unable to open database');
    end;
  end;
end;

procedure TMainForm.PerformBitBtnClick(Sender: TObject);
begin
  Query1.Close;
  try
    Query1.SQL.Text := Memo1.Lines.Text;
    Query1.Open;
  except
    ShowMessage('Invalid query');
  end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Query1.Close;
end;

end.
