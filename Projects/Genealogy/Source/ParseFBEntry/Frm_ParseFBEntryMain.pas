unit Frm_ParseFBEntryMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Grids,
  ExtCtrls,unt_FBParser,cmp_GedComFile,cls_GedComHelper;

type

  { TFrmParseFBEntryMain }

  TFrmParseFBEntryMain = class(TForm)
    edtSource:TMemo;
    stgData:TStringGrid;
    edtDefaultPlace:TLabeledEdit;
    btnParse:TButton;
    lbxFamily:TListBox;
    lbxPlaces:TListBox;
    lbxOccupations:TListBox;
    stgData1: TStringGrid;
    procedure btnParseClick(Sender: TObject);
    procedure edtSourceChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    Function AppendFamily(Ref:String):Integer;
    Function AppendPerson(aRef,aName:String):Integer;
    Function getFamily(Ref:String):Integer;
    Function getPerson(Ref:String):Integer;
    Procedure SetFamilyType(Fid,FType:Integer);
    Procedure SetFamilyDate(Fid,aType:Integer;Date:String);
    Procedure SetFamilyPlace(Fid,aType:Integer;aPlace:String);
    PRocedure  AppendFamilyIndiv(lFID,aIRef,IType:Integer);
    Procedure SetPersonDate(PiD,aType:Integer;Date:String);
    procedure FormDestroy(Sender: TObject);
  private
    fParser: TFBEntryParser;
    fgedComFile:TGedComFile;
    fGedComHelper:TGedComHelper;
//    fGenealogy:TClsHejGenealogy;
    procedure ParserFamilyDate(Sender: Tobject; aText: String; Ref: String;
      dsubtype: integer);
    procedure ParserFamilyIndiv(Sender: Tobject; aText: String; Ref: String;
      dsubtype: integer);
    procedure ParserFamilyPlace(Sender: Tobject; aText: String; Ref: String;
      dsubtype: integer);
    procedure ParserFamilyType(Sender: Tobject; aText: String; Ref: String;
      dsubtype: integer);
    procedure ParserIndData(Sender: TObject; aText: string; Ref: string;
      dsubtype: integer);
    procedure ParserIndiDate(Sender: TObject; aText: string; Ref: string;
      dsubtype: integer);
    procedure ParserIndiName(Sender: Tobject; aText: String; Ref: String;
      dsubtype: integer);
    procedure ParserIndOccu(Sender: TObject; aText: string; Ref: string;
      dsubtype: integer);
    procedure ParserIndPlace(Sender: TObject; aText: string; Ref: string;
      dsubtype: integer);
    procedure ParserIndRef(Sender: TObject; aText: string; Ref: string;
      dsubtype: integer);
    procedure ParserIndRel(Sender: TObject; aText: string; Ref: string;
      dsubtype: integer);
    procedure ParserStartFamily(Sender: Tobject; aText: String; Ref: String;
      dsubtype: integer);

  public

  end;

var
  FrmParseFBEntryMain: TFrmParseFBEntryMain;

implementation

{$R *.lfm}

{ TFrmParseFBEntryMain }

procedure TFrmParseFBEntryMain.btnParseClick(Sender: TObject);
begin
  fparser.Parse(edtSource.text);
end;

procedure TFrmParseFBEntryMain.edtSourceChange(Sender: TObject);
begin

end;

procedure TFrmParseFBEntryMain.FormCreate(Sender: TObject);
begin
  fParser := TFBEntryParser.create;
  fParser.onStartFamily:=@ParserStartFamily;
  fParser.onFamilyType:=@ParserFamilyType;
  fParser.onFamilyDate:=@ParserFamilyDate;
  fParser.onFamilyPlace:=@ParserFamilyPlace;
  fParser.onFamilyIndiv:=@ParserFamilyIndiv;
  fParser.onIndiName:=@ParserIndiName;
  fParser.onIndiDate:=@ParserIndiDate;
  fparser.onIndiPlace:=@ParserIndPlace;
  fParser.onIndiOccu:=@ParserIndOccu;
  fParser.onIndiData:=@ParserIndData;
  fParser.onIndiRef:=@ParserIndRef;
  fparser.onIndiRel:=@ParserIndRel;
  fgedComFile:=TGedComFile.Create;
  fGedComHelper:=TGedComHelper.create;
  fGedComHelper.GedComFile := fgedComFile;
end;

function TFrmParseFBEntryMain.AppendFamily(Ref: String): Integer;
begin
  stgData1.RowCount:=stgData1.RowCount+1 ;
  stgData1.Cells[0,stgData1.RowCount-1]:=inttostr(stgData1.RowCount-1);
  stgData1.Cells[1,stgData1.RowCount-1]:=Ref;
end;

