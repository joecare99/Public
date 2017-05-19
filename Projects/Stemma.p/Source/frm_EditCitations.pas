unit frm_EditCitations;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, Menus, ExtCtrls, Buttons,  Math;

type
  enumCitationEditType=(
    eCET_EditExisting,
    eCET_New);
  { TEditCitations }

  TEditCitations = class(TForm)
    Button1: TBitBtn;
    Button2: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    N: TSpinEdit;
    No: TSpinEdit;
    Memo: TMemo;
    pnlBottom: TPanel;
    S: TSpinEdit;
    Source: TComboBox;
    Q: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure SEditingDone(Sender: TObject);
    procedure SourceEditingDone(Sender: TObject);
  private
    FEditType: enumCitationEditType;
    FTypeCode: string;
    function GetidCitation: integer;
    function GetidLink: integer;
    procedure SetEditType(AValue: enumCitationEditType);
    procedure SetidCitation(AValue: integer);
    procedure SetidLink(AValue: integer);
    procedure SetTypeCode(AValue: string);
    { private declarations }
  public
    { public declarations }
    property EditType: enumCitationEditType read FEditType write SetEditType;
    property TypeCode: string read FTypeCode write SetTypeCode;
    property idCitation:integer read GetidCitation write SetidCitation;
    property idLink:integer read GetidLink write SetidLink;
  end;

var
  EditCitations: TEditCitations;

implementation

uses
  frm_Main, cls_Translation, dm_GenData;

function GetSourceQuality(const lidSource: Integer): LongInt;
var
  lQuality: LongInt;
begin
  dmGenData.Query1.SQL.Text:='SELECT S.Q FROM S WHERE S.no=:idSource';
  dmGenData.Query1.ParamByName('idSource').AsInteger:=lidSource;
  dmGenData.Query1.Open;
  dmGenData.Query1.First;
  lQuality:=dmGenData.Query1.Fields[0].AsInteger;
  Result:=lQuality;
end;

{$R *.lfm}

{ TEditCitations }

procedure TEditCitations.FormShow(Sender: TObject);
var
  i:integer;
  sourcenumber:string;
  LStr: TStrings;
begin
   EditCitations.ActiveControl:=EditCitations.S;
   frmStemmaMainForm.DataHist.Row:=0;
   Caption:=Translation.Items[160];
   Label1.Caption:=Translation.Items[161];
   Label2.Caption:=Translation.Items[162];
   Label3.Caption:=Translation.Items[163];
   Button1.Caption:=Translation.Items[152];
   Button2.Caption:=Translation.Items[164];
   // Populate Citations
   // GET TYPE AND NO FROM CALLER
   // Populate le ComboBox
   LStr:=Source.Items;
   dmGenData.Query2.SQL.Text:='SELECT S.no, S.T FROM S ORDER BY S.no';
   dmGenData.Query2.Open;
   dmGenData.Query2.First;
   Lstr.Clear;
   while not dmGenData.Query2.EOF do
      begin
      sourcenumber:=dmGenData.Query2.Fields[0].AsString;
      i:=trunc(log10(dmGenData.Query2.RecordCount+1))+1;
      while length(sourcenumber)<i do sourcenumber:='0'+sourcenumber;
      LStr.AddObject(sourcenumber+'- '+dmGenData.Query2.Fields[1].AsString,
      TObject(PtrInt(dmGenData.Query2.Fields[0].AsInteger)));
      dmGenData.Query2.Next;
   end;
   // Populate la form
//   dmGenData.GetCode(codex,nocode);
   if FEditType=eCET_New then
      begin
      EditCitations.Caption:=Translation.Items[29];
      No.Value:=0;
      Source.ItemIndex:=0;
      Memo.Text:='';
//      dmGenData.GetCode(codex,nocode)
      Q.Value:=0;
      S.Text:='';
   end
   else
      begin
      dmGenData.Query1.close;
      dmGenData.Query1.SQL.Text:='SELECT C.no, C.Y, C.N, C.S, C.M, C.Q FROM C WHERE C.no='+No.Text;
      dmGenData.Query1.Open;
      dmGenData.Query1.First;
      Source.ItemIndex:=Source.Items.IndexOfObject(TObject(ptrint(dmGenData.Query1.Fields[3].AsInteger)));
      Memo.Text:=dmGenData.Query1.Fields[4].AsString;
      FTypeCode:=dmGenData.Query1.Fields[1].AsString;
      N.value:=dmGenData.Query1.Fields[2].AsInteger;
      Q.Value:=dmGenData.Query1.Fields[5].AsInteger;
      if  Source.ItemIndex >=0 then
        S.Value:=ptrint(Source.Items.Objects[Source.ItemIndex]);
   end;
end;

procedure TEditCitations.MenuItem1Click(Sender: TObject);
begin
  Button1Click(Sender);
  ModalResult:=mrOk;
end;

procedure TEditCitations.MenuItem2Click(Sender: TObject);
var
  i:integer;
  found:boolean;
  temp:string;
