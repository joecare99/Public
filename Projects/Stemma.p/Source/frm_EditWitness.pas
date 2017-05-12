unit frm_EditWitness;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Menus, Buttons, Spin, FMUtils, StrUtils;

type
  { TfrmEditWitness }

  TfrmEditWitness = class(TForm)
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    E: TSpinEdit;
    I: TSpinEdit;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    No: TSpinEdit;
    NomI: TEdit;
    P: TMemo;
    P1: TMemo;
    P2: TMemo;
    Role: TComboBox;
    X: TSpinEdit;
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure IEditingDone(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure PEditingDone(Sender: TObject);
    procedure RoleChange(Sender: TObject);
  private
    function GetidEvent: integer;
    function GetidWitness: integer;
    procedure SetidEvent(AValue: integer);
    procedure SetidWitness(AValue: integer);
    { private declarations }
  public
    { public declarations }
    Property idEvent:integer read GetidEvent write SetidEvent;
    Property idWitness:integer read GetidWitness write SetidWitness;
  end;

var
  frmEditWitness: TfrmEditWitness;

implementation

uses frm_EditEvents, frm_Main, dm_GenData,cls_Translation, frm_Explorer;

procedure FillResourceList(const items: TStrings; const lidType: PtrInt);
var
  temp: string;
begin
  with dmGenData.Query1 do begin
  SQL.text:='SELECT Y.R FROM Y WHERE Y.no=:idType';
    ParamByName('idType').AsInteger:=lidType;
    Open;
    First;
     Items.Clear;
    temp:=Fields[0].AsString;
    while AnsiPos('|',temp)>0 do
       begin
        Items.Add(Copy(temp,1,AnsiPos('|',temp)-1));
       temp:=Copy(temp,AnsiPos('|',temp)+1,length(temp));
    end;
     Items.Add(Copy(temp,1,length(temp)));
  end;
end;

{$R *.lfm}

{ TfrmEditWitness }

procedure TfrmEditWitness.PEditingDone(Sender: TObject);
begin
  If length(P.Text)=0 then
     P.Text:=P1.Text;
  Label6.Visible:=(P.Text=P1.Text);
  P2.Text:=DecodePhrase(I.Value,Role.Items[Role.ItemIndex],P.Text,'E',E.Value);
  frmStemmaMainForm.DataHist.InsertColRow(false,0);
  frmStemmaMainForm.DataHist.Cells[0,0]:='P';
  frmStemmaMainForm.DataHist.Cells[1,0]:=P.Text;
end;

procedure TfrmEditWitness.RoleChange(Sender: TObject);
begin
  P2.Text:=DecodePhrase(I.Value,Role.Text,P.Text,'E',E.Value);
end;

function TfrmEditWitness.GetidEvent: integer;
begin
  result := e.Value;
end;

function TfrmEditWitness.GetidWitness: integer;
begin
  result:=no.Value;
end;

procedure TfrmEditWitness.SetidEvent(AValue: integer);
begin
  if e.Value=AValue then Exit;
  e.Value:=AValue;
end;

procedure TfrmEditWitness.SetidWitness(AValue: integer);
begin
  if no.Value=AValue then Exit;
  no.Value:=AValue;
end;

procedure TfrmEditWitness.FormShow(Sender: TObject);
var
   j:integer;
//  code, nocode:string;
begin
  ActiveControl:=frmEditWitness.I;
  frmStemmaMainForm.DataHist.Row:=0;
  Caption:=Translation.Items[195];
  btnOK.Caption:=Translation.Items[152];
  btnCancel.Caption:=Translation.Items[164];
  Label2.Caption:=Translation.Items[196];
  Label3.Caption:=Translation.Items[197];
  Label4.Caption:=Translation.Items[172];
  Label5.Caption:=Translation.Items[198];
  Label6.Caption:=Translation.Items[173];
  // Populate le ComboBox
  FillResourceList(Role.Items, ptrint(
  frmEditEvents.Y.Items.Objects[frmEditEvents.Y.ItemIndex]));
  // Populate la form
 // dmGenData.GetCode(code,nocode);
  if no.Value=0 then
     begin
     Caption:=Translation.Items[48];
     I.Value:=-1;
     NomI.Text:='';
     No.Value:=0;
//     E.Value:=strtoint(nocode);
     X.Value:=1;
     Role.ItemIndex:=0;
     P.Text:='';
     label6.Visible:=true;
  end
  else
     begin
     dmGenData.Query1.SQL.Text:='SELECT W.no, W.I, W.E, W.X, W.P, W.R, N.N FROM W JOIN N ON W.I=N.I WHERE N.X=1 AND W.no=:idWitness';
     dmGenData.Query1.ParamByName('idWitness').AsInteger:=no.Value;
     dmGenData.Query1.Open;
     dmGenData.Query1.First;
     for j:=0 to Role.Items.Count-1 do
        if Role.Items[j]=dmGenData.Query1.Fields[5].AsString then
           Role.ItemIndex:=j;
//     No.Value:=dmGenData.Query1.Fields[0].AsInteger;
     I.Value:=dmGenData.Query1.Fields[1].AsInteger;
     X.Value:=dmGenData.Query1.Fields[3].AsInteger;
     E.Value:=dmGenData.Query1.Fields[2].AsInteger;
     NomI.Text:=DecodeName(dmGenData.Query1.Fields[6].AsString,1);
     P.Text:=dmGenData.Query1.Fields[4].AsString;
  end;
  // aller chercher la phrase par défaut
  dmGenData.Query1.SQL.Text:='SELECT Y.P FROM Y JOIN E ON E.Y=Y.no WHERE E.no='+E.Text;
  dmGenData.Query1.Open;
  dmGenData.Query1.First;
  P1.Text:=dmGenData.Query1.Fields[0].AsString;
  if length(P.text)=0 then
     begin
     P.Text:=P1.Text;
     label6.Visible:=true;
  end;
  P2.Text:=DecodePhrase(I.Value,Role.Text,P.Text,'E',E.Value);
end;

procedure TfrmEditWitness.btnOKClick(Sender: TObject);
var
   lidInd:integer;
   lDate, lEvType: String;


begin
  lidInd := i.Value;


  dmGenData.Query1.SQL.Clear;
  if no.Value=0 then
     begin
     If Label6.Visible then
        dmGenData.AppendWitness(Role.Items[Role.ItemIndex],'',lidInd,e.Value,1)
     else
        dmGenData.AppendWitness(Role.Items[Role.ItemIndex],trim(p.Text),lidInd,e.Value,1);
  end
  else
     begin
     If Label6.Visible then
        dmGenData.Query1.SQL.Add('UPDATE W SET R='''+UTF8ToANSI(Role.Items[Role.ItemIndex])+
          ''', I='+I.Text+', P='''' WHERE no='+no.text)
     else
        dmGenData.Query1.SQL.Add('UPDATE W SET R='''+UTF8ToANSI(Role.Items[Role.ItemIndex])+
          ''', I='+I.Text+', P='''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(trim(P.Text)),'\','\\'),'"','\"'),'''','\''')+
          ''' WHERE no='+no.text);
  end;
  if no.Value=0 then
     no.Value:=dmGenData.GetLastIDOfTable('W');
  // fr: Sauvegarder les modifications pour tout les témoins de l'événements
  // en: Save the changes for all the witnesses to the events
  dmGenData.Query3.SQL.Text:='SELECT W.I FROM W WHERE W.E='+E.Text;
  dmGenData.Query3.Open;
  dmGenData.Query3.First;
  While not dmGenData.Query3.EOF do
     begin
     dmGenData.SaveModificationTime(dmGenData.Query3.Fields[0].AsInteger);
     dmGenData.Query3.Next;
  end;
  // fr: Modifier la ligne de l'explorateur si naissance frmStemmaMainForm ou décès principal
  // en: Change the line of Explorer if birth frmStemmaMainForm or main death
  dmGenData.Query1.SQL.Text:='SELECT Y.Y, E.X, E.PD FROM Y JOIN E on E.Y=Y.no WHERE E.no='+E.Text;
  dmGenData.Query1.Open;
  lDate := dmGenData.Query1.Fields[2].AsString;
  lEvType:=dmGenData.Query1.Fields[0].AsString;

  if (lEvType='B') then
    dmGenData.UpdateNameI3(lDate, lidInd)
  else  if (lEvType='D') then
    dmGenData.UpdateNameI4(lDate, lidInd);

  if frmStemmaMainForm.actWinExplorer.Checked and
     ((lEvType='B') or ((lEvType='D'))) and
     (dmGenData.Query1.Fields[1].AsInteger=1) and (X.Text='1') then

     frmExplorer.UpdateIndexDates(lEvType, lDate, lidInd);

end;

procedure TfrmEditWitness.IEditingDone(Sender: TObject);
begin
  if length(I.Text)>0 then
     begin
     dmGenData.Query1.SQL.Text:='SELECT N.N FROM N WHERE N.X=1 AND N.I='+I.Text;
     dmGenData.Query1.Open;
     dmGenData.Query1.First;
     if not dmGenData.Query1.Eof then
        begin
        NomI.Text:=DecodeName(dmGenData.Query1.Fields[0].AsString,1);
        P2.Text:=DecodePhrase(I.Value,Role.Text,P.Text,'E',E.Value);
        frmStemmaMainForm.DataHist.InsertColRow(false,0);
        frmStemmaMainForm.DataHist.Cells[0,0]:='I';
        frmStemmaMainForm.DataHist.Cells[1,0]:=I.Text;
     end;
  end;
end;

procedure TfrmEditWitness.MenuItem1Click(Sender: TObject);
begin
  btnOKClick(Sender);
  ModalResult:=mrOk;
end;

procedure TfrmEditWitness.MenuItem2Click(Sender: TObject);
var
  j:integer;
  found:boolean;
begin
  if ActiveControl.Name='P' then
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
  if ActiveControl.Name='I' then
     begin
     found:=false;
     For j:=frmStemmaMainForm.DataHist.Row to frmStemmaMainForm.DataHist.RowCount-1 do
        begin
        if frmStemmaMainForm.DataHist.Cells[0,j]='I' then
           begin
           I.text:=frmStemmaMainForm.DataHist.Cells[1,j];
           IEditingDone(Sender);
           found:=true;
           break;
        end;
     end;
     if not found then
        begin
        For j:=0 to frmStemmaMainForm.DataHist.RowCount-1 do
           begin
           if frmStemmaMainForm.DataHist.Cells[0,j]='I' then
              begin
              I.text:=frmStemmaMainForm.DataHist.Cells[1,j];
              IEditingDone(Sender);
              found:=true;
              break;
           end;
        end;
     end;
  end;
  if found then frmStemmaMainForm.DataHist.Row:=j+1;
end;



end.

