unit frm_Sources;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  StdCtrls, Menus, FMUtils, StrUtils, LCLType, ActnList;

type

  { TfrmSources }

  TfrmSources = class(TForm)
    actSourceDelete: TAction;
    actSourceEdit: TAction;
    actSourceUsage: TAction;
    actSourceAdd: TAction;
    actSourceSortTitle: TAction;
    actSourceSortNumber: TAction;
    alsSource: TActionList;
    Button1: TButton;
    mniSourceSep2: TMenuItem;
    mniSourceAdd: TMenuItem;
    mniSourceEdit: TMenuItem;
    mniSourceDelete: TMenuItem;
    mniSourceSort: TMenuItem;
    mniSourceSep1: TMenuItem;
    mniSourceSortNumber: TMenuItem;
    mniSourceUsage: TMenuItem;
    mniSourceSortTitle: TMenuItem;
    mnuSource: TPopupMenu;
    TableauSources: TStringGrid;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mniSourceAddClick(Sender: TObject);
    procedure mniSourceDeleteClick(Sender: TObject);
    procedure mniSourceSortNumberClick(Sender: TObject);
    procedure mniSourceUsageClick(Sender: TObject);
    procedure mniSourceSortTitleClick(Sender: TObject);
    procedure TableauSourcesDblClick(Sender: TObject);
    procedure TableauSourcesEditingDone(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmSources: TfrmSources;

implementation

{ TODO 20 : F10 pour sortir de la fenêtre }
// Si j'ajoute un menu on le voit, faut trouver un moyen de mettre le
// shortcut pour sortir sans menu

uses
  frm_Main,cls_Translation, dm_GenData, frm_Usage, frm_EditSource;


{$R *.lfm}

{ TfrmSources }

procedure TfrmSources.FormResize(Sender: TObject);
begin
  TableauSources.Width := (Sender as Tform).Width-16;
  TableauSources.Height := (Sender as Tform).Height-51;
  Button1.Top:= (Sender as Tform).Height-35;
  Button1.Left:= (Sender as Tform).Width-80;
end;

procedure TfrmSources.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if CloseAction <> caMinimize then
     begin
       dmGenData.WriteCfgFormPosition(self);
       dmGenData.WriteCfgGridPosition(TableauSources as TStringGrid,6);
     end;
end;

procedure TfrmSources.FormShow(Sender: TObject);
var
  MyCursor: TCursor;
  lTable: TStringGrid;
  lNotification: TNotifyEvent;
begin
  dmGenData.ReadCfgFormPosition(frmSources,0,0,70,1000);
  dmGenData.ReadCfgGridPosition(frmSources.TableauSources as TStringGrid,6);
  Caption:=Translation.Items[218];
  Button1.Caption:=Translation.Items[152];
  TableauSources.Cells[2,0]:=Translation.Items[154];
  TableauSources.Cells[3,0]:=Translation.Items[155];
  TableauSources.Cells[4,0]:=Translation.Items[156];
  TableauSources.Cells[5,0]:=Translation.Items[219];
  TableauSources.Cells[6,0]:=Translation.Items[177];
  TableauSources.Cells[7,0]:=Translation.Items[158];
  mniSourceAdd.Caption:=Translation.Items[224];
  mniSourceEdit.Caption:=Translation.Items[225];
  mniSourceDelete.Caption:=Translation.Items[226];
  mniSourceSort.Caption:=Translation.Items[239];
  mniSourceSortNumber.Caption:=Translation.Items[246];
  mniSourceUsage.Caption:=Translation.Items[223];
  mniSourceSortTitle.Caption:=Translation.Items[247];
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

procedure TfrmSources.mniSourceAddClick(Sender: TObject);
begin
  // Ajouter une source
  frmEditSource.EditMode:=esem_AddNew;
  if frmEditSource.Showmodal = mrOK then
     // Reinitialize Form
     Formshow(Sender);
end;

procedure TfrmSources.mniSourceDeleteClick(Sender: TObject);
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

procedure TfrmSources.mniSourceSortNumberClick(Sender: TObject);
begin
  TableauSources.SortColRow(true,1);
end;

procedure TfrmSources.mniSourceUsageClick(Sender: TObject);
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
//     dmGenData.PutCode('S',TableauSources.Cells[2,TableauSources.Row]);
     frmShowUsage.UsageOf:=eSU_Sources;
     frmShowUsage.idLink:=ptrint(TableauSources.Objects[2,TableauSources.Row]);
     frmShowUsage.ShowModal;
  end;
end;

procedure TfrmSources.mniSourceSortTitleClick(Sender: TObject);
begin
  TableauSources.SortColRow(true,2);
end;

procedure TfrmSources.TableauSourcesDblClick(Sender: TObject);
var
  temp:string;
  auteur:boolean;
begin
  if TableauSources.Row>0 then
     begin
     frmEditSource.EditMode:=esem_EditExisting;
     frmEditSource.idSource:=ptrint( TableauSources.Objects[1,TableauSources.Row]);
     If frmEditSource.Showmodal=mrOK then
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

procedure TfrmSources.TableauSourcesEditingDone(Sender: TObject);
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

