unit dm_TestEncoding;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mysql57conn, SQLDB, DB;

type

  { TDataModule1 }

  TDataModule1 = class(TDataModule)
    MySQL57Connection1: TMySQL57Connection;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure MySQL57Connection1AfterConnect(Sender: TObject);
    procedure SQLQuery1AfterOpen(DataSet: TDataSet);
    procedure SQLQuery1BeforeOpen(DataSet: TDataSet);
  private

  public

  end;

var
  DataModule1: TDataModule1;

implementation

uses lazutf8;

{$R *.lfm}
type

{ TStringField2 }

 TStringField2 = class(TStringField)
  public
  oldMannor:boolean;
  Function GetAsString:String; override;
  Procedure SetAsString(const AValue: String); override;
  end;

{ TStringField2 }

function TStringField2.GetAsString: String;
begin
  if oldMannor then
    Result:=Utf8ToWinCP(inherited GetAsString)
  else
    Result:=inherited GetAsString;
end;

procedure TStringField2.SetAsString(const AValue: String);
var
  s: String;
begin
  if oldMannor then
    begin
      s := AValue;
      SetCodePage(RawByteString(s), 1252, False);
      inherited SetAsString(s);
    end
  else
    inherited SetAsString(AValue);
end;


{ TDataModule1 }
procedure TDataModule1.MySQL57Connection1AfterConnect(Sender: TObject);
begin

end;

procedure TDataModule1.SQLQuery1AfterOpen(DataSet: TDataSet);
var
  aField: TField;
begin
  for aField in Dataset.Fields do
    if aField is TStringField2 then
      begin
        TStringField2(aField).oldMannor:=true;
      end;
end;

procedure TDataModule1.SQLQuery1BeforeOpen(DataSet: TDataSet);
begin

end;

initialization
  DefaultFieldClasses[ftString]:=TStringField2;
  DefaultFieldClasses[ftFixedChar]:=TStringField2;

end.