begin
  found:=false;
  For i:=frmStemmaMainForm.DataHist.Row to frmStemmaMainForm.DataHist.RowCount-1 do
     begin
     if frmStemmaMainForm.DataHist.Cells[0,i]='R' then
        begin
        S.text:=copy(frmStemmaMainForm.DataHist.Cells[1,i],1,AnsiPos('|',frmStemmaMainForm.DataHist.Cells[1,i])-1);
        SEditingDone(Sender);
        temp:=copy(frmStemmaMainForm.DataHist.Cells[1,i],AnsiPos('|',frmStemmaMainForm.DataHist.Cells[1,i])+1,length(frmStemmaMainForm.DataHist.Cells[1,i]));
        Memo.text:=copy(temp,1,AnsiPos('|',temp)-1);
        temp:=copy(temp,AnsiPos('|',temp)+1,length(temp));
        Q.value:=StrtoInt(copy(temp,1,length(temp)));
        frmStemmaMainForm.DataHist.Row:=i+1;
        found:=true;
        break;
     end;
  end;
  if not found then
     begin
     For i:=0 to frmStemmaMainForm.DataHist.RowCount-1 do
        begin
        if frmStemmaMainForm.DataHist.Cells[0,i]='R' then
           begin
           S.text:=copy(frmStemmaMainForm.DataHist.Cells[1,i],1,AnsiPos('|',frmStemmaMainForm.DataHist.Cells[1,i])-1);
           SEditingDone(Sender);
           temp:=copy(frmStemmaMainForm.DataHist.Cells[1,i],AnsiPos('|',frmStemmaMainForm.DataHist.Cells[1,i])+1,length(frmStemmaMainForm.DataHist.Cells[1,i]));
           Memo.text:=copy(temp,1,AnsiPos('|',temp)-1);
           temp:=copy(temp,AnsiPos('|',temp)+1,length(temp));
           Q.value:=StrtoInt(copy(temp,1,length(temp)));
           frmStemmaMainForm.DataHist.Row:=i+1;
           break;
        end;
     end;
  end;
end;

procedure TEditCitations.SEditingDone(Sender: TObject);

begin
     if S.Value > 0 then
        begin
        Source.ItemIndex:=Source.Items.IndexOfObject(TObject(ptrint(s.value)));
     end;
end;

procedure TEditCitations.SourceEditingDone(Sender: TObject);

begin
   S.Value:=ptrint(Source.Items.Objects[Source.ItemIndex]);
   Q.Value:=GetSourceQuality(S.value);
end;

procedure TEditCitations.SetEditType(AValue: enumCitationEditType);
begin
  if FEditType=AValue then Exit;
  FEditType:=AValue;
end;

function TEditCitations.GetidCitation: integer;
begin
  result := no.Value;
end;

function TEditCitations.GetidLink: integer;
begin
  result := n.Value;
end;

procedure TEditCitations.SetidCitation(AValue: integer);
begin
  if no.Value=AValue then exit;
  no.Value:=AValue;
end;

procedure TEditCitations.SetidLink(AValue: integer);
begin
  if N.Value=AValue then Exit;
  N.Value:=AValue;
end;

procedure TEditCitations.SetTypeCode(AValue: string);
begin
  if FTypeCode=AValue then Exit;
  FTypeCode:=AValue;
end;

procedure TEditCitations.Button1Click(Sender: TObject);
begin
  dmGenData.Query1.Close;
  if no.Value=0 then
    begin
     dmGenData.Query1.SQL.Text:='INSERT INTO C (S, M, Q, Y, N) VALUES ( :idSource, :Memo, :Q, :Type, :N)';
     dmGenData.Query1.ParamByName('Type').AsString:=FTypeCode;
     dmGenData.Query1.ParamByName('N').AsString:=N.Text;
    end
  else
    begin
     dmGenData.Query1.SQL.Text:='UPDATE C SET S=:idSource, M=:Memo, Q=:Q  WHERE no=:idCitation';
     dmGenData.Query1.ParamByName('idCitation').AsInteger:=no.Value;
    end;
    dmGenData.Query1.ParamByName('idSource').AsInteger:=ptrint(Source.Items.Objects[Source.ItemIndex]);
    dmGenData.Query1.ParamByName('Memo').AsString:=Memo.Text;
    dmGenData.Query1.ParamByName('Q').AsInteger:=Q.Value;
  dmGenData.Query1.ExecSQL;

  // Sauvegarder les dates de modifications
  if FTypeCode='R' then
     begin
     dmGenData.Query3.SQL.Text:='SELECT R.A, R.B FROM R WHERE R.no='+N.Text;
     dmGenData.Query3.Open;
     dmGenData.Query3.First;
     dmGenData.SaveModificationTime(dmGenData.Query3.Fields[0].AsInteger);
     dmGenData.SaveModificationTime(dmGenData.Query3.Fields[1].AsInteger);
  end;
  if FTypeCode='N' then
     begin
     dmGenData.Query3.SQL.Text:='SELECT N.I FROM N WHERE N.no='+N.Text;
     dmGenData.Query3.Open;
     dmGenData.Query3.First;
     dmGenData.SaveModificationTime(dmGenData.Query3.Fields[0].AsInteger);
  end;
  if FTypeCode='E' then
     begin
     dmGenData.Query3.SQL.Text:='SELECT W.I FROM W WHERE W.E='+N.Text;
     dmGenData.Query3.Open;
     dmGenData.Query3.First;
     while not dmGenData.Query3.eof do
        begin
        dmGenData.SaveModificationTime(dmGenData.Query3.Fields[0].AsInteger);
        dmGenData.Query3.Next;
     end;
  end;
  frmStemmaMainForm.DataHist.InsertColRow(false,0);
  frmStemmaMainForm.DataHist.Cells[0,0]:='R';
  frmStemmaMainForm.DataHist.Cells[1,0]:=S.Text+'|'+Memo.Text+'|'+InttoStr(Q.Value);
end;

end.

