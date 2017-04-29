unit frm_EditSource;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, Spin, Menus, FMUtils, StrUtils, LCLType, Buttons, Process, IniFiles;

type

  { TEditSource }

  TEditSource = class(TForm)
    A: TEdit;
    Ajouter1: TMenuItem;
    Ajouter2: TMenuItem;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    Label11: TLabel;
    Label12: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem9: TMenuItem;
    Modifier1: TMenuItem;
    Modifier2: TMenuItem;
    PopupMenu2: TPopupMenu;
    PopupMenu3: TPopupMenu;
    Q: TSpinEdit;
    Supprimer1: TMenuItem;
    Supprimer2: TMenuItem;
    TableauExhibits: TStringGrid;
    Titre: TEdit;
    Label10: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    M: TMemo;
    No: TEdit;
    NomA: TEdit;
    Desc: TEdit;
    TableauDepots: TStringGrid;
    procedure AEditingDone(Sender: TObject);
    procedure Ajouter1Click(Sender: TObject);
    procedure Ajouter2Click(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure DescKeyDown(Sender: TObject; var Key: Word; {%H-}Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure MEditingDone(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure Modifier2Click(Sender: TObject);
    procedure Supprimer1Click(Sender: TObject);
    procedure Supprimer2Click(Sender: TObject);
    procedure TableauDepotsDblClick(Sender: TObject);
    procedure TableauDepotsEditingDone(Sender: TObject);
  private
    function GetID: LongInt;
    { private declarations }
  public
    { public declarations }
    property ID:LongInt read GetID;
  end; 

procedure PopulateDepots;

var
  EditSource: TEditSource;

implementation

uses
  frm_Main, Traduction, dm_GenData, frm_Sources, frm_Usage, frm_Documents, frm_ShowImage,
  frm_EditDocuments;

{ TEditSource }

procedure PopulateDepots;
var
  i:integer;
begin
     // Populate les dépots
     dmGenData.Query1.SQL.Text:='SELECT A.no, A.S, A.D, A.M, D.T FROM A JOIN D ON D.no=A.D WHERE A.S='+EditSource.no.text;
     dmGenData.Query1.Open;
     dmGenData.Query1.First;
     EditSource.TableauDepots.RowCount:=dmGenData.Query1.RecordCount+1;
     i:=1;
     while not dmGenData.Query1.eof do
        begin
        EditSource.TableauDepots.Cells[0,i]:=dmGenData.Query1.Fields[0].AsString;
        EditSource.TableauDepots.Cells[1,i]:=dmGenData.Query1.Fields[4].AsString;
        EditSource.TableauDepots.Cells[2,i]:=dmGenData.Query1.Fields[3].AsString;
        EditSource.TableauDepots.Cells[3,i]:=dmGenData.Query1.Fields[2].AsString;
        dmGenData.Query1.Next;
        i:=i+1;
     end;
end;

procedure TEditSource.FormShow(Sender: TObject);
var
  temp, code, nocode:string;
  auteur:boolean;
begin
  EditSource.ActiveControl:=EditSource.Titre;
  frmStemmaMainForm.DataHist.Row:=0;
  Caption:=Traduction.Items[190];
  btnOK.Caption:=Traduction.Items[152];
  btnCancel.Caption:=Traduction.Items[164];
  Label3.Caption:=Traduction.Items[171];
  Label7.Caption:=Traduction.Items[193];
  Label8.Caption:=Traduction.Items[191];
  Label9.Caption:=Traduction.Items[162];
  Label10.Caption:=Traduction.Items[179];
  Label11.Caption:=Traduction.Items[192];
  Label12.Caption:=Traduction.Items[298];
  TableauDepots.Cells[1,0]:=Traduction.Items[194];
  TableauDepots.Cells[2,0]:=Traduction.Items[156];
  TableauExhibits.Cells[2,0]:=Traduction.Items[154];
  TableauExhibits.Cells[4,0]:=Traduction.Items[201];
  Ajouter1.Caption:=Traduction.Items[224];
  Modifier1.Caption:=Traduction.Items[225];
  Supprimer1.Caption:=Traduction.Items[226];
  Ajouter2.Caption:=Traduction.Items[224];
  Modifier2.Caption:=Traduction.Items[225];
  Supprimer2.Caption:=Traduction.Items[226];
  MenuItem1.Caption:=Traduction.Items[233];
  MenuItem2.Caption:=Traduction.Items[224];
  MenuItem3.Caption:=Traduction.Items[225];
  MenuItem4.Caption:=Traduction.Items[226];
  MenuItem10.Caption:=Traduction.Items[181];
  // Populate la form
  dmGenData.Query1.SQL.Clear;
  dmGenData.GetCode(Code,nocode);
  if code='A' then
     begin
     EditSource.Caption:=Traduction.Items[43];
     Titre.Text:='';
     Desc.Text:='';
     A.Text:='';
     NomA.Text:='';
     M.Text:='';
     Q.Value:=0;
     TableauDepots.RowCount:=1;
     TableauExhibits.RowCount:=1;
     No.Text:='0';
  end
  else
     begin
     if code='S' then
        dmGenData.Query1.SQL.Add('SELECT S.no, S.T, S.D, S.M, S.Q, S.A FROM S WHERE S.no='+
                                     FormSources.TableauSources.Cells[1,FormSources.TableauSources.Row])
     else
        dmGenData.Query1.SQL.Add('SELECT S.no, S.T, S.D, S.M, S.Q, S.A FROM S WHERE S.no='+
                                     frmEventUsage.TableauUtilisation.Cells[0,frmEventUsage.TableauUtilisation.Row]);
     dmGenData.Query1.Open;
     dmGenData.Query1.First;
     No.Text:=dmGenData.Query1.Fields[0].AsString;
     Titre.Text:=dmGenData.Query1.Fields[1].AsString;
     Desc.Text:=dmGenData.Query1.Fields[2].AsString;
     temp:=dmGenData.Query1.Fields[5].AsString;
     auteur:=false;
     if (length(temp)>0) then
        if (temp[1] in ['0'..'9']) then
           auteur:=(StrtoInt(temp)>0);
     if auteur then
        begin
        A.Text:=temp;
        dmGenData.Query2.SQL.Text:='SELECT N.N FROM N WHERE N.X=1 AND N.I='+A.Text;
        dmGenData.Query2.Open;
        dmGenData.Query2.First;
        NomA.Text:=DecodeName(dmGenData.Query2.Fields[0].AsString,1);
        NomA.ReadOnly:=true;
     end
     else
        begin
        A.Text:='0';
        NomA.Text:=temp;
        NomA.ReadOnly:=false;
     end;
     M.Text:=dmGenData.Query1.Fields[3].AsString;
     Q.Value:=dmGenData.Query1.Fields[4].AsInteger;
     // Populate les dépots
     PopulateDepots;
     // Populate le tableau de documents
     PopulateDocuments(TableauExhibits,'S',ID);
  end;
end;

procedure TEditSource.MEditingDone(Sender: TObject);
begin
  frmStemmaMainForm.DataHist.InsertColRow(false,0);
  frmStemmaMainForm.DataHist.Cells[0,0]:='M';
  frmStemmaMainForm.DataHist.Cells[1,0]:=M.Text;
end;

procedure TEditSource.MenuItem10Click(Sender: TObject);
var
  ini:TIniFile;
  pdf:string;
begin
  // Visualiser un document de la source
  if TableauExhibits.Row>0 then
     begin
     dmGenData.Query2.SQL.Text:='SELECT X.Z, X.F FROM X WHERE X.no='+TableauExhibits.Cells[0,TableauExhibits.Row];
     dmGenData.Query2.Open;
     if TableauExhibits.Cells[4,TableauExhibits.Row]=Traduction.Items[34] then
        begin
        frmShowImage.Caption:=Traduction.Items[34];
        frmShowImage.Image.Visible:=false;
        frmShowImage.Memo.Visible:=true;
        frmShowImage.btnOK.Visible:=true;
        frmShowImage.btnCancel.Visible:=true;
        frmShowImage.Memo.Text:=dmGenData.Query2.Fields[0].AsString;
        if frmShowImage.Showmodal=mrOk then
           begin
           dmGenData.Query2.SQL.Clear;
           dmGenData.Query2.SQL.Add('UPDATE X SET Z='''+
              AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(frmShowImage.Memo.Text),'"','\"'),'''','\''')+
              ''' WHERE X.no='+TableauExhibits.Cells[0,TableauExhibits.Row]);
           dmGenData.Query2.ExecSQL;
        end;
     end
     else
        begin
        if AnsiPos('.PDF',dmGenData.Query2.Fields[1].AsString)>0 then
           begin
           Ini := TIniFile.Create(iniFileName);
           pdf := ini.ReadString('Parametres','PDF','C:\Program Files (x86)\Adobe\Reader 10.0\Reader\AcroRd32.exe');
           with TProcess.Create(nil) do
           try
              Parameters.Text:=pdf+' '+dmGenData.Query2.Fields[1].AsString;
              Execute;
              ini.WriteString('Parametres','PDF',pdf);
           finally
              Free;
           end;
           Ini.Free;
        end
        else
           begin
           frmShowImage.Caption:=dmGenData.Query2.Fields[1].AsString;
           frmShowImage.Memo.Visible:=false;
           frmShowImage.btnOK.Visible:=false;
           frmShowImage.btnCancel.Visible:=false;
           frmShowImage.Image.Visible:=true;
           frmShowImage.Image.Picture.LoadFromFile(dmGenData.Query2.Fields[1].AsString);
           frmShowImage.Showmodal;
        end;
     end;
  end;
end;

procedure TEditSource.MenuItem5Click(Sender: TObject);
begin
  btnOKClick(Sender);
  ModalResult:=mrOk;
end;

procedure TEditSource.MenuItem6Click(Sender: TObject);
var
  j:integer;
  found:boolean;
begin
  if EditSource.ActiveControl.Name='M' then
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
end;

procedure TEditSource.Modifier2Click(Sender: TObject);
begin
  // Modifier un document à la source
  If TableauExhibits.Row>0 then
     begin
     dmGenData.PutCode('S',TableauExhibits.Cells[0,TableauExhibits.Row]);
     If frmEditDocuments.Showmodal=mrOK then
        PopulateDocuments(TableauExhibits,'S',id);
     end;
end;

procedure TEditSource.Supprimer1Click(Sender: TObject);
begin
  // Supprimer un Dépot
  if TableauDepots.Row>0 then
     if Application.MessageBox(Pchar(Traduction.Items[44]+
        TableauDepots.Cells[1,TableauDepots.Row]+Traduction.Items[28]),pchar(Traduction.Items[1]),MB_YESNO)=IDYES then
        begin
        dmGenData.Query1.SQL.Text:='DELETE FROM A WHERE no='+TableauDepots.Cells[0,TableauDepots.Row];
        dmGenData.Query1.ExecSQL;
        TableauDepots.DeleteRow(TableauDepots.Row);
     end;
end;

procedure TEditSource.Supprimer2Click(Sender: TObject);
begin
  // Supprimer un document à la source
  If TableauExhibits.Row>0 then
     if Application.MessageBox(Pchar(Traduction.Items[60]+
        TableauExhibits.Cells[2,TableauExhibits.Row]+Traduction.Items[28]),pchar(Traduction.Items[1]),MB_YESNO)=IDYES then
        begin
        dmGenData.Query1.SQL.Text:='DELETE FROM X WHERE no='+TableauExhibits.Cells[0,TableauExhibits.Row];
        dmGenData.Query1.ExecSQL;
        TableauExhibits.DeleteRow(TableauExhibits.Row);
     end;
end;

procedure TEditSource.TableauDepotsDblClick(Sender: TObject);
var
  d:string;
begin
  // modification d'un dépot
  if TableauDepots.Row>0 then
     begin
     d:='0';
     if InputQuery(Traduction.Items[45],Traduction.Items[46],d) then
        begin
        dmGenData.Query1.SQL.Text:='SELECT D.T FROM D WHERE D.no='+d;
        dmGenData.Query1.Open;
        dmGenData.Query1.First;
        if not dmGenData.Query1.EOF then
           begin
           TableauDepots.Cells[1,TableauDepots.Row]:=dmGenData.Query1.Fields[0].AsString;
           TableauDepots.Cells[3,TableauDepots.Row]:=d;
           TableauDepotsEditingDone(Sender);
           PopulateDepots;
        end;
     end;
  end;
end;

procedure TEditSource.AEditingDone(Sender: TObject);
var
  temp:string;
  auteur:boolean;
begin
  temp:=A.Text;
  auteur:=false;
  if length(temp)>0 then
     if (temp[1] in ['0'..'9']) then
        if StrtoInt(A.text)>0 then
           auteur:=true;
  if auteur then
     begin
     dmGenData.Query2.SQL.Text:='SELECT N.N FROM N WHERE N.X=1 AND N.I='+A.Text;
     dmGenData.Query2.Open;
     dmGenData.Query2.First;
     NomA.Text:=DecodeName(dmGenData.Query2.Fields[0].AsString,1);
     NomA.ReadOnly:=true;
  end
  else
     begin
     A.text:='0';
     NomA.ReadOnly:=false;
  end;
end;

procedure TEditSource.Ajouter1Click(Sender: TObject);
var
  d:string;
begin
  // Ajouter un dépot
  d:='0';
  if InputQuery(Traduction.Items[47],Traduction.Items[46],d) then
     begin
     dmGenData.Query1.SQL.Text:='SELECT D.T FROM D WHERE D.no='+d;
     dmGenData.Query1.Open;
     dmGenData.Query1.First;
     if not dmGenData.Query1.EOF then
        begin
        TableauDepots.RowCount:=TableauDepots.RowCount+1;
        TableauDepots.Row:=TableauDepots.RowCount;
        TableauDepots.Cells[0,TableauDepots.Row]:='0';
        TableauDepots.Cells[1,TableauDepots.Row]:=dmGenData.Query1.Fields[0].AsString;
        TableauDepots.Cells[2,TableauDepots.Row]:='';
        TableauDepots.Cells[3,TableauDepots.Row]:=d;
        TableauDepotsEditingDone(Sender);
        PopulateDepots;
     end;
  end;
end;

procedure TEditSource.Ajouter2Click(Sender: TObject);
begin
  // Ajouter un document à la source
  If id=0 then
     btnOKClick(Sender);
  dmGenData.PutCode('S',no.text);
  dmGenData.PutCode('A',no.text);
  If frmEditDocuments.Showmodal=mrOK then
     PopulateDocuments(TableauExhibits,'S',id);
end;

procedure TEditSource.btnOKClick(Sender: TObject);
var
  temp:string;
  auteur:boolean;
begin
  dmGenData.Query1.SQL.Clear;
  temp:=A.Text;
  auteur:=false;
  if (length(temp)>0) then
     if (temp[1] in ['0'..'9']) then
        auteur:=StrtoInt(temp)>0;
  if no.text='0' then
     begin
     if auteur then
        dmGenData.Query1.SQL.Add('INSERT INTO S (T, D, M, A, Q) VALUES ('''+
           AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(Titre.text),'\','\\'),'"','\"'),'''','\''')+
           ''', '''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(Desc.text),'\','\\'),'"','\"'),'''','\''')+
           ''', '''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(M.text),'\','\\'),'"','\"'),'''','\''')+
           ''', '''+A.text+''', '+InttoStr(Q.Value)+')')
     else
        dmGenData.Query1.SQL.Add('INSERT INTO S (T, D, M, A, Q) VALUES ('''+
           AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(Titre.text),'\','\\'),'"','\"'),'''','\''')+
           ''', '''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(Desc.text),'\','\\'),'"','\"'),'''','\''')+
           ''', '''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(M.text),'\','\\'),'"','\"'),'''','\''')+
           ''', '''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(NomA.text),'\','\\'),'"','\"'),'''','\''')+
           ''', '+InttoStr(Q.Value)+')');
  end
  else
    begin
     if auteur then
        dmGenData.Query1.SQL.Add('UPDATE S SET T='''+
           AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(Titre.text),'\','\\'),'"','\"'),'''','\''')+
           ''', D='''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(Desc.text),'\','\\'),'"','\"'),'''','\''')+
           ''', M='''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(M.text),'\','\\'),'"','\"'),'''','\''')+
           ''', A='''+A.text+''', Q='+InttoStr(Q.Value)+' WHERE no='+no.text)
     else
        dmGenData.Query1.SQL.Add('UPDATE S SET T='''+
           AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(Titre.text),'\','\\'),'"','\"'),'''','\''')+
           ''', D='''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(Desc.text),'\','\\'),'"','\"'),'''','\''')+
           ''', M='''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(M.text),'\','\\'),'"','\"'),'''','\''')+
           ''', A='''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(NomA.text),'\','\\'),'"','\"'),'''','\''')+
           ''', Q='+InttoStr(Q.Value)+' WHERE no='+no.text);
    end;
  dmGenData.Query1.ExecSQL;
  if no.text='0' then
     begin
     no.text:=InttoStr(dmGenData.GetLastIDOfTable('S'));
  end;
end;

procedure TEditSource.DescKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_F3 then
     Desc.Text:=Titre.Text;
end;


procedure TEditSource.TableauDepotsEditingDone(Sender: TObject);
begin
  if no.text='0' then
     btnOKClick(Sender);
  dmGenData.Query1.SQL.Clear;
  if TableauDepots.Cells[0,TableauDepots.Row]='0' then
     dmGenData.Query1.SQL.Add('INSERT INTO A (S, D, M) VALUES ('+No.Text+', '+
        AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(TableauDepots.Cells[3,TableauDepots.Row]),'\','\\'),'"','\"'),'''','\''')+', '''+
        AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(TableauDepots.Cells[2,TableauDepots.Row]),'\','\\'),'"','\"'),'''','\''')+
        ''')')
  else
     dmGenData.Query1.SQL.Add('UPDATE A SET M='''+
        AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(TableauDepots.Cells[2,TableauDepots.Row]),'\','\\'),'"','\"'),'''','\''')+
        ''', D='+TableauDepots.Cells[3,TableauDepots.Row]+
        ' WHERE no='+TableauDepots.Cells[0,TableauDepots.Row]);
  dmGenData.Query1.ExecSQL;
  if TableauDepots.Cells[0,TableauDepots.Row]='0' then
     begin
     TableauDepots.Cells[0,TableauDepots.Row]:=InttoStr(dmGenData.GetLastIDOfTable('A'));
  end;
end;

function TEditSource.GetID: LongInt;
begin
  trystrtoint(No.Text,result);
end;

{ TEditSource }


{$R *.lfm}

end.

