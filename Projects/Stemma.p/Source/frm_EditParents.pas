unit frm_EditParents;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, Menus, FMUtils, StrUtils, frm_EditCitations, LCLType, Spin;

type

  { TfrmEditParents }

  TfrmEditParents = class(TForm)
    A: TSpinEdit;
    Ajouter1: TMenuItem;
    B: TSpinEdit;
    Button2: TButton;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    Modifier1: TMenuItem;
    No: TSpinEdit;
    X: TEdit;
    NomB: TEdit;
    NomA: TEdit;
    P1: TMemo;
    P2: TMemo;
    PopupMenu2: TPopupMenu;
    SD: TEdit;
    Button1: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    M: TMemo;
    P: TMemo;
    SD2: TEdit;
    Supprimer1: TMenuItem;
    TableauCitations: TStringGrid;
    Y: TComboBox;
    Label1: TLabel;
    Y2: TComboBox;
    procedure AEditingDone(Sender: TObject);
    procedure Ajouter1Click(Sender: TObject);
    procedure BEditingDone(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MEditingDone(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure P2DblClick(Sender: TObject);
    procedure PDblClick(Sender: TObject);
    procedure PEditingDone(Sender: TObject);
    procedure SDEditingDone(Sender: TObject);
    procedure Supprimer1Click(Sender: TObject);
    procedure TableauCitationsDblClick(Sender: TObject);
    procedure YChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

procedure ParentsSaveData;

var
  frmEditParents: TfrmEditParents;

implementation

uses
  frm_parents, frm_Children, frm_Main, cls_Translation, dm_GenData, frm_Names;

{ TfrmEditParents }

procedure TfrmEditParents.FormShow(Sender: TObject);
var
  i:integer;
  code,nocode:string;
begin
  { TODO 20 : Lorsque l'on est dans A ou B, ESC ne fonctionne pas - By design Lazarus}
  frmStemmaMainForm.DataHist.Row:=0;
  Caption:=Translation.Items[186];
  Button1.Caption:=Translation.Items[152];
  Button2.Caption:=Translation.Items[164];
  Label1.Caption:=Translation.Items[166];
  Label2.Caption:=Translation.Items[187];
  Label3.Caption:=Translation.Items[171];
  Label4.Caption:=Translation.Items[172];
  Label5.Caption:=Translation.Items[189];
  Label6.Caption:=Translation.Items[173];
  Label7.Caption:=Translation.Items[174];
  Label8.Caption:=Translation.Items[188];
  TableauCitations.Cells[1,0]:=Translation.Items[138];
  TableauCitations.Cells[2,0]:=Translation.Items[155];
  TableauCitations.Cells[3,0]:=Translation.Items[177];
  MenuItem1.Caption:=Translation.Items[228];
  MenuItem2.Caption:=Translation.Items[224];
  MenuItem3.Caption:=Translation.Items[225];
  MenuItem4.Caption:=Translation.Items[226];
  Ajouter1.Caption:=Translation.Items[224];
  Modifier1.Caption:=Translation.Items[225];
  Supprimer1.Caption:=Translation.Items[226];
  // Populate le ComboBox
  dmGenData.Query2.SQL.Text:='SELECT Y.no, Y.T, Y.P FROM Y WHERE Y.Y=''R''';
  dmGenData.Query2.Open;
  dmGenData.Query2.First;
  Y.Items.Clear;
  Y2.Items.Clear;
  while not dmGenData.Query2.EOF do
     begin
     Y.Items.Add(dmGenData.Query2.Fields[1].AsString);
     Y2.Items.Add(dmGenData.Query2.Fields[0].AsString);
     dmGenData.Query2.Next;
  end;
  // Populate la form
  dmGenData.GetCode(code,nocode);
  if code='A' then
     begin
     TableauCitations.RowCount:=1;
     Y.ItemIndex:=0;
     Y2.ItemIndex:=0;
     No.Text:='0';
     dmGenData.Query2.SQL.Text:='SELECT N.N FROM N WHERE N.X=1 AND N.I='+frmStemmaMainForm.sID;
     dmGenData.Query2.Open;
     dmGenData.Query2.First;
     X.Text:='0';
     dmGenData.GetCode(code,nocode);
     if Code='E' then
        begin
        frmEditParents.ActiveControl:=frmEditParents.A;
        frmEditParents.Caption:=Translation.Items[41];
        B.Text:=frmStemmaMainForm.sID;
        NomB.Text:=DecodeName(dmGenData.Query2.Fields[0].AsString,1);
        A.Text:='0';
        NomA.Text:='';
     end
     else
     begin
        frmEditParents.ActiveControl:=frmEditParents.B;
        frmEditParents.Caption:=Translation.Items[42];
        A.Text:=frmStemmaMainForm.sID;
        NomA.Text:=DecodeName(dmGenData.Query2.Fields[0].AsString,1);
        B.Text:='0';
        NomB.Text:='';
     end;
     M.Text:='';
     P.Text:='';
     SD.Text:='';
     SD2.Text:=InterpreteDate('',1);;
  end
  else
     begin
     frmEditParents.ActiveControl:=frmEditParents.A;
     dmGenData.Query1.SQL.Clear;
     if code='P' then
        dmGenData.Query1.SQL.Add('SELECT R.no, R.Y, R.B, R.M, R.X, R.SD, R.P, N.N, R.A FROM R JOIN N on R.B=N.I WHERE N.X=1 AND R.no='+
                                   FrmParents.TableauParents.Cells[0,FrmParents.TableauParents.Row])
     else
       dmGenData.Query1.SQL.Add('SELECT R.no, R.Y, R.B, R.M, R.X, R.SD, R.P, N.N, R.A FROM R JOIN N on R.B=N.I WHERE N.X=1 AND R.no='+
                                  inttostr(ptrint( frmChildren.TableauEnfants.Objects[0,frmChildren.TableauEnfants.Row])));
     dmGenData.Query1.Open;
     dmGenData.Query1.First;
     for i:=0 to Y2.Items.Count-1 do
        if Y2.Items[i]=dmGenData.Query1.Fields[1].AsString then
           Y.ItemIndex:=i;
     Y2.ItemIndex:=Y.ItemIndex;
     No.Text:=dmGenData.Query1.Fields[0].AsString;
     X.Text:=dmGenData.Query1.Fields[4].AsString;
     A.Text:=dmGenData.Query1.Fields[8].AsString;
     B.Text:=dmGenData.Query1.Fields[2].AsString;
     NomB.Text:=DecodeName(dmGenData.Query1.Fields[7].AsString,1);
     dmGenData.Query2.SQL.Text:='SELECT N.N FROM N WHERE N.X=1 AND N.I='+A.Text;
     dmGenData.Query2.Open;
     dmGenData.Query2.First;
     NomA.Text:=DecodeName(dmGenData.Query2.Fields[0].AsString,1);
     M.Text:=dmGenData.Query1.Fields[3].AsString;
     P.Text:=dmGenData.Query1.Fields[6].AsString;
     SD2.Text:=dmGenData.Query1.Fields[5].AsString;
     SD.Text:=ConvertDate(dmGenData.Query1.Fields[5].AsString,1);
     // Populate le tableau de citations
     dmGenData.PopulateCitations(TableauCitations,'R',No.Value);
  end;
  dmGenData.Query2.SQL.Text:='SELECT Y.no, Y.T, Y.P FROM Y WHERE Y.no='+Y2.Items[Y2.ItemIndex];
  dmGenData.Query2.Open;
  dmGenData.Query2.First;
  P1.Text:=dmGenData.Query2.Fields[2].AsString;
  if length(P.Text)=0 then
     begin
     P.Text:=P1.Text;
     Label6.Visible:=true;
  end;
  P2.Text:=DecodePhrase(A.Value,'ENFANT',P.Text,'R',No.Value);
  Button1.Enabled:=((StrToInt(A.Text)>0) and (StrToInt(B.Text)>0));
  TableauCitations.Enabled:=Button1.Enabled;
  MenuItem5.Enabled:=Button1.Enabled;
end;

procedure TfrmEditParents.MEditingDone(Sender: TObject);
begin
  frmStemmaMainForm.DataHist.InsertColRow(false,0);
  frmStemmaMainForm.DataHist.Cells[0,0]:='M';
  frmStemmaMainForm.DataHist.Cells[1,0]:=M.Text;
end;

procedure TfrmEditParents.MenuItem5Click(Sender: TObject);
begin
  Button1Click(Sender);
  ModalResult:=mrOk;
end;

procedure TfrmEditParents.MenuItem6Click(Sender: TObject);
var
  j:integer;
  found:boolean;
begin
  if frmEditParents.ActiveControl.Name='SD' then
     begin
     found:=false;
     For j:=frmStemmaMainForm.DataHist.Row to frmStemmaMainForm.DataHist.RowCount-1 do
        begin
        if frmStemmaMainForm.DataHist.Cells[0,j]='SD' then
           begin
           SD.text:=frmStemmaMainForm.DataHist.Cells[1,j];
           SDEditingDone(Sender);
           found:=true;
           break;
        end;
     end;
     if not found then
        begin
        For j:=0 to frmStemmaMainForm.DataHist.RowCount-1 do
           begin
           if frmStemmaMainForm.DataHist.Cells[0,j]='SD' then
              begin
              SD.text:=frmStemmaMainForm.DataHist.Cells[1,j];
              SDEditingDone(Sender);
              found:=true;
              break;
           end;
        end;
     end;
  end;
  if frmEditParents.ActiveControl.Name='A' then
     begin
     found:=false;
     For j:=frmStemmaMainForm.DataHist.Row to frmStemmaMainForm.DataHist.RowCount-1 do
        begin
        if frmStemmaMainForm.DataHist.Cells[0,j]='A' then
           begin
           A.text:=frmStemmaMainForm.DataHist.Cells[1,j];
           AEditingDone(Sender);
           found:=true;
           break;
        end;
     end;
     if not found then
        begin
        For j:=0 to frmStemmaMainForm.DataHist.RowCount-1 do
           begin
           if frmStemmaMainForm.DataHist.Cells[0,j]='A' then
              begin
              A.text:=frmStemmaMainForm.DataHist.Cells[1,j];
              AEditingDone(Sender);
              found:=true;
              break;
           end;
        end;
     end;
  end;
  if frmEditParents.ActiveControl.Name='P' then
     begin
     found:=false;
     For j:=frmStemmaMainForm.DataHist.Row to frmStemmaMainForm.DataHist.RowCount-1 do
        begin
        if frmStemmaMainForm.DataHist.Cells[0,j]='P' then
           begin
           P.text:=frmStemmaMainForm.DataHist.Cells[1,j];
           PEditingDone(Sender);
           found:=true;
           break;
        end;
     end;
     if not found then
        begin
        For j:=0 to frmStemmaMainForm.DataHist.RowCount-1 do
           begin
           if frmStemmaMainForm.DataHist.Cells[0,j]='P' then
              begin
              P.text:=frmStemmaMainForm.DataHist.Cells[1,j];
              PEditingDone(Sender);
              found:=true;
              break;
           end;
        end;
     end;
  end;
  if frmEditParents.ActiveControl.Name='B' then
     begin
     found:=false;
     For j:=frmStemmaMainForm.DataHist.Row to frmStemmaMainForm.DataHist.RowCount-1 do
        begin
        if frmStemmaMainForm.DataHist.Cells[0,j]='B' then
           begin
           B.text:=frmStemmaMainForm.DataHist.Cells[1,j];
           BEditingDone(Sender);
           found:=true;
           break;
        end;
     end;
     if not found then
        begin
        For j:=0 to frmStemmaMainForm.DataHist.RowCount-1 do
           begin
           if frmStemmaMainForm.DataHist.Cells[0,j]='B' then
              begin
              B.text:=frmStemmaMainForm.DataHist.Cells[1,j];
              BEditingDone(Sender);
              found:=true;
              break;
           end;
        end;
     end;
  end;
  if frmEditParents.ActiveControl.Name='M' then
     begin
     found:=false;
     For j:=frmStemmaMainForm.DataHist.Row to frmStemmaMainForm.DataHist.RowCount-1 do
        begin
        if frmStemmaMainForm.DataHist.Cells[0,j]='M' then
           begin
           M.text:=frmStemmaMainForm.DataHist.Cells[1,j];
           found:=true;
           break;
        end;
     end;
     if not found then
        begin
        For j:=0 to frmStemmaMainForm.DataHist.RowCount-1 do
           begin
           if frmStemmaMainForm.DataHist.Cells[0,j]='M' then
              begin
              M.text:=frmStemmaMainForm.DataHist.Cells[1,j];
              found:=true;
              break;
           end;
        end;
     end;
  end;
  if found then frmStemmaMainForm.DataHist.Row:=j+1;
end;

procedure TfrmEditParents.BEditingDone(Sender: TObject);
begin
  dmGenData.Query1.SQL.Text:='SELECT N.N FROM N WHERE N.X=1 AND N.I='+B.Text;
  dmGenData.Query1.Open;
  dmGenData.Query1.First;
  NomB.Text:=DecodeName(dmGenData.Query1.Fields[0].AsString,1);
  P2.Text:=DecodePhrase(A.Value,'ENFANT',P.Text,'R',No.Value);
  dmGenData.Query1.SQL.Text:='SELECT I.S FROM I WHERE I.no='+B.Text;
  dmGenData.Query1.Open;
  if dmGenData.Query1.eof then
     Button1.Enabled:=false
  else
     if dmGenData.Query1.Fields[0].AsString='?' then
        Button1.Enabled:=false
     else
        Button1.Enabled:=((StrToInt(A.Text)>0) and (StrToInt(B.Text)>0));
  TableauCitations.Enabled:=Button1.Enabled;
  MenuItem5.Enabled:=Button1.Enabled;
  frmStemmaMainForm.DataHist.InsertColRow(false,0);
  frmStemmaMainForm.DataHist.Cells[0,0]:='B';
  frmStemmaMainForm.DataHist.Cells[1,0]:=B.Text;
end;

procedure TfrmEditParents.AEditingDone(Sender: TObject);
begin
  dmGenData.Query1.SQL.Text:='SELECT N.N FROM N WHERE N.X=1 AND N.I='+A.Text;
  dmGenData.Query1.Open;
  dmGenData.Query1.First;
  NomA.Text:=DecodeName(dmGenData.Query1.Fields[0].AsString,1);
  P2.Text:=DecodePhrase(A.Value,'ENFANT',P.Text,'R',No.Value);
  Button1.Enabled:=((StrToInt(A.Text)>0) and (StrToInt(B.Text)>0));
  TableauCitations.Enabled:=Button1.Enabled;
  MenuItem5.Enabled:=Button1.Enabled;
  frmStemmaMainForm.DataHist.InsertColRow(false,0);
  frmStemmaMainForm.DataHist.Cells[0,0]:='A';
  frmStemmaMainForm.DataHist.Cells[1,0]:=A.Text;
end;

procedure TfrmEditParents.Ajouter1Click(Sender: TObject);
begin
  If no.text='0' then
     ParentsSaveData;
  dmGenData.PutCode('R',no.text);
  dmGenData.PutCode('A',no.text);
  If EditCitations.Showmodal=mrOK then
     dmGenData.PopulateCitations(TableauCitations,'R',No.Value);
end;

procedure ParentsSaveData;
var
  temp, primaire,  dateev:string;
  parent1, parent2,no_eve:integer;
  existe:boolean;
begin
  temp:=frmEditParents.no.text;
  // Si l'enfant n'a pas de parent de ce sexe, mettre la relation primaire.
  primaire:='0';
  dmGenData.Query1.SQL.Text:='SELECT I.S FROM I WHERE I.no='+frmEditParents.B.Text;
  dmGenData.Query1.Open;
  If not dmGenData.Query1.EOF then
     begin
     temp:=dmGenData.Query1.Fields[0].AsString;
     dmGenData.Query1.SQL.Text:='SELECT R.no, R.B FROM R JOIN I ON R.B=I.no WHERE I.S='''+
                               temp+''' AND R.X=1 AND R.A='+frmEditParents.A.Text;
     dmGenData.Query1.Open;
     If dmGenData.Query1.EOF then
        primaire:='1';
  end;
  if (frmEditParents.X.Text='1') or ((frmEditParents.no.Text='0') and (primaire='1')) then
     begin
     if temp='F' then temp:='M' else temp:='F';
     dmGenData.Query1.SQL.Text:='SELECT R.no, R.B, N.N FROM R JOIN I ON R.B=I.no JOIN N on N.I=R.B WHERE I.S=:Sex AND R.X=1 AND N.X=1 AND R.A=:idParentA';
     dmGendata.Query1.ParamByName('Sex').AsString:=temp;
     dmGendata.Query1.ParamByName('idParentA').AsString:=frmEditParents.A.Text;
     dmGenData.Query1.Open;
     If not dmGenData.Query1.EOF then
        begin
        temp:=dmGenData.Query1.Fields[2].AsString;
        parent1:=strtoInt(frmEditParents.B.Text); //ToDo : Convert to Integer
        parent2:=dmGenData.Query1.Fields[1].AsInteger;
        // Vérifier qu'il n'y a pas déjà une union entre ces deux parents
        dmGenData.Query1.SQL.Clear;
        dmGenData.Query1.SQL.Add('SELECT COUNT(E.no) FROM E JOIN W ON W.E=E.no JOIN Y on E.Y=Y.no WHERE (W.I=:idParentA OR W.I=:idParentB) AND W.X=1 AND E.X=1 AND Y.Y=''M'' GROUP BY E.no');
        dmGendata.Query1.ParamByName('idParentA').AsString:=frmEditParents.A.Text;
        dmGendata.Query1.ParamByName('idParentB').AsInteger:=parent1;
        dmGenData.Query1.Open;
        existe:=false;
        while not dmGenData.Query1.EOF do
           begin
           existe:=existe or (dmGenData.Query1.Fields[0].AsInteger=2);
           dmGenData.Query1.Next;
        end;
        if not existe then
           if Application.MessageBox(Pchar(Translation.Items[300]+
                 frmEditParents.nomB.Text+Translation.Items[299]+
                 DecodeName(temp,1)+
                 Translation.Items[28]),pchar(Translation.Items[1]),MB_YESNO)=IDYES then
              begin
              // Unir les parents
              // Ajouter l'événement mariage
              dmGenData.Query1.SQL.text:='INSERT INTO E (Y, L, X) VALUES (300, 1, 1)';
              dmGenData.Query1.ExecSQL;
              no_eve:=dmGenData.GetLastIDOfTable('E');
              // Ajouter les témoins
              dmGenData.Query1.SQL.text:='INSERT INTO W (I, E, X, R)'+
                ' VALUES (:idParent, :idEvent, 1, ''CONJOINT'')';
	      dmGenData.Query1.ParamByName('idEvent').AsInteger:=no_eve;
	      dmGenData.Query1.ParamByName('idParent').AsInteger:=parent1;
              dmGenData.Query1.ExecSQL;
	      dmGenData.Query1.ParamByName('idParent').AsInteger:=parent2;
              dmGenData.Query1.ExecSQL;
              // Ajouter les références
              // noter que l'on doit ajouter les références (frmStemmaMainForm.Code.Text='X')
              // sur l'événement # frmStemmaMainForm.no.Text
              dmGenData.PutCode('P',no_eve);
              // Sauvegarder les modifications
              dmGenData.SaveModificationTime(parent1);
              dmGenData.SaveModificationTime(parent2);
              // UPDATE DÉCÈS si la date est il y a 100 ans !!!
              if (copy(frmEditParents.SD2.text,1,1)='1') and not (frmEditParents.SD2.text='100000000030000000000') then
                 dateev:=Copy(frmEditParents.SD2.text,2,4)
              else
                 dateev:=FormatDateTime('YYYY',now);
              if ((StrtoInt(FormatDateTime('YYYY',now))-StrtoInt(dateev))>100) then
                 begin
                 dmGenData.Query2.SQL.Text:='UPDATE I SET V=''N'' WHERE no=:idParent';
                 dmGenData.Query2.ParamByName('idParent').AsInteger:=parent1;
                 dmGenData.Query2.ExecSQL;
                 dmGenData.Query2.ParamByName('idParent').AsInteger:=parent2;
                 dmGenData.Query2.ExecSQL;
                 dmGenData.NamesChanged(frmEditParents);
              end;
              dmGenData.EventChanged(frmEditParents);
           end;
     end;
  end;
  dmGenData.Query1.SQL.Clear;
  if frmEditParents.no.Text='0' then
     begin
     If frmEditParents.Label6.Visible then
        dmGenData.Query1.SQL.Add('INSERT INTO R (Y, A, B, M, SD, P, X) VALUES ('+frmEditParents.Y2.Items[frmEditParents.Y2.ItemIndex]+
          ', '+frmEditParents.A.Text+', '+frmEditParents.B.Text+', '''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(trim(frmEditParents.M.Text)),'\','\\'),'"','\"'),'''','\''')+
          ''', '''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(frmEditParents.SD2.Text),'\','\\'),'"','\"'),'''','\''')+
          ''', '''', '+primaire+')')
     else
       dmGenData.Query1.SQL.Add('INSERT INTO R (Y, A, B, M, SD, P, X) VALUES ('+frmEditParents.Y2.Items[frmEditParents.Y2.ItemIndex]+
         ', '+frmEditParents.A.Text+', '+frmEditParents.B.Text+', '''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(trim(frmEditParents.M.Text)),'\','\\'),'"','\"'),'''','\''')+
         ''', '''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(frmEditParents.SD2.Text),'\','\\'),'"','\"'),'''','\''')+
         ''', '''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(trim(frmEditParents.P.Text)),'\','\\'),'"','\"'),'''','\''')+
         ''', '+primaire+')')
     end
  else
     begin
     If frmEditParents.Label6.Visible then
        dmGenData.Query1.SQL.Add('UPDATE R SET Y='+frmEditParents.Y2.Items[frmEditParents.Y2.ItemIndex]+
          ', A='+frmEditParents.A.Text+', B='+frmEditParents.B.Text+', M='''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(trim(frmEditParents.M.Text)),'\','\\'),'"','\"'),'''','\''')+
          ''', SD='''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(frmEditParents.SD2.Text),'\','\\'),'"','\"'),'''','\''')+
          ''', P='''' WHERE no='+frmEditParents.no.text)
     else
       dmGenData.Query1.SQL.Add('UPDATE R SET Y='+frmEditParents.Y2.Items[frmEditParents.Y2.ItemIndex]+
         ', B='+frmEditParents.B.Text+', A='+frmEditParents.A.Text+', M='''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(trim(frmEditParents.M.Text)),'\','\\'),'"','\"'),'''','\''')+
         ''', SD='''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(frmEditParents.SD2.Text),'\','\\'),'"','\"'),'''','\''')+
         ''', P='''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(trim(frmEditParents.P.Text)),'\','\\'),'"','\"'),'''','\''')+
         ''' WHERE no='+frmEditParents.no.text);
  end;
  dmGenData.Query1.ExecSQL;
  if frmEditParents.no.text='0' then
     begin
     frmEditParents.no.text:=InttoStr(dmGenData.GetLastIDOfTable('R'));
  end;
  // Sauvegarder les modifications
  if StrtoInt(frmEditParents.A.Text)>0 then dmGenData.SaveModificationTime(frmEditParents.A.Value);
  if StrtoInt(frmEditParents.B.Text)>0 then dmGenData.SaveModificationTime(frmEditParents.B.Value);
  // UPDATE DÉCÈS si la date est il y a 100 ans !!!
  if (copy(frmEditParents.SD2.text,1,1)='1') and not (frmEditParents.SD2.text='100000000030000000000') then
     dateev:=Copy(frmEditParents.SD2.text,2,4)
  else
     dateev:=FormatDateTime('YYYY',now);
  if ((StrtoInt(FormatDateTime('YYYY',now))-StrtoInt(dateev))>100) then
     begin
     dmGenData.Query2.SQL.Text:='UPDATE I SET V=''N'' WHERE no='+frmEditParents.A.Text;
     dmGenData.Query2.ExecSQL;
     dmGenData.Query2.SQL.Text:='UPDATE I SET V=''N'' WHERE no='+frmEditParents.B.Text;
     dmGenData.Query2.ExecSQL;
     If (frmStemmaMainForm.actWinNameAndAttr.Checked) then
               frmNames.PopulateNom(frmParents);
  end;
end;

procedure TfrmEditParents.Button1Click(Sender: TObject);
var
  code,nocode:string;
begin
  ParentsSaveData;
  // Donc déplacer ce bloc à la fin de Button1 et
  // exécuter seulement si c'est vraiment une sortie par Button1 ou F10
  dmGenData.GetCode(code,nocode);
  if code='P' then
     begin
     dmGenData.Query1.SQL.Text:='SELECT S, Q, M FROM C WHERE Y=''R'' AND N='+no.text;
     dmGenData.Query1.Open;
     dmGenData.Query1.First;
     While not dmGenData.Query1.EOF do
        begin
        dmGenData.Query2.SQL.Clear;
        dmGenData.Query2.SQL.Add('INSERT INTO C (Y, N, S, Q, M) VALUES (''E'', '+
           nocode+', '+dmGenData.Query1.Fields[0].AsString+', '+
           dmGenData.Query1.Fields[1].AsString+', '''+
           dmGenData.Query1.Fields[2].AsString+''')');
        dmGenData.Query2.ExecSQL;
        dmGenData.Query1.Next;
     end;
  end;
end;

procedure TfrmEditParents.P2DblClick(Sender: TObject);
begin
  P.Visible:=true;
  P2.Visible:=false;
end;

procedure TfrmEditParents.PDblClick(Sender: TObject);
begin
  P2.Visible:=true;
  P.Visible:=false;
end;

procedure TfrmEditParents.PEditingDone(Sender: TObject);
begin
  If length(P.Text)=0 then
     P.Text:=P1.Text;
  Label6.Visible:=(P.Text=P1.Text);
  P2.Text:=DecodePhrase(A.Text,'ENFANT',P.Text,'R',No.Text);
  frmStemmaMainForm.DataHist.InsertColRow(false,0);
  frmStemmaMainForm.DataHist.Cells[0,0]:='P';
  frmStemmaMainForm.DataHist.Cells[1,0]:=P.Text;
end;

procedure TfrmEditParents.SDEditingDone(Sender: TObject);
begin
  SD2.Text:=InterpreteDate(SD.Text,1);
  SD.Text:=convertDate(SD.Text,1);
  frmStemmaMainForm.DataHist.InsertColRow(false,0);
  frmStemmaMainForm.DataHist.Cells[0,0]:='SD';
  frmStemmaMainForm.DataHist.Cells[1,0]:=SD2.Text;
end;

procedure TfrmEditParents.Supprimer1Click(Sender: TObject);
begin
  If TableauCitations.Row>0 then
     if Application.MessageBox(Pchar(Translation.Items[31]+
        TableauCitations.Cells[1,TableauCitations.Row]+Translation.Items[28]),pchar(Translation.Items[1]),MB_YESNO)=IDYES then
        begin
        dmGenData.Query1.SQL.Text:='DELETE FROM C WHERE no='+TableauCitations.Cells[0,TableauCitations.Row];
        dmGenData.Query1.ExecSQL;
        TableauCitations.DeleteRow(TableauCitations.Row);
        // Sauvegarder les modifications
        if StrtoInt(A.Text)>0 then dmGenData.SaveModificationTime(A.Value);
        if StrtoInt(B.Text)>0 then dmGenData.SaveModificationTime(B.Value);
     end;
end;

procedure TfrmEditParents.TableauCitationsDblClick(Sender: TObject);
begin
  if TableauCitations.Row>0 then
     begin
     dmGenData.PutCode('R',TableauCitations.Cells[0,TableauCitations.Row]);
     If EditCitations.Showmodal=mrOK then
        dmGenData.PopulateCitations(TableauCitations,'R',No.Value);
  end;
end;

procedure TfrmEditParents.YChange(Sender: TObject);
var
  idInd: Longint;
begin
  Y2.ItemIndex:=Y.ItemIndex;
  dmGenData.Query1.SQL.Text:='SELECT Y.P FROM Y WHERE Y.no='+Y2.Items[Y2.ItemIndex];
  dmGenData.Query1.Open;
  dmGenData.Query1.First;
  P1.Text:=dmGenData.Query1.Fields[0].AsString;
  If Label6.Visible and trystrtoint(A.Text,idInd) Then
     begin
     P.Text:=dmGenData.Query1.Fields[0].AsString;
     P2.Text:=DecodePhrase(idind,'ENFANT',P.Text,'R',No.Value);
  end
  else
     Label6.Visible:=(P.Text=P1.Text);
end;

{$R *.lfm}

{ TfrmEditParents }

end.

