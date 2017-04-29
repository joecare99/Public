unit frm_EditCitations;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, MaskEdit, Menus, StrUtils, Math;

type
  enumCitationEditType=(
    eCET_EditExisting,
    eCET_New);
  { TEditCitations }

  TEditCitations = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    N: TSpinEdit;
    No: TSpinEdit;
    S: TMaskEdit;
    Memo: TMemo;
    Source: TComboBox;
    Code: TEdit;
    Source1: TComboBox;
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
  frm_Main, Traduction, dm_GenData;

{$R *.lfm}

{ TEditCitations }

procedure TEditCitations.FormShow(Sender: TObject);
var
  i:integer;
  sourcenumber:string;
begin
   EditCitations.ActiveControl:=EditCitations.S;
   frmStemmaMainForm.DataHist.Row:=0;
   Caption:=Traduction.Items[160];
   Label1.Caption:=Traduction.Items[161];
   Label2.Caption:=Traduction.Items[162];
   Label3.Caption:=Traduction.Items[163];
   Button1.Caption:=Traduction.Items[152];
   Button2.Caption:=Traduction.Items[164];
   // Populate Citations
   // GET TYPE AND NO FROM CALLER
   // Populate le ComboBox
   dmGenData.Query2.SQL.Text:='SELECT S.no, S.T FROM S ORDER BY S.no';
   dmGenData.Query2.Open;
   dmGenData.Query2.First;
   Source.Items.Clear;
   Source1.Items.Clear;
   while not dmGenData.Query2.EOF do
      begin
      sourcenumber:=dmGenData.Query2.Fields[0].AsString;
      i:=trunc(log10(dmGenData.Query2.RecordCount+1))+1;
      while length(sourcenumber)<i do sourcenumber:='0'+sourcenumber;
      Source.Items.Add(sourcenumber+'- '+dmGenData.Query2.Fields[1].AsString);
      Source1.Items.Add(dmGenData.Query2.Fields[0].AsString);
      dmGenData.Query2.Next;
   end;
   // Populate la form
//   dmGenData.GetCode(codex,nocode);
   if FEditType=eCET_New then
      begin
      EditCitations.Caption:=Traduction.Items[29];
      No.Value:=0;
      Source.ItemIndex:=0;
      Source1.ItemIndex:=Source.ItemIndex;
      Memo.Text:='';
//      dmGenData.GetCode(codex,nocode);
      Code.text:=FTypeCode;
      Q.Value:=0;
      S.Text:='';
   end
   else
      begin
      dmGenData.Query1.close;
      dmGenData.Query1.SQL.Text:='SELECT C.no, C.Y, C.N, C.S, C.M, C.Q FROM C WHERE C.no='+No.Text;
      dmGenData.Query1.Open;
      dmGenData.Query1.First;
      for i:=0 to Source1.Items.Count-1 do
         if Source1.Items[i]=dmGenData.Query1.Fields[3].AsString then
            Source.ItemIndex:=i;
      Source1.ItemIndex:=Source.ItemIndex;
      Memo.Text:=dmGenData.Query1.Fields[4].AsString;
      Code.Text:=dmGenData.Query1.Fields[1].AsString;
      N.value:=dmGenData.Query1.Fields[2].AsInteger;
      Q.Value:=dmGenData.Query1.Fields[5].AsInteger;
      S.Text:=Source1.Items[Source1.ItemIndex];
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
var
  i:integer;
begin
  if length(S.Text)>0 then
     if StrToInt(S.Text)>0 then
        begin
        for i:=0 to Source1.Items.Count-1 do
           if Source1.Items[i]=S.Text then
              Source.ItemIndex:=i;
        Source1.ItemIndex:=Source.ItemIndex;
     end;
end;

procedure TEditCitations.SourceEditingDone(Sender: TObject);
begin
   Source1.ItemIndex:=Source.ItemIndex;
   S.Text:=Source1.Items[Source1.ItemIndex];
   dmGenData.Query1.SQL.Text:='SELECT S.Q FROM S WHERE S.no='+Source1.Items[Source1.ItemIndex];
   dmGenData.Query1.Open;
   dmGenData.Query1.First;
   Q.Value:=dmGenData.Query1.Fields[0].AsInteger;
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
  dmGenData.Query1.SQL.Clear;
  if no.text<>'0' then
     dmGenData.Query1.SQL.Add('UPDATE C SET S='+Source1.Items[Source1.ItemIndex]+
        ', M='''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(Memo.Text),'\','\\'),'"','\"'),'''','\''')+
        ''', Q='+IntToStr(Q.Value)+' WHERE no='+no.text)
  else
     dmGenData.Query1.SQL.Add('INSERT INTO C (S, M, Q, Y, N) VALUES ( '+Source1.Items[Source1.ItemIndex]+
        ', '''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(Memo.Text),'\','\\'),'"','\"'),'''','\''')+
        ''', '+IntToStr(Q.Value)+', '''+Code.Text+''', '''+N.Text+''' )');
  dmGenData.Query1.ExecSQL;
  // Sauvegarder les dates de modifications
  if Code.Text='R' then
     begin
     dmGenData.Query3.SQL.Text:='SELECT R.A, R.B FROM R WHERE R.no='+N.Text;
     dmGenData.Query3.Open;
     dmGenData.Query3.First;
     dmGenData.SaveModificationTime(dmGenData.Query3.Fields[0].AsInteger);
     dmGenData.SaveModificationTime(dmGenData.Query3.Fields[1].AsInteger);
  end;
  if Code.Text='N' then
     begin
     dmGenData.Query3.SQL.Text:='SELECT N.I FROM N WHERE N.no='+N.Text;
     dmGenData.Query3.Open;
     dmGenData.Query3.First;
     dmGenData.SaveModificationTime(dmGenData.Query3.Fields[0].AsInteger);
  end;
  if Code.Text='E' then
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

