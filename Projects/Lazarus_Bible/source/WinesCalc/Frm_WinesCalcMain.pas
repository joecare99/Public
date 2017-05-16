unit Frm_WinesCalcMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Grids, DBGrids, ExtCtrls, DBCtrls, Db, DBTables;

type
  TMainForm = class(TForm)
    DataSource1: TDataSource;
    Table1: TTable;
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    BitBtn1: TBitBtn;
    Table1Name: TStringField;
    Table1Source: TStringField;
    Table1Vintage: TStringField;
    Table1Purchased: TDateField;
    Table1DaysOld: TIntegerField;
    procedure Table1DaysOldGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

{ Calculate the Days Old virtual field using today's
  date (returned by the SysUtils Date function) and
  the value of the database table's Purchased value. }
procedure TMainForm.Table1DaysOldGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := FloatToStr(Date - Table1Purchased.Value);
end;

end.