function TFrmParseFBEntryMain.AppendPerson(aRef, aName: String): Integer;
begin
  stgData.RowCount:=stgData.RowCount+1 ;
  stgData.Cells[0,stgData.RowCount-1]:=inttostr(stgData.RowCount-1);
  stgData.Cells[1,stgData.RowCount-1]:=aRef;
  stgData.Cells[2,stgData.RowCount-1]:=aName;
end;

function TFrmParseFBEntryMain.getFamily(Ref: String): Integer;
begin
  result:=stgData1.Cols[1].IndexOf(ref);
end;

function TFrmParseFBEntryMain.getPerson(Ref: String): Integer;
begin
  result:=stgData.Cols[1].IndexOf(ref);
end;

procedure TFrmParseFBEntryMain.SetFamilyType(Fid, FType: Integer);
begin
  stgData1.Cells[2,Fid]:=inttostr(FType);
end;

procedure TFrmParseFBEntryMain.SetFamilyDate(Fid, aType: Integer; Date: String);
begin
  stgData1.Cells[3,Fid]:=Date;
  stgData1.Cells[4,fID]:=edtDefaultPlace.text;
end;

procedure TFrmParseFBEntryMain.SetFamilyPlace(Fid, aType: Integer;
  aPlace: String);
begin
  stgData1.Cells[4,fID]:=aPlace;
end;

procedure TFrmParseFBEntryMain.AppendFamilyIndiv(lFID, aIRef, IType: Integer);
begin
  if iType = 1 then
    stgData1.Cells[5,lFID]:=stgData.Cols[1][aIRef];
  if iType = 2 then
    stgData1.Cells[6,lFID]:=stgData.Cols[1][aIRef];
  if iType > 2 then
    stgData1.Cells[7,lFID]:=stgData1.Cells[7,lFID]+','+ stgData.Cols[1][aIRef];

end;

procedure TFrmParseFBEntryMain.SetPersonDate(PiD, aType: Integer; Date: String);
begin
  if atype = 1 then // Geburt
    stgData.Cells[3,Pid]:=Date;
  if atype = 3 then // Tod
    stgData.Cells[4,Pid]:=Date;
end;

procedure TFrmParseFBEntryMain.FormDestroy(Sender: TObject);
begin
  freeandnil(fParser);
  freeandnil(fGedComHelper);
  freeandnil(fgedComFile);

end;

procedure TFrmParseFBEntryMain.ParserFamilyType(Sender: Tobject; aText: String;
  Ref: String; dsubtype: integer);
var
  lFID: Integer;
begin
  lFID := GetFamily(ref);
  SetFamilyType(LFId,dSubType);
end;

procedure TFrmParseFBEntryMain.ParserIndData(Sender: TObject; aText: string;
  Ref: string; dsubtype: integer);
begin

end;

procedure TFrmParseFBEntryMain.ParserIndiDate(Sender: TObject; aText: string;
  Ref: string; dsubtype: integer);
var
  lPID: Integer;
begin
  lPID := GetPerson(Ref);
  SetPersonDate(lPID,dsubtype,aText);
end;

procedure TFrmParseFBEntryMain.ParserFamilyDate(Sender: Tobject; aText: String;
  Ref: String; dsubtype: integer);
var
  lFID: Integer;
begin
  lFID := GetFamily(ref);
  SetFamilyDate(LFId,dsubtype,atext);
end;

procedure TFrmParseFBEntryMain.ParserFamilyIndiv(Sender: Tobject;
  aText: String; Ref: String; dsubtype: integer);
var
  lFID,lPID: Integer;
begin
  lFID := GetFamily(ref);
  lPID := GetPerson(aText);
  AppendFamilyIndiv(lFID,lPID,dsubtype)
end;

procedure TFrmParseFBEntryMain.ParserFamilyPlace(Sender: Tobject;
  aText: String; Ref: String; dsubtype: integer);
begin

end;

procedure TFrmParseFBEntryMain.ParserIndiName(Sender: Tobject; aText: String;
  Ref: String; dsubtype: integer);
begin
  AppendPerson(Ref,aText);
end;

procedure TFrmParseFBEntryMain.ParserIndOccu(Sender: TObject; aText: string;
  Ref: string; dsubtype: integer);
begin

end;

procedure TFrmParseFBEntryMain.ParserIndPlace(Sender: TObject; aText: string;
  Ref: string; dsubtype: integer);
begin

end;

procedure TFrmParseFBEntryMain.ParserIndRef(Sender: TObject; aText: string;
  Ref: string; dsubtype: integer);
begin

end;

procedure TFrmParseFBEntryMain.ParserIndRel(Sender: TObject; aText: string;
  Ref: string; dsubtype: integer);
begin

end;

procedure TFrmParseFBEntryMain.ParserStartFamily(Sender: Tobject;
  aText: String; Ref: String; dsubtype: integer);
begin
  AppendFamily(aText);
end;

end.

