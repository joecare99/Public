unit frm_Sources;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  StdCtrls, Menus, FMUtils, StrUtils, LCLType;

type

  { TFormSources }

  TFormSources = class(TForm)
    Button1: TButton;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    PopupMenu1: TPopupMenu;
    TableauSources: TStringGrid;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure TableauSourcesDblClick(Sender: TObject);
    procedure TableauSourcesEditingDone(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  FormSources: TFormSources;

implementation

{ TODO 20 : F10 pour sortir de la fenêtre }
// Si j'ajoute un menu on le voit, faut trouver un moyen de mettre le
// shortcut pour sortir sans menu

uses
  frm_Main,cls_Translation, dm_GenData, frm_Usage, frm_EditSource;


{$R *.lfm}

{ TFormSources }

procedure TFormSources.FormResize(Sender: TObject);
begin
  TableauSources.Width := (Sender as Tform).Width-16;
  TableauSources.Height := (Sender as Tform).Height-51;
  Button1.Top:= (Sender as Tform).Height-35;
  Button1.Left:= (Sender as Tform).Width-80;
end;

procedure TFormSources.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if CloseAction <> caMinimize then
     begin
       dmGenData.WriteCfgFormPosition(self);
       dmGenData.WriteCfgGridPosition(TableauSources as TStringGrid,6);
     end;
end;

procedure TFormSources.FormShow(Sender: TObject);
var
  MyCursor: TCursor;
  lTable: TStringGrid;
  lNotification: TNotifyEvent;
begin
  dmGenData.ReadCfgFormPosition(FormSources,0,0,70,1000);
  dmGenData.ReadCfgGridPosition(FormSources.TableauSources as TStringGrid,6);
  Caption:=Translation.Items[218];
  Button1.Caption:=Translation.Items[152];
  TableauSources.Cells[2,0]:=Translation.Items[154];
  TableauSources.Cells[3,0]:=Translation.Items[155];
  TableauSources.Cells[4,0]:=Translation.Items[156];
  TableauSources.Cells[5,0]:=Translation.Items[219];
  TableauSources.Cells[6,0]:=Translation.Items[177];
  TableauSources.Cells[7,0]:=Translation.Items[158];
  MenuItem2.Caption:=Translation.Items[224];
  MenuItem3.Caption:=Translation.Items[225];
  MenuItem4.Caption:=Translation.Items[226];
  MenuItem5.Caption:=Translation.Items[239];
  MenuItem7.Caption:=Translation.Items[246];
  MenuItem8.Caption:=Translation.Items[223];
  MenuItem9.Caption:=Translation.Items[247];
  MyCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  frmStemmaMainForm.ProgressBar.Position:=0;
  frmStemmaMainForm.ProgressBar.Visible:=True;
  Application.Processmessages;
  lTable:=TableauSources;
  lNotification:=@frmStemmaMainForm.UpdateProgressBar;
  dmGenData.FillSourcesTable(lNotification, lTable);
  frmStemmaMainForm.ProgressBar.Visible:=False;
  Screen.Cursor := MyCursor;
End;

procedure TFormSources.MenuItem2Click(Sender: TObject);
begin
  // Ajouter une source
  dmGenData.PutCode('S',0);
  dmGenData.PutCode('A',0);
  if EditSource.Showmodal = mrOK then
     Formshow(Sender);
end;

procedure TFormSources.MenuItem4Click(Sender: TObject);
begin
  // Supprimer une source
  if TableauSources.Row>0 then
     if TableauSources.Cells[7,TableauSources.Row]='0' then
        if Application.MessageBox(Pchar(Translation.Items[132]+
              TableauSources.Cells[2,TableauSources.Row]+
              Translation.Items[28]),pchar(SConfirmation),MB_YESNO)=IDYES then
           begin
           dmGenData.DeleteSourceFull(ptrint( TableauSources.Objects[1,TableauSources.Row]));
           TableauSources.DeleteRow(TableauSources.Row);
        end;
end;

procedure TFormSources.MenuItem7Click(Sender: TObject);
begin
  TableauSources.SortColRow(true,1);
end;

procedure TFormSources.MenuItem8Click(Sender: TObject);
var
  lSourceCitCount: LongInt;
  lidSource: PtrInt;
begin
  if TableauSources.Cells[7,TableauSources.Row]='?' then
     begin
     lidSource :=ptrint( TableauSources.Objects[1,TableauSources.Row]);
     lSourceCitCount:=dmGenData.GetSourceCitCount(lidSource);
     TableauSources.Cells[7,TableauSources.Row]:=inttostr(lSourceCitCount);
  end
  else
     begin
     dmGenData.PutCode('S',TableauSources.Cells[2,TableauSources.Row]);
     frmEventUsage.ShowModal;
  end;
end;

procedure TFormSources.MenuItem9Click(Sender: TObject);
begin
  TableauSources.SortColRow(true,2);
end;

procedure TFormSources.TableauSourcesDblClick(Sender: TObject);
var
  temp:string;
  auteur:boolean;
begin
  dmGenData.PutCode('S',0);
  if TableauSources.Row>0 then
     begin
     If EditSource.Showmodal=mrOK then
        // Ne pas repopuler toute la table, seulement la source modifiée.
        // FormShow(Sender);
       begin
        dmGenData.Query1.SQL.Clear;
        dmGenData.Query1.SQL.add('SELECT S.no, S.T, S.D, S.M, S.A, S.Q, COUNT(C.S) FROM S JOIN C on C.S=S.no WHERE S.no='+
                                  TableauSources.Cells[1,TableauSources.Row]);
        dmGenData.Query1.Open;
        dmGenData.Query1.First;
        TableauSources.Cells[1,TableauSources.Row]:=dmGenData.Query1.Fields[0].AsString;
        TableauSources.Cells[2,TableauSources.Row]:=dmGenData.Query1.Fields[1].AsString;
        TableauSources.Cells[3,TableauSources.Row]:=dmGenData.Query1.Fields[2].AsString;
        TableauSources.Cells[4,TableauSources.Row]:=dmGenData.Query1.Fields[3].AsString;
        TableauSources.Cells[5,TableauSources.Row]:=dmGenData.Query1.Fields[4].AsString;
        TableauSources.Cells[6,TableauSources.Row]:=dmGenData.Query1.Fields[5].AsString;
        TableauSources.Cells[7,TableauSources.Row]:=dmGenData.Query1.Fields[6].AsString;
        temp:=TableauSources.Cells[5,TableauSources.Row];
        auteur:=false;
        if (length(temp)>0) then
           if (temp[1] in ['0'..'9']) then
              auteur:=(StrtoInt(temp)>0);
        if auteur then
           begin
           dmGenData.Query2.SQL.Text:='SELECT N.I, N.N FROM N WHERE N.X=1 AND N.I='+temp;
           dmGenData.Query2.Open;
           TableauSources.Cells[5,TableauSources.Row]:=DecodeName(dmGenData.Query2.Fields[1].AsString,1)+
                                                       ' ('+temp+')';
           TableauSources.Cells[0,TableauSources.Row]:=temp;
        end;
     end;
  end;
  //  if StrToInt(TableauSources.Cells[0,TableauSources.Row])>0 then
  //     frmStemmaMainForm.sID:=TableauSources.Cells[0,TableauSources.Row];
end;

procedure TFormSources.TableauSourcesEditingDone(Sender: TObject);
var
  temp:string;
  auteur:boolean;
begin
  dmGenData.Query1.SQL.Clear;
  temp:=(Sender as TStringGrid).Cells[5,(Sender as TStringGrid).Row];
  auteur:=false;
  if (length(temp)>0) then
     if (temp[1] in ['0'..'9']) then
        auteur:=StrtoInt(temp)>0;
  if (not auteur) and (strtoint((Sender as TStringGrid).Cells[0,(Sender as TStringGrid).Row])>0) then
     begin
     dmGenData.Query2.SQL.Clear;
     dmGenData.Query2.SQL.add('SELECT N.I, N.N FROM N WHERE N.X=1 AND N.I='+(Sender as TStringGrid).Cells[0,(Sender as TStringGrid).Row]);
     dmGenData.Query2.Open;
     auteur:=(DecodeName(dmGenData.Query2.Fields[1].AsString,1)+' ('+(Sender as TStringGrid).Cells[0,(Sender as TStringGrid).Row]+')')=
             ((Sender as TStringGrid).Cells[5,(Sender as TStringGrid).Row]);
     temp:=(Sender as TStringGrid).Cells[0,(Sender as TStringGrid).Row];
     end;
  if auteur then
     begin
     dmGenData.Query2.SQL.Text:='SELECT N.I, N.N FROM N WHERE N.X=1 AND N.I='+temp;
     dmGenData.Query2.Open;
     (Sender as TStringGrid).Cells[5,(Sender as TStringGrid).Row]:=DecodeName(dmGenData.Query2.Fields[1].AsString,1)+
                                                                   ' ('+temp+')';
     (Sender as TStringGrid).Cells[0,(Sender as TStringGrid).Row]:=temp;
     dmGenData.Query1.SQL.Add('UPDATE S SET T='''+
        AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI((Sender as TStringGrid).Cells[2,(Sender as TStringGrid).Row]),'\','\\'),'"','\"'),'''','\''')+
        ''', D='''+
        AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI((Sender as TStringGrid).Cells[3,(Sender as TStringGrid).Row]),'\','\\'),'"','\"'),'''','\''')+
        ''', M='''+
        AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI((Sender as TStringGrid).Cells[4,(Sender as TStringGrid).Row]),'\','\\'),'"','\"'),'''','\''')+
        ''', A='''+(Sender as TStringGrid).Cells[0,(Sender as TStringGrid).Row]+
        ''', Q='+(Sender as TStringGrid).Cells[6,(Sender as TStringGrid).Row]+
        ' WHERE no='+(Sender as TStringGrid).Cells[1,(Sender as TStringGrid).Row]);
  end
  else
     dmGenData.Query1.SQL.Add('UPDATE S SET T='''+
       AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI((Sender as TStringGrid).Cells[2,(Sender as TStringGrid).Row]),'\','\\'),'"','\"'),'''','\''')+
       ''', D='''+
       AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI((Sender as TStringGrid).Cells[3,(Sender as TStringGrid).Row]),'\','\\'),'"','\"'),'''','\''')+
       ''', M='''+
       AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI((Sender as TStringGrid).Cells[4,(Sender as TStringGrid).Row]),'\','\\'),'"','\"'),'''','\''')+
       ''', A='''+
       AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI((Sender as TStringGrid).Cells[5,(Sender as TStringGrid).Row]),'\','\\'),'"','\"'),'''','\''')+
       ''', Q='+(Sender as TStringGrid).Cells[6,(Sender as TStringGrid).Row]+
       ' WHERE no='+(Sender as TStringGrid).Cells[1,(Sender as TStringGrid).Row]);
  dmGenData.Query1.ExecSQL;
end;

end.

