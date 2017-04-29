unit frm_Places;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, Menus, StrUtils, FMUtils, LCLtype;

type

  { TFormLieux }

  TFormLieux = class(TForm)
    Button1: TButton;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    O: TEdit;
    PopupMenu1: TPopupMenu;
    TableauLieux: TStringGrid;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure TableauLieuxEditingDone(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  FormLieux: TFormLieux;

implementation

uses frm_Main, Traduction, dm_GenData, frm_Usage;

{$R *.lfm}

{ TFormLieux }

procedure TFormLieux.FormResize(Sender: TObject);
begin
  TableauLieux.Width := (Sender as Tform).Width-16;
  TableauLieux.Height := (Sender as Tform).Height-51;
  Button1.Top:= (Sender as Tform).Height-35;
  Button1.Left:= (Sender as Tform).Width-80;
end;

procedure TFormLieux.FormShow(Sender: TObject);
var
  i, pos1, pos2:integer;
  LA, L0,L1,L2,L3,L4,Lieu:string;
  MyCursor: TCursor;
begin
  Caption:=Traduction.Items[207];
  Button1.Caption:=Traduction.Items[152];
  TableauLieux.Cells[2,0]:=Traduction.Items[208];
  TableauLieux.Cells[3,0]:=Traduction.Items[209];
  TableauLieux.Cells[4,0]:=Traduction.Items[210];
  TableauLieux.Cells[5,0]:=Traduction.Items[211];
  TableauLieux.Cells[6,0]:=Traduction.Items[212];
  TableauLieux.Cells[7,0]:=Traduction.Items[213];
  TableauLieux.Cells[8,0]:=Traduction.Items[158];
  MenuItem1.Caption:=Traduction.Items[239];
  MenuItem2.Caption:=Traduction.Items[240];
  MenuItem3.Caption:=Traduction.Items[241];
  MenuItem4.Caption:=Traduction.Items[242];
  MenuItem5.Caption:=Traduction.Items[243];
  MenuItem6.Caption:=Traduction.Items[244];
  MenuItem7.Caption:=Traduction.Items[245];
  MenuItem8.Caption:=Traduction.Items[223];
  MenuItem11.Caption:=Traduction.Items[226];
  MyCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  frmStemmaMainForm.ProgressBar.Position:=0;
  frmStemmaMainForm.ProgressBar.Visible:=True;
  Application.Processmessages;
  dmGenData.Query1.SQL.Clear;
  dmGenData.Query1.SQL.add('SELECT L.no, L.L, COUNT(E.L) FROM L JOIN E on E.L=L.no GROUP by L.no');
  dmGenData.Query1.Open;
  dmGenData.Query1.First;
  TableauLieux.RowCount:=dmGenData.Query1.RecordCount+1;
  frmStemmaMainForm.ProgressBar.Max:=TableauLieux.RowCount;
  i:=0;
  While not dmGenData.Query1.Eof do
     begin
     i:=i+1;
     TableauLieux.Cells[0,i]:=dmGenData.Query1.Fields[0].AsString;
     TableauLieux.Cells[1,i]:=dmGenData.Query1.Fields[0].AsString;
     Lieu:=dmGenData.Query1.Fields[1].AsString;
     if Copy(Lieu,1,4)='!TMG' then
        begin
        LA:='';
        Lieu:=Copy(Lieu,AnsiPos('|',Lieu)+1,Length(Lieu));
        L0:=Copy(Lieu,1,AnsiPos('|',Lieu)-1);
        Lieu:=Copy(Lieu,AnsiPos('|',Lieu)+1,Length(Lieu));
        L1:=Copy(Lieu,1,AnsiPos('|',Lieu)-1);
        Lieu:=Copy(Lieu,AnsiPos('|',Lieu)+1,Length(Lieu));
        L2:=Copy(Lieu,1,AnsiPos('|',Lieu)-1);
        Lieu:=Copy(Lieu,AnsiPos('|',Lieu)+1,Length(Lieu));
        L3:=Copy(Lieu,1,AnsiPos('|',Lieu)-1);
        Lieu:=Copy(Lieu,AnsiPos('|',Lieu)+1,Length(Lieu));
        L4:=Copy(Lieu,1,AnsiPos('|',Lieu)-1);
     end
     else
        begin
        Pos1:=AnsiPos('<'+CTagNameArticle+'>',Lieu)+Length(CTagNameArticle)+2;
        Pos2:=AnsiPos('</'+CTagNameArticle+'>',Lieu);
        if (Pos1+Pos2)>(Length(CTagNameDetail)+2) then
           LA:=Copy(Lieu,Pos1,Pos2-Pos1)
        else
           LA:='';
        Pos1:=AnsiPos('<'+CTagNameDetail+'>',Lieu)+(Length(CTagNameDetail)+2);
        Pos2:=AnsiPos('</'+CTagNameDetail+'>',Lieu);
        if (Pos1+Pos2)>(Length(CTagNameDetail)+2) then
           L0:=Copy(Lieu,Pos1,Pos2-Pos1)
        else
           L0:='';
        Pos1:=AnsiPos('<Ville>',Lieu)+7;
        Pos2:=AnsiPos('</Ville>',Lieu);
        if (Pos1+Pos2)>7 then
           L1:=Copy(Lieu,Pos1,Pos2-Pos1)
        else
           L1:='';
        Pos1:=AnsiPos('<Région>',Lieu)+9;
        Pos2:=AnsiPos('</Région>',Lieu);
        if (Pos1+Pos2)>9 then
           L2:=Copy(Lieu,Pos1,Pos2-Pos1)
        else
           L2:='';
        Pos1:=AnsiPos('<Province>',Lieu)+10;
        Pos2:=AnsiPos('</Province>',Lieu);
        if (Pos1+Pos2)>10 then
           L3:=Copy(Lieu,Pos1,Pos2-Pos1)
        else
           L3:='';
        Pos1:=AnsiPos('<Pays>',Lieu)+6;
        Pos2:=AnsiPos('</Pays>',Lieu);
        if (Pos1+Pos2)>6 then
           L4:=Copy(Lieu,Pos1,Pos2-Pos1)
        else
           L4:='';
     end;
     TableauLieux.Cells[2,i]:=LA;
     TableauLieux.Cells[3,i]:=L0;
     TableauLieux.Cells[4,i]:=L1;
     TableauLieux.Cells[5,i]:=L2;
     TableauLieux.Cells[6,i]:=L3;
     TableauLieux.Cells[7,i]:=L4;
     TableauLieux.Cells[8,i]:=dmGenData.Query1.Fields[2].AsString;
     dmGenData.Query1.Next;
     frmStemmaMainForm.ProgressBar.Position:=frmStemmaMainForm.ProgressBar.Position+1;
     Application.ProcessMessages;
  end;
  O.Text:='2';
  TableauLieux.SortColRow(true,3);
  frmStemmaMainForm.ProgressBar.Visible:=False;
  Screen.Cursor := MyCursor;
end;

procedure TFormLieux.MenuItem11Click(Sender: TObject);
var
  lieu:string;
begin
  // Supprimer un lieu
  if TableauLieux.Row>0 then
     if TableauLieux.Cells[8,TableauLieux.Row]='0' then
        begin
        Lieu:='';
        if Length(trim(TableauLieux.Cells[3,TableauLieux.Row]))>0 then
           Lieu:=trim(TableauLieux.Cells[3,TableauLieux.Row]);
        if Length(trim(TableauLieux.Cells[4,TableauLieux.Row]))>0 then
           if length(Lieu)=0 then
              Lieu:=trim(TableauLieux.Cells[4,TableauLieux.Row])
           else
              Lieu:=Lieu+', '+trim(TableauLieux.Cells[4,TableauLieux.Row]);
        if Length(trim(TableauLieux.Cells[5,TableauLieux.Row]))>0 then
           if length(Lieu)=0 then
              Lieu:=trim(TableauLieux.Cells[5,TableauLieux.Row])
           else
              Lieu:=Lieu+', '+trim(TableauLieux.Cells[5,TableauLieux.Row]);
        if Length(trim(TableauLieux.Cells[6,TableauLieux.Row]))>0 then
           if length(Lieu)=0 then
              Lieu:=trim(TableauLieux.Cells[6,TableauLieux.Row])
           else
              Lieu:=Lieu+', '+trim(TableauLieux.Cells[6,TableauLieux.Row]);
        if Length(trim(TableauLieux.Cells[7,TableauLieux.Row]))>0 then
           if length(Lieu)=0 then
              Lieu:=trim(TableauLieux.Cells[7,TableauLieux.Row])
           else
              Lieu:=Lieu+', '+trim(TableauLieux.Cells[7,TableauLieux.Row]);
        if Application.MessageBox(Pchar(Traduction.Items[125]+
              Lieu+
              Traduction.Items[28]),pchar(Traduction.Items[1]),MB_YESNO)=IDYES then
           begin
           dmGenData.Query1.SQL.Text:='DELETE FROM L WHERE no='+TableauLieux.Cells[0,TableauLieux.Row];
           dmGenData.Query1.ExecSQL;
           TableauLieux.DeleteRow(TableauLieux.Row);
        end;
     end;
end;

procedure TFormLieux.MenuItem2Click(Sender: TObject);
begin
  O.Text:='1';
  TableauLieux.SortColRow(true,3);
end;

procedure TFormLieux.MenuItem3Click(Sender: TObject);
begin
  O.Text:='2';
  TableauLieux.SortColRow(true,4);
end;

procedure TFormLieux.MenuItem4Click(Sender: TObject);
begin
  O.Text:='3';
  TableauLieux.SortColRow(true,5);
end;

procedure TFormLieux.MenuItem5Click(Sender: TObject);
begin
  O.Text:='4';
  TableauLieux.SortColRow(true,6);
end;

procedure TFormLieux.MenuItem6Click(Sender: TObject);
begin
  O.Text:='5';
  TableauLieux.SortColRow(true,7);
end;

procedure TFormLieux.MenuItem7Click(Sender: TObject);
var
  no,Lieu,Lieu2:string;
begin
  Lieu:='';
  if Length(trim(TableauLieux.Cells[3,TableauLieux.Row]))>0 then
     Lieu:=trim(TableauLieux.Cells[3,TableauLieux.Row]);
  if Length(trim(TableauLieux.Cells[4,TableauLieux.Row]))>0 then
     if length(Lieu)=0 then
        Lieu:=trim(TableauLieux.Cells[4,TableauLieux.Row])
     else
        Lieu:=Lieu+', '+trim(TableauLieux.Cells[4,TableauLieux.Row]);
  if Length(trim(TableauLieux.Cells[5,TableauLieux.Row]))>0 then
     if length(Lieu)=0 then
        Lieu:=trim(TableauLieux.Cells[5,TableauLieux.Row])
     else
        Lieu:=Lieu+', '+trim(TableauLieux.Cells[5,TableauLieux.Row]);
  if Length(trim(TableauLieux.Cells[6,TableauLieux.Row]))>0 then
     if length(Lieu)=0 then
        Lieu:=trim(TableauLieux.Cells[6,TableauLieux.Row])
     else
        Lieu:=Lieu+', '+trim(TableauLieux.Cells[6,TableauLieux.Row]);
  if Length(trim(TableauLieux.Cells[7,TableauLieux.Row]))>0 then
     if length(Lieu)=0 then
        Lieu:=trim(TableauLieux.Cells[7,TableauLieux.Row])
     else
        Lieu:=Lieu+', '+trim(TableauLieux.Cells[7,TableauLieux.Row]);
  no := InputBox(Traduction.Items[119],Traduction.Items[120]+Lieu+Traduction.Items[121],'');
  if StrtoInt(no)>0 then
     begin
     dmGenData.Query1.SQL.Text:='SELECT L.no, L.L FROM L WHERE L.no='+no;
     dmGenData.Query1.Open;
     Lieu2:=DecodeChanged(dmGenData.Query1.Fields[1].AsString);
     if Lieu2<>Lieu then
        Application.MessageBox(Pchar(Traduction.Items[122]+
           Lieu+Traduction.Items[123]+Lieu2+')'),pchar(Traduction.Items[124]),0)
     else
        begin
        dmGenData.Query1.SQL.Text:='UPDATE E SET L='+no+
          ' WHERE L='+TableauLieux.Cells[0,TableauLieux.Row];
        dmGenData.Query1.ExecSQL;
        // DELETE OLD LIEU
        dmGenData.Query1.SQL.Text:='DELETE FROM L WHERE no='+TableauLieux.Cells[0,TableauLieux.Row];
        dmGenData.Query1.ExecSQL;
     end;
  end;
end;

procedure TFormLieux.MenuItem8Click(Sender: TObject);
var
  Lieu:string;
begin
  Lieu:='';
  if Length(trim(TableauLieux.Cells[3,TableauLieux.Row]))>0 then
     Lieu:=trim(TableauLieux.Cells[3,TableauLieux.Row]);
  if Length(trim(TableauLieux.Cells[4,TableauLieux.Row]))>0 then
     if length(Lieu)=0 then
        Lieu:=trim(TableauLieux.Cells[4,TableauLieux.Row])
     else
        Lieu:=Lieu+', '+trim(TableauLieux.Cells[4,TableauLieux.Row]);
  if Length(trim(TableauLieux.Cells[5,TableauLieux.Row]))>0 then
     if length(Lieu)=0 then
        Lieu:=trim(TableauLieux.Cells[5,TableauLieux.Row])
     else
        Lieu:=Lieu+', '+trim(TableauLieux.Cells[5,TableauLieux.Row]);
  if Length(trim(TableauLieux.Cells[6,TableauLieux.Row]))>0 then
     if length(Lieu)=0 then
        Lieu:=trim(TableauLieux.Cells[6,TableauLieux.Row])
     else
        Lieu:=Lieu+', '+trim(TableauLieux.Cells[6,TableauLieux.Row]);
  if Length(trim(TableauLieux.Cells[7,TableauLieux.Row]))>0 then
     if length(Lieu)=0 then
        Lieu:=trim(TableauLieux.Cells[7,TableauLieux.Row])
     else
        Lieu:=Lieu+', '+trim(TableauLieux.Cells[7,TableauLieux.Row]);
  dmGenData.PutCode('L',Lieu);
  frmEventUsage.ShowModal;
end;

procedure TFormLieux.TableauLieuxEditingDone(Sender: TObject);
var
  Lieu:string;
begin
  Lieu:='';
  if Length(trim(TableauLieux.Cells[2,TableauLieux.Row]))>0 then
     Lieu:='<'+CTagNameArticle+'>'+trim(TableauLieux.Cells[2,TableauLieux.Row])+'</'+CTagNameArticle+'>';
  if Length(trim(TableauLieux.Cells[3,TableauLieux.Row]))>0 then
     Lieu:='<'+CTagNameDetail+'>'+trim(TableauLieux.Cells[3,TableauLieux.Row])+'</'+CTagNameDetail+'>';
  if Length(trim(TableauLieux.Cells[4,TableauLieux.Row]))>0 then
     Lieu:=Lieu+'<Ville>'+trim(TableauLieux.Cells[4,TableauLieux.Row])+'</Ville>';
  if Length(trim(TableauLieux.Cells[5,TableauLieux.Row]))>0 then
     Lieu:=Lieu+'<Région>'+trim(TableauLieux.Cells[5,TableauLieux.Row])+'</Région>';
  if Length(trim(TableauLieux.Cells[6,TableauLieux.Row]))>0 then
     Lieu:=Lieu+'<Province>'+trim(TableauLieux.Cells[6,TableauLieux.Row])+'</Province>';
  if Length(trim(TableauLieux.Cells[7,TableauLieux.Row]))>0 then
     Lieu:=Lieu+'<Pays>'+trim(TableauLieux.Cells[7,TableauLieux.Row])+'</Pays>';
  dmGenData.Query1.SQL.Clear;
  dmGenData.Query1.SQL.Add('UPDATE L SET L='''+
    AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(Lieu),'\','\\'),'"','\"'),'''','\''')+
    ''' WHERE no='+TableauLieux.Cells[0,TableauLieux.Row]);
  dmGenData.Query1.ExecSQL;
end;

end.

